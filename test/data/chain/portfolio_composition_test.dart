import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/chain_registry_repository.dart';
import 'package:fluid_wallet/features/wallet/portfolio/portfolio_format.dart';
import 'package:flutter_test/flutter_test.dart';

/// The "never show a wrong total" invariant, asserted directly.
///
/// The failure this guards against: one chain of several times out, its
/// holdings drop out of the sum, the headline number falls 40%, and the user
/// reads it as having been robbed.
void main() {
  late ChainRegistry registry;

  setUpAll(() {
    registry = const ChainRegistryRepository().parse(
      File(ChainRegistryRepository.assetPath).readAsStringSync(),
    );
  });

  TokenInfo tokenOn(int chainId) =>
      registry.tokensOf(chainId).firstWhere((t) => t.isNative);

  TokenBalance balance(int chainId, String amount, {String? usd}) {
    final token = tokenOn(chainId);
    return TokenBalance(
      token: token,
      amount: TokenAmount.parse(amount, decimals: token.decimals),
      fiat: usd == null
          ? null
          : FiatValue(currency: 'USD', value: Decimal.parse(usd)),
    );
  }

  PortfolioSnapshot snapshot({
    List<TokenBalance> balances = const [],
    List<ChainFailure> failures = const [],
    List<UnresolvedAsset> unresolved = const [],
    int unpriced = 0,
  }) => PortfolioSnapshot(
    address: '0xabc',
    balances: balances,
    currency: 'USD',
    fetchedAt: DateTime(2026),
    failures: failures,
    unresolved: unresolved,
    unpricedCount: unpriced,
  );

  group('total', () {
    test('sums priced holdings exactly', () {
      final s = snapshot(
        balances: [
          balance(1, '1', usd: '2500.55'),
          balance(8453, '2', usd: '5001.10'),
        ],
      );

      expect(s.total.value, Decimal.parse('7501.65'));
      expect(s.isComplete, isTrue);
      expect(formatPortfolioTotal(s), (text: r'$7,501.65', isPartial: false));
    });

    test(
      'an unpriced holding is excluded and marks the total a lower bound',
      () {
        final s = snapshot(
          balances: [
            balance(1, '1', usd: '2500'),
            balance(56, '3'),
          ],
          unpriced: 1,
        );

        expect(s.total.value, Decimal.parse('2500'));
        expect(s.isComplete, isFalse);

        final formatted = formatPortfolioTotal(s);
        expect(formatted.isPartial, isTrue);
        expect(formatted.text, startsWith('≥'));
        expect(portfolioIncompleteReason(s, registry), contains('no price'));
      },
    );

    test('a failed chain contributes nothing but is announced', () {
      final s = snapshot(
        balances: [balance(1, '1', usd: '2500')],
        failures: const [
          ChainFailure(chainId: 8453, kind: ChainFailureKind.network),
          ChainFailure(chainId: 56, kind: ChainFailureKind.rateLimited),
        ],
      );

      expect(s.isComplete, isFalse);
      expect(s.hasFailures, isTrue);

      final reason = portfolioIncompleteReason(s, registry)!;
      expect(reason, contains('2 networks'));
      expect(reason, contains('lower bound'));
    });

    test('an unidentified token contributes nothing to the total', () {
      // No trustworthy `decimals` means no trustworthy amount, so it must not
      // reach the sum by any route.
      final s = snapshot(
        balances: [balance(1, '1', usd: '2500')],
        unresolved: [
          UnresolvedAsset(
            ref: AssetRef(1, '0x1111111111111111111111111111111111111111'),
            rawBalance: BigInt.from(999999999),
          ),
        ],
      );

      expect(s.total.value, Decimal.parse('2500'));
      expect(s.isComplete, isFalse);
      expect(
        portfolioIncompleteReason(s, registry),
        contains('could not be identified'),
      );
    });

    test('an empty successful snapshot is a real zero, not a partial one', () {
      final s = snapshot();
      expect(s.isComplete, isTrue);
      expect(formatPortfolioTotal(s), (text: r'$0.00', isPartial: false));
    });
  });

  group('filteredTo', () {
    test('narrows balances, failures and the unpriced count together', () {
      final s = snapshot(
        balances: [
          balance(1, '1', usd: '2500'),
          balance(8453, '2', usd: '5000'),
          balance(8453, '3'),
        ],
        failures: const [
          ChainFailure(chainId: 56, kind: ChainFailureKind.network),
        ],
        unpriced: 1,
      );

      final base = s.filteredTo(8453);
      expect(base.balances, hasLength(2));
      expect(base.total.value, Decimal.parse('5000'));
      // The BNB Chain failure is not this view's problem...
      expect(base.failures, isEmpty);
      // ...but the unpriced token in view still is.
      expect(base.unpricedCount, 1);
      expect(base.isComplete, isFalse);

      final ethereum = s.filteredTo(1);
      expect(ethereum.isComplete, isTrue);
      expect(ethereum.total.value, Decimal.parse('2500'));
    });

    test('a null filter is the identity', () {
      final s = snapshot(balances: [balance(1, '1', usd: '2500')]);
      expect(s.filteredTo(null), same(s));
    });
  });

  test('a partial total never formats as a plain confident number', () {
    // The formatter takes the whole snapshot precisely so this cannot be
    // bypassed by reaching for `total` and formatting it directly.
    final s = snapshot(
      balances: [balance(1, '1', usd: '2500')],
      failures: const [
        ChainFailure(chainId: 8453, kind: ChainFailureKind.network),
      ],
    );

    expect(formatPortfolioTotal(s).text, isNot(r'$2,500.00'));
  });
}
