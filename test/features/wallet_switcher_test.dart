import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/app/router.dart';
import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/core/security/secure_store.dart';
import 'package:fluid_wallet/data/models/wallet_meta.dart';
import 'package:fluid_wallet/data/repositories/wallet_repository.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:fluid_wallet/features/onboarding/get_started/get_started_screen.dart';
import 'package:fluid_wallet/features/wallet/portfolio/wallet_switcher_sheet.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';

import '../support/fake_secure_storage.dart';
import '../support/test_chain_registry.dart';

void main() {
  const zero12 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon about';

  late FakeSecureStorage storage;

  setUp(() => storage = FakeSecureStorage());

  /// Seeds the keystore before the app starts, the way a returning user's
  /// device already looks.
  Future<WalletState> seed({required int wallets}) async {
    final repo = WalletRepository(
      secureStore: SecureStore(storage),
      storage: storage,
    );
    var state = await repo.createWallet();
    if (wallets > 1) state = await repo.importWallet(zero12);
    return state;
  }

  /// Boots the real router so guard-driven navigation (deleting the last
  /// wallet) is exercised rather than mocked.
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        // The portfolio now reads live balances. Stubbing them keeps this test
        // about wallet switching, and keeps the balance cache timer from
        // outliving the test.
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

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
  }

  /// Scoped to the sheet: the Portfolio behind it shows the current wallet's
  /// name too, so an unscoped `find.text` would count both.
  Finder inSheet(String text) => find.descendant(
        of: find.byType(WalletSwitcherSheet),
        matching: find.text(text),
      );

  testWidgets('the sheet lists the other wallets, not the current one',
      (tester) async {
    await seed(wallets: 2);
    await pumpApp(tester);

    await openSheet(tester);

    expect(find.byType(WalletSwitcherSheet), findsOneWidget);
    // Wallet 2 is current (imported last): it appears once, in the header, and
    // Wallet 1 is the only row offered to switch to.
    expect(inSheet('Wallet 2'), findsOneWidget);
    expect(inSheet('Wallet 1'), findsOneWidget);
    expect(inSheet('Add Wallet'), findsOneWidget);
  });

  testWidgets('tapping another wallet switches the current account',
      (tester) async {
    await seed(wallets: 2);
    final container = await pumpApp(tester);
    final before = container.read(currentAccountProvider)!.address;

    await openSheet(tester);
    await tester.tap(inSheet('Wallet 1'));
    await tester.pumpAndSettle();

    expect(find.byType(WalletSwitcherSheet), findsNothing);
    expect(container.read(currentAccountProvider)!.address, isNot(before));
  });

  testWidgets('deleting with another wallet left falls back to it',
      (tester) async {
    await seed(wallets: 2);
    final container = await pumpApp(tester);
    final deletedId = container.read(currentWalletProvider)!.id;

    await openSheet(tester);
    await tester.tap(find.widgetWithText(DangerButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    final state = container.read(walletControllerProvider).value!;
    expect(state.wallets, hasLength(1));
    expect(state.currentWallet!.id, isNot(deletedId));

    final orphanedSecret = await container
        .read(walletRepositoryProvider)
        .readMnemonic(deletedId);
    expect(orphanedSecret, isNull);
  });

  testWidgets('deleting the last wallet lands back on Get started',
      (tester) async {
    await seed(wallets: 1);
    final container = await pumpApp(tester);

    await openSheet(tester);
    await tester.tap(find.widgetWithText(DangerButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(container.read(walletControllerProvider).value!.wallets, isEmpty);
    expect(find.byType(GetStartedScreen), findsOneWidget);
    expect(find.byType(WalletSwitcherSheet), findsNothing);
  });

  testWidgets('cancelling the dialog deletes nothing', (tester) async {
    await seed(wallets: 2);
    final container = await pumpApp(tester);

    await openSheet(tester);
    await tester.tap(find.widgetWithText(DangerButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(container.read(walletControllerProvider).value!.wallets,
        hasLength(2));
    expect(find.byType(WalletSwitcherSheet), findsOneWidget);
  });
}
