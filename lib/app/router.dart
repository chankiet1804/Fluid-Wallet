import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/wallet_providers.dart';
import '../features/onboarding/backup_phrase/backup_phrase_screen.dart';
import '../features/onboarding/create_wallet/create_wallet_screen.dart';
import '../features/onboarding/get_started/get_started.dart';
import '../features/onboarding/import_wallet/import_wallet_screen.dart';
import '../features/onboarding/verify_phrase/verify_phrase_screen.dart';
import '../features/borrow/borrow_screen.dart';
import '../features/lending/lending_screen.dart';
import '../features/onboarding/wallet_ready/wallet_ready_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/wallet/main_shell.dart';
import '../features/wallet/portfolio/portfolio_screen.dart';
import 'theme/design_gallery.dart';

abstract final class AppRoute {
  static const getStarted = '/';
  static const createWallet = '/create';
  static const backupPhrase = '/backup';
  static const verifyPhrase = '/backup/verify';
  static const importWallet = '/import';
  static const walletReady = '/ready';

  /// Tabs of the signed-in shell. All four need a wallet — see [needsWallet].
  static const portfolio = '/wallet';
  static const borrow = '/borrow';
  static const lending = '/lending';
  static const statistics = '/statistics';

  /// Locations that render nothing without a wallet, so entering one without
  /// a wallet must bounce to onboarding rather than show empty chrome.
  static const needsWallet = {
    portfolio,
    borrow,
    lending,
    statistics,
    walletReady,
  };

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
      if (!wallets.hasWallet &&
          AppRoute.needsWallet.contains(state.matchedLocation)) {
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
      // One shell, four branches: each tab keeps its own navigation stack, so
      // drilling into a token and switching tabs does not reset the other.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.portfolio,
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.borrow,
                builder: (context, state) => const BorrowScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.lending,
                builder: (context, state) => const LendingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.statistics,
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
        ],
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoute.designGallery,
          builder: (context, state) => const DesignGallery(),
        ),
    ],
  );
});
