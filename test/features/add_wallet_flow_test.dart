import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/app/router.dart';
import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:fluid_wallet/features/onboarding/backup_phrase/backup_phrase_screen.dart';
import 'package:fluid_wallet/features/wallet/portfolio/add_wallet_sheet.dart';
import 'package:fluid_wallet/features/wallet/portfolio/portfolio_screen.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';

import '../support/fake_secure_storage.dart';
import '../support/sync_key_derivation.dart';
import '../support/test_chain_registry.dart';

void main() {
  const zero12 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon about';
  const zero12Address = '0x9858EfFD232B4033E47d90003D41EC34EcaEda94';

  late FakeSecureStorage storage;

  setUp(() => storage = FakeSecureStorage());

  Future<void> seedOneWallet({bool imported = false}) async {
    final repo = syncWalletRepository(storage);
    imported ? await repo.importWallet(zero12) : await repo.createWallet();
  }

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        syncDerivationOverride(storage),
        // This flow lands on the portfolio, which now fetches balances. Stub
        // them so the test stays about adding a wallet.
        ...chainTestOverrides(),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// Pumps in slices instead of settling: the create screen shows a spinner,
  /// and `pumpAndSettle` never returns while one is running.
  Future<void> pumpUntil(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 40 && finder.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(finder, findsOneWidget);
  }

  Future<void> openAddWallet(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Wallet'));
    await tester.pumpAndSettle();
  }

  testWidgets('Add Wallet offers create and import', (tester) async {
    await seedOneWallet();
    await pumpApp(tester);

    await openAddWallet(tester);

    expect(find.byType(AddWalletSheet), findsOneWidget);
    expect(find.text('Create a new wallet'), findsOneWidget);
    expect(find.text('Import an existing wallet'), findsOneWidget);
  });

  testWidgets('importing from the sheet adds the wallet and selects it', (
    tester,
  ) async {
    await seedOneWallet();
    final container = await pumpApp(tester);

    await openAddWallet(tester);
    await tester.tap(find.text('Import an existing wallet'));
    await tester.pumpAndSettle();

    expect(find.byType(ImportWalletSheet), findsOneWidget);
    await tester.enterText(find.byType(TextField), zero12);
    await tester.pump();
    await tester.tap(find.widgetWithText(PrimaryButton, 'Import wallet'));
    await tester.pumpAndSettle();

    expect(find.byType(ImportWalletSheet), findsNothing);
    final state = container.read(walletControllerProvider).value!;
    expect(state.wallets, hasLength(2));
    expect(state.currentAccount!.address, zero12Address);
  });

  testWidgets('a duplicate phrase fails inside the sheet without closing it', (
    tester,
  ) async {
    await seedOneWallet(imported: true);
    final container = await pumpApp(tester);

    await openAddWallet(tester);
    await tester.tap(find.text('Import an existing wallet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), zero12);
    await tester.pump();
    await tester.tap(find.widgetWithText(PrimaryButton, 'Import wallet'));
    await tester.pumpAndSettle();

    expect(find.text('This wallet is already in the app.'), findsOneWidget);
    expect(find.byType(ImportWalletSheet), findsOneWidget);
    expect(
      container.read(walletControllerProvider).value!.wallets,
      hasLength(1),
    );
  });

  testWidgets(
    'creating from the sheet backs out to Portfolio, not onboarding',
    (tester) async {
      await seedOneWallet();
      final container = await pumpApp(tester);

      await openAddWallet(tester);
      await tester.tap(find.text('Create a new wallet'));
      await pumpUntil(tester, find.byType(BackupPhraseScreen));
      await tester.pumpAndSettle();

      // Skipping the backup is the fast path out; the wallet already exists.
      await tester.tap(find.widgetWithText(SecondaryButton, 'Back up later'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Skip for now'));
      await tester.pumpAndSettle();

      expect(find.byType(PortfolioScreen), findsOneWidget);
      final state = container.read(walletControllerProvider).value!;
      expect(state.wallets, hasLength(2));
      expect(state.currentWallet!.isBackedUp, isFalse);
      expect(state.currentWallet!.name, 'Wallet 2');
    },
  );
}
