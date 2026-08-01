import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/wallet_providers.dart';
import '../features/onboarding/backup_phrase/backup_phrase_screen.dart';
import '../features/onboarding/create_wallet/create_wallet_screen.dart';
import '../features/onboarding/get_started/get_started.dart';
import '../features/onboarding/import_wallet/import_wallet_screen.dart';
import '../features/onboarding/verify_phrase/verify_phrase_screen.dart';
import '../features/onboarding/wallet_ready/wallet_ready_screen.dart';
import '../features/wallet/portfolio/portfolio_screen.dart';
import 'theme/design_gallery.dart';

abstract final class AppRoute {
  static const getStarted = '/';
  static const createWallet = '/create';
  static const backupPhrase = '/backup';
  static const verifyPhrase = '/backup/verify';
  static const importWallet = '/import';
  static const walletReady = '/ready';
  static const portfolio = '/wallet';

  /// Dev-only, registered and reachable in debug builds only.
  static const designGallery = '/design-gallery';
}

/// Routes carry ids, never secrets. A mnemonic or passcode in a path or query
/// ends up in navigation state and restoration data — the screen that needs the
/// phrase reads it from the keystore instead.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.getStarted,
    redirect: (context, state) {
      final wallets = ref.read(walletControllerProvider).value;
      // Still loading metadata — hold on the current location rather than
      // flashing onboarding at someone who already has a wallet.
      if (wallets == null) return null;

      final onOnboarding = state.matchedLocation == AppRoute.getStarted;
      if (wallets.hasWallet && onOnboarding) return AppRoute.portfolio;
      // Both of these need an existing wallet to show anything at all.
      const needsWallet = {AppRoute.portfolio, AppRoute.walletReady};
      if (!wallets.hasWallet && needsWallet.contains(state.matchedLocation)) {
        return AppRoute.getStarted;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.getStarted,
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoute.createWallet,
        builder: (context, state) => const CreateWalletScreen(),
      ),
      GoRoute(
        path: AppRoute.backupPhrase,
        builder: (context, state) =>
            BackupPhraseScreen(walletId: state.uri.queryParameters['walletId']!),
      ),
      GoRoute(
        path: AppRoute.verifyPhrase,
        builder: (context, state) =>
            VerifyPhraseScreen(walletId: state.uri.queryParameters['walletId']!),
      ),
      GoRoute(
        path: AppRoute.importWallet,
        builder: (context, state) => const ImportWalletScreen(),
      ),
      GoRoute(
        path: AppRoute.walletReady,
        builder: (context, state) => const WalletReadyScreen(),
      ),
      GoRoute(
        path: AppRoute.portfolio,
        builder: (context, state) => const PortfolioScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoute.designGallery,
          builder: (context, state) => const DesignGallery(),
        ),
    ],
  );
});
