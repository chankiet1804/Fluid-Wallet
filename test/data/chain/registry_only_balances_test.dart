import 'package:dio/dio.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/token_metadata_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_chain_registry.dart';

/// The balance endpoint is a discovery API: it returns every contract the
/// address holds, spam included. These tests lock in that
/// `assets/config/chains-default.json` is the token universe — anything else is
/// dropped without spending a metadata or price request on it.
class _ThrowingMetadataRepository extends TokenMetadataRepository {
  _ThrowingMetadataRepository() : super(Dio());

  @override
  Future<TokenInfo?> fetch(AssetRef ref, ChainInfo chain) async =>
      fail('metadata was fetched for an unlisted contract: ${ref.address}');
}

void main() {
  const address = '0xabc';
  const baseChainId = 8453;

  late ChainRegistry registry;
  late TokenInfo native;
  late TokenInfo listed;

  setUpAll(() {
    registry = loadTestChainRegistry();
    final tokens = registry.tokensOf(baseChainId);
    native = tokens.firstWhere((t) => t.isNative);
    listed = tokens.firstWhere((t) => !t.isNative);
  });

  // A contract the registry does not list — the shape of an airdrop.
  final unlisted = AssetRef(
    baseChainId,
    '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef',
  );

  ProviderContainer containerWith(
    Map<AssetRef, BigInt> balances, {
    void Function(PriceQuery)? onPriceQuery,
  }) {
    final container = ProviderContainer(
      overrides: [
        chainRegistryProvider.overrideWithValue(registry),
        rawBalancesProvider(address).overrideWith(
          (ref) =>
              RawBalanceResult(balances: balances, fetchedAt: DateTime(2026)),
        ),
        tokenMetadataRepositoryProvider.overrideWithValue(
          _ThrowingMetadataRepository(),
        ),
        pricesProvider.overrideWith((ref, query) {
          onPriceQuery?.call(query);
          return const <AssetRef, FiatPrice>{};
        }),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('a contract outside the registry is dropped, not looked up', () async {
    final container = containerWith({
      native.ref: BigInt.from(1000000000000000000),
      listed.ref: BigInt.from(5000000),
      unlisted: BigInt.from(999),
    });

    final resolved = await container.read(
      resolvedTokensProvider(address).future,
    );

    expect(resolved.balances.map((b) => b.ref), [native.ref, listed.ref]);
    // Nothing is parked for later either: the token simply does not exist here.
    expect(resolved.unresolved, isEmpty);
  });

  test('unlisted contracts never reach the price query', () async {
    final queries = <PriceQuery>[];
    final container = containerWith({
      native.ref: BigInt.from(1000000000000000000),
      unlisted: BigInt.from(999),
    }, onPriceQuery: queries.add);

    await container.read(portfolioProvider(address).future);

    // A single batched `/simple/price` by coingeckoId, with no contract-address
    // lookup riding along.
    expect(queries, hasLength(1));
    expect(queries.single.refs, [native.ref]);
  });

  test(
    'dropping an unlisted contract does not mark the snapshot partial',
    () async {
      // Registry membership is a definition, not a failed fetch: the total stays
      // confident. Only a chain failure or a missing price may downgrade it.
      final container = containerWith({
        native.ref: BigInt.from(1000000000000000000),
        unlisted: BigInt.from(999),
      });

      final snapshot = await container.read(portfolioProvider(address).future);

      expect(snapshot.unresolved, isEmpty);
      expect(snapshot.balances, hasLength(1));
      // Native has no price in this container, so incompleteness here comes from
      // `unpricedCount` alone — never from the dropped contract.
      expect(snapshot.unpricedCount, 1);
    },
  );
}
