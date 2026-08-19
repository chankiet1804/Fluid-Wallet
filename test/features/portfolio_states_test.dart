import 'package:decimal/decimal.dart';
import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:fluid_wallet/core/security/secure_store.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/wallet_repository.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:fluid_wallet/features/wallet/portfolio/portfolio_screen.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_secure_storage.dart';
import '../support/test_chain_registry.dart';

/// The most valuable widget test in this layer: it asserts the UI cannot render
/// a confident total over incomplete data.
void main() {
  late FakeSecureStorage storage;
  late ChainRegistry registry;

  setUpAll(() => registry = loadTestChainRegistry());

  setUp(() async {
    storage = FakeSecureStorage();
    await WalletRepository(
      secureStore: SecureStore(storage),
      storage: storage,
    ).createWallet();
  });

  Future<void> pump(
    WidgetTester tester,
    AsyncValue<PortfolioSnapshot> portfolio,
  ) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        ...chainTestOverrides(portfolio: portfolio, registry: registry),
      ],
    );
    addTearDown(container.dispose);

    // The wallet controller reads the keystore asynchronously; the screen needs
    // an account before it renders anything but its empty state.
    await container.read(walletControllerProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(body: PortfolioScreen()),
        ),
      ),
    );
    await tester.pump();
  }

  TokenBalance ethOn(int chainId, String amount, {String? usd}) {
    final token = registry.tokensOf(chainId).firstWhere((t) => t.isNative);
    return TokenBalance(
      token: token,
      amount: TokenAmount.parse(amount, decimals: token.decimals),
      fiat: usd == null
          ? null
          : FiatValue(currency: 'USD', value: Decimal.parse(usd)),
    );
  }

  PortfolioSnapshot snapshotOf({
    List<TokenBalance> balances = const [],
    List<ChainFailure> failures = const [],
    int unpriced = 0,
  }) => PortfolioSnapshot(
    address: '0xabc',
    balances: balances,
    currency: 'USD',
    fetchedAt: DateTime(2026),
    failures: failures,
    unpricedCount: unpriced,
  );

  testWidgets('loading shows a placeholder, not a number', (tester) async {
    await pump(tester, const AsyncValue.loading());

    expect(find.text('—'), findsWidgets);
    expect(find.textContaining(r'$'), findsNothing);
  });

  testWidgets('a failed fetch shows a dash, never \$0.00', (tester) async {
    // The whole point: a funded wallet whose fetch failed must not read as
    // empty. "$0.00" says "you have nothing"; "—" says "we do not know".
    await pump(tester, AsyncValue.error('boom', StackTrace.empty));

    expect(find.text('—'), findsWidgets);
    expect(find.textContaining(r'$0.00'), findsNothing);
    expect(find.text("Couldn't load balances."), findsOneWidget);
  });

  testWidgets('a complete snapshot renders the total plainly', (tester) async {
    await pump(
      tester,
      AsyncValue.data(snapshotOf(balances: [ethOn(8453, '1', usd: '2500')])),
    );

    expect(find.text(r'$2,500.00'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsNothing);
  });

  testWidgets('a partial snapshot is marked, not presented as final', (
    tester,
  ) async {
    await pump(
      tester,
      AsyncValue.data(
        snapshotOf(
          balances: [ethOn(8453, '1', usd: '2500')],
          failures: const [
            ChainFailure(chainId: 1, kind: ChainFailureKind.network),
          ],
        ),
      ),
    );

    expect(find.text(r'$2,500.00'), findsNothing);
    expect(find.text(r'≥ $2,500.00'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.textContaining('lower bound'), findsOneWidget);
  });

  testWidgets('an unpriced token is flagged in the total', (tester) async {
    await pump(
      tester,
      AsyncValue.data(
        snapshotOf(
          balances: [
            ethOn(8453, '1', usd: '2500'),
            ethOn(1, '2'),
          ],
          unpriced: 1,
        ),
      ),
    );

    expect(find.text(r'≥ $2,500.00'), findsOneWidget);
    expect(find.textContaining('no price'), findsOneWidget);
  });

  testWidgets('an empty successful snapshot still lists every chain', (
    tester,
  ) async {
    await pump(tester, AsyncValue.data(snapshotOf()));

    // A funded-nothing wallet is a real zero, so each chain shows its gas token
    // at 0 rather than an empty list.
    for (final chain in registry.chains) {
      expect(
        find.textContaining(chain.name),
        findsWidgets,
        reason: '${chain.name} has no row',
      );
    }
    expect(find.text('No tokens yet.'), findsNothing);
    expect(find.text("Couldn't load balances."), findsNothing);
  });

  testWidgets('a chain that failed contributes no row at all', (tester) async {
    await pump(
      tester,
      AsyncValue.data(
        snapshotOf(
          failures: const [
            ChainFailure(chainId: 8453, kind: ChainFailureKind.network),
          ],
        ),
      ),
    );

    // Showing Base at $0.00 would be the app reporting a balance it never read.
    // The banner names the failed chain, so only rows count here.
    final base = registry.chain(8453)!;
    expect(
      find.descendant(
        of: find.byType(TokenRow),
        matching: find.textContaining(base.name),
      ),
      findsNothing,
    );
    // The chains that did answer are still listed.
    expect(
      find.descendant(
        of: find.byType(TokenRow),
        matching: find.textContaining(registry.chain(1)!.name),
      ),
      findsWidgets,
    );
  });

  testWidgets('every chain failing does not claim emptiness', (tester) async {
    await pump(
      tester,
      AsyncValue.data(
        snapshotOf(
          failures: [
            for (final c in registry.chains)
              ChainFailure(chainId: c.chainId, kind: ChainFailureKind.network),
          ],
        ),
      ),
    );

    // "No tokens yet" would be the app asserting something it did not check.
    expect(find.text('No tokens yet.'), findsNothing);
    expect(find.text("Couldn't load balances."), findsOneWidget);
  });

  testWidgets('the network filter pill is reachable', (tester) async {
    await pump(tester, AsyncValue.data(snapshotOf()));

    expect(find.text('All networks'), findsOneWidget);
  });
}
