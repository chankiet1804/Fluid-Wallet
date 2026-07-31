import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:fluid_wallet/features/onboarding/import_wallet/import_wallet_screen.dart';
import 'package:fluid_wallet/features/onboarding/backup_phrase/backup_phrase_screen.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';

import '../support/fake_secure_storage.dart';

void main() {
  const zero12 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon about';

  late FakeSecureStorage storage;

  setUp(() => storage = FakeSecureStorage());

  Widget host(Widget child) {
    return ProviderScope(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
      child: MaterialApp(theme: AppTheme.dark, home: child),
    );
  }

  bool primaryEnabled(WidgetTester tester) {
    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    return button.onPressed != null;
  }

  group('import screen', () {
    testWidgets('import stays disabled until the checksum passes',
        (tester) async {
      await tester.pumpWidget(host(const ImportWalletScreen()));

      expect(primaryEnabled(tester), isFalse);

      // Twelve real words, wrong checksum — the case a word-count check would
      // wave through.
      await tester.enterText(
        find.byType(TextField),
        'abandon abandon abandon abandon abandon abandon abandon abandon '
        'abandon abandon abandon abandon',
      );
      await tester.pump();

      expect(find.text('These words do not form a valid phrase'), findsOneWidget);
      expect(primaryEnabled(tester), isFalse);
    });

    testWidgets('a valid phrase enables import and reports it', (tester) async {
      await tester.pumpWidget(host(const ImportWalletScreen()));

      await tester.enterText(find.byType(TextField), zero12);
      await tester.pump();

      expect(find.text('Valid recovery phrase'), findsOneWidget);
      expect(primaryEnabled(tester), isTrue);
    });

    testWidgets('a partial phrase reads as progress, not as an error',
        (tester) async {
      await tester.pumpWidget(host(const ImportWalletScreen()));

      await tester.enterText(find.byType(TextField), 'abandon abandon');
      await tester.pump();

      expect(find.text('2 words so far'), findsOneWidget);
      expect(primaryEnabled(tester), isFalse);
    });

    testWidgets('rejects a phrase already imported', (tester) async {
      await tester.pumpWidget(host(const ImportWalletScreen()));
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ImportWalletScreen)),
      );
      await container.read(walletRepositoryProvider).importWallet(zero12);

      await tester.enterText(find.byType(TextField), zero12);
      await tester.pump();
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      await tester.pump();

      expect(find.text('This wallet is already in the app.'), findsOneWidget);
    });
  });

  group('backup screen', () {
    testWidgets('shows the phrase as soon as it loads', (tester) async {
      await tester.pumpWidget(host(const SizedBox()));
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SizedBox)),
      );
      final state =
          await container.read(walletRepositoryProvider).importWallet(zero12);
      final walletId = state.wallets.single.id;

      await tester.pumpWidget(
        host(BackupPhraseScreen(walletId: walletId)),
      );
      await tester.pumpAndSettle();

      // All twelve words are visible with no reveal step in between.
      expect(find.text('abandon'), findsNWidgets(11));
      expect(find.text('about'), findsOneWidget);
      expect(primaryEnabled(tester), isTrue);
    });

    testWidgets('offers no way to copy the whole phrase', (tester) async {
      await tester.pumpWidget(host(const SizedBox()));
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SizedBox)),
      );
      final state =
          await container.read(walletRepositoryProvider).importWallet(zero12);

      await tester.pumpWidget(
        host(BackupPhraseScreen(walletId: state.wallets.single.id)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.copy), findsNothing);
      expect(find.textContaining('Copy'), findsNothing);
    });
  });
}
