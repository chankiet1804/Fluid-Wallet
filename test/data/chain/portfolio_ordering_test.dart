import 'package:decimal/decimal.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_chain_registry.dart';

/// How the token list is ordered, and what the single-chain view is allowed to
/// invent.
///
/// The second half matters more than it looks: padding a chain out to its full
/// token set means printing `0` for holdings nobody asked about, and printing
/// zero for a balance the app never read is the one display bug §4.7 singles
/// out — the user reads it as a drained wallet.
void main() {
  late ChainRegistry registry;

  setUpAll(() => registry = loadTestChainRegistry());

  int chainOrderOf(int chainId) => registry.chain(chainId)!.sortOrder;

  TokenBalance balanceOf(TokenInfo token, String amount, {String? usd}) =>
      TokenBalance(
        token: token,
        amount: TokenAmount.parse(amount, decimals: token.decimals),
        fiat: usd == null
            ? null
            : FiatValue(currency: 'USD', value: Decimal.parse(usd)),
      );

  TokenBalance nativeOf(int chainId, String amount, {String? usd}) => balanceOf(
    registry.tokensOf(chainId).firstWhere((t) => t.isNative),
    amount,
    usd: usd,
  );

  /// A non-native registry token on [chainId].
  TokenInfo erc20On(int chainId) =>
      registry.tokensOf(chainId).firstWhere((t) => !t.isNative);

  PortfolioSnapshot snapshotOf({
    List<TokenBalance> balances = const [],
    List<ChainFailure> failures = const [],
  }) => PortfolioSnapshot(
    address: '0xabc',
    balances: balances,
    currency: 'USD',
    fetchedAt: DateTime(2026),
    failures: failures,
  );

  group('sortPortfolioBalances', () {
    test('groups by chain even when a later chain holds more value', () {
      // Ethereum leads the registry file but holds the least here. Before
      // grouping, value alone decided and the chains interleaved.
      final list = [
        nativeOf(8453, '1', usd: '500'),
        nativeOf(1, '1', usd: '10'),
        nativeOf(56, '5', usd: '1000'),
      ];
      sortPortfolioBalances(list, registry);

      expect(list.map((b) => b.chainId), orderedEquals([1, 56, 8453]));
      expect(
        list.map((b) => chainOrderOf(b.chainId)),
        orderedEquals([chainOrderOf(1), chainOrderOf(56), chainOrderOf(8453)]),
      );
    });

    test('a chain\'s holdings stay one contiguous run', () {
      final list = [
        balanceOf(erc20On(8453), '9', usd: '9'),
        nativeOf(1, '1', usd: '10'),
        nativeOf(8453, '1', usd: '500'),
        balanceOf(erc20On(1), '2', usd: '2'),
      ];
      sortPortfolioBalances(list, registry);

      expect(list.map((b) => b.chainId), orderedEquals([1, 1, 8453, 8453]));
    });

    test('within a chain: native first, then by fiat value descending', () {
      final native = nativeOf(1, '1', usd: '10');
      final token = erc20On(1);
      final rich = balanceOf(token, '1000', usd: '1000');

      final list = [rich, native];
      sortPortfolioBalances(list, registry);

      expect(list.first.token.isNative, isTrue);
      expect(list[1].ref, rich.ref);
    });

    test('among non-native tokens, an unpriced one sorts last', () {
      final tokens = registry.tokensOf(1).where((t) => !t.isNative).toList();
      final priced = balanceOf(tokens[0], '1', usd: '1');
      final unpriced = balanceOf(tokens[1], '9999');

      final list = [unpriced, priced];
      sortPortfolioBalances(list, registry);

      // A large amount with no quote must not outrank a small priced holding —
      // there is no value to compare it on.
      expect(list.first.ref, priced.ref);
      expect(list[1].ref, unpriced.ref);
    });
  });

  group('visiblePortfolioProvider padding', () {
    ProviderContainer containerWith(
      PortfolioSnapshot snapshot, {
      int? filter,
    }) {
      final container = ProviderContainer(
        overrides: [
          chainRegistryProvider.overrideWithValue(registry),
          currentPortfolioProvider.overrideWithValue(AsyncValue.data(snapshot)),
        ],
      );
      addTearDown(container.dispose);
      if (filter != null) {
        container.read(chainFilterProvider.notifier).select(filter);
      }
      return container;
    }

    PortfolioSnapshot visible(ProviderContainer c) =>
        c.read(visiblePortfolioProvider).requireValue;

    test('all networks shows every chain\'s native coin, funded or not', () {
      final held = [nativeOf(1, '1', usd: '10')];
      final result = visible(containerWith(snapshotOf(balances: held)));

      final natives = result.balances.where((b) => b.token.isNative);
      expect(
        natives.map((b) => b.chainId).toSet(),
        registry.chains.map((c) => c.chainId).toSet(),
      );
      // Only the natives are invented — all networks must not turn into a
      // catalogue of every token on eight chains.
      expect(
        result.balances.where((b) => b.amount.isZero).every(
          (b) => b.token.isNative,
        ),
        isTrue,
      );
    });

    test('a zero native leads its own chain block, not the list tail', () {
      // The held USDC is on Base; Base's ETH has no balance and still has to
      // sit above it rather than being appended after every other chain.
      final usdc = balanceOf(erc20On(8453), '100', usd: '100');
      final result = visible(containerWith(snapshotOf(balances: [usdc])));

      final base = result.balances.where((b) => b.chainId == 8453).toList();
      expect(base.first.token.isNative, isTrue);
      expect(base.first.amount.isZero, isTrue);
      expect(base[1].ref, usdc.ref);

      // And the chain blocks are still contiguous and in registry order.
      final orders = result.balances
          .map((b) => registry.chain(b.chainId)!.sortOrder)
          .toList();
      expect(orders, orderedEquals(List.of(orders)..sort()));
    });

    test('all networks: a failed chain gets no invented native', () {
      final result = visible(
        containerWith(
          snapshotOf(
            balances: [nativeOf(1, '1', usd: '10')],
            failures: const [
              ChainFailure(chainId: 8453, kind: ChainFailureKind.network),
            ],
          ),
        ),
      );

      expect(result.balances.any((b) => b.chainId == 8453), isFalse);
      // The chains that did answer are unaffected.
      expect(result.balances.any((b) => b.chainId == 56), isTrue);
    });

    test('padding all networks does not move the total', () {
      final result = visible(
        containerWith(snapshotOf(balances: [nativeOf(1, '1', usd: '10')])),
      );

      expect(result.total.value, Decimal.parse('10'));
      expect(result.isComplete, isTrue);
    });

    test('one chain lists every registry token, the empty ones at zero', () {
      final held = nativeOf(8453, '1', usd: '2500');
      final result = visible(
        containerWith(snapshotOf(balances: [held]), filter: 8453),
      );

      final expected = registry.tokensOf(8453).map((t) => t.ref).toSet();
      expect(result.balances.map((b) => b.ref).toSet(), expected);

      // The held one leads; the padding lands after it, in registry order.
      expect(result.balances.first.ref, held.ref);
      final padded = result.balances.skip(1).toList();
      expect(padded, isNotEmpty);
      expect(padded.every((b) => b.amount.isZero), isTrue);
      expect(
        padded.map((b) => b.ref),
        orderedEquals(
          registry
              .tokensOf(8453)
              .where((t) => t.ref != held.ref)
              .map((t) => t.ref),
        ),
      );
    });

    test('padding keeps its own decimals and prices at an exact zero', () {
      final result = visible(
        containerWith(snapshotOf(), filter: 8453),
      );

      for (final b in result.balances) {
        expect(b.amount.decimals, b.token.decimals);
        expect(b.amount.raw, BigInt.zero);
        expect(b.fiat?.value, Decimal.zero);
      }

      // A null fiat here would count as unpriced and make the screen call a
      // complete total a lower bound.
      expect(result.unpricedCount, 0);
      expect(result.isComplete, isTrue);
      expect(result.total.value, Decimal.zero);
    });

    test('padding never moves the total', () {
      final held = nativeOf(8453, '1', usd: '2500');
      final result = visible(
        containerWith(snapshotOf(balances: [held]), filter: 8453),
      );

      expect(result.total.value, Decimal.parse('2500'));
      expect(result.isComplete, isTrue);
    });

    test('a failed chain is NOT padded — no invented zeroes', () {
      // The whole reason the guard exists: a list of every token at $0.00 for a
      // chain the app could not read says "you have nothing" about data it
      // never saw.
      final result = visible(
        containerWith(
          snapshotOf(
            failures: const [
              ChainFailure(chainId: 8453, kind: ChainFailureKind.network),
            ],
          ),
          filter: 8453,
        ),
      );

      expect(result.balances, isEmpty);
      expect(result.hasFailures, isTrue);
    });
  });
}
