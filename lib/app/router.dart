import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/wallet_providers.dart';
import '../features/onboarding/backup_phrase/backup_phrase_screen.dart';
import '../features/onboarding/create_wallet/create_wallet_screen.dart';
import '../features/onboarding/get_started/get_started.dart';
import '../features/onboarding/import_wallet/import_wallet_screen.dart';
import '../features/onboarding/splash/splash_screen.dart';
import '../features/onboarding/verify_phrase/verify_phrase_screen.dart';
import '../features/borrow/borrow_screen.dart';
import '../features/lending/lending_screen.dart';
import '../features/onboarding/wallet_ready/wallet_ready_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/wallet/main_shell.dart';
import '../features/wallet/portfolio/portfolio_screen.dart';
import 'theme/design_gallery.dart';

abstract final class AppRoute {
  /// Landing location on launch. Reading the keystore is asynchronous, so
  /// something has to hold the screen until the answer is known — otherwise
  /// onboarding flashes past someone who already has a wallet.
  static const splash = '/splash';

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
  // go_router only re-evaluates `redirect` on a navigation event. Without this
  // bridge the guard runs once at launch — while the keystore read is still in
  // flight — decides "no answer yet", and never runs again, stranding a user
  // who has a wallet on Get Started forever.
  final refresh = _RouterRefresh();
  ref.listen(walletControllerProvider, (_, _) => refresh.ping());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoute.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      // `read`, not `watch`: the listener above is what re-triggers this.
      final wallets = ref.read(walletControllerProvider).value;
      // Still loading metadata — hold on splash until there is an answer.
      if (wallets == null) return null;

      final location = state.matchedLocation;
      final atEntry =
          location == AppRoute.splash || location == AppRoute.getStarted;

      if (wallets.hasWallet) {
        // Only the entry screens are redirected. Mid-onboarding locations
        // (/create, /backup, /backup/verify) also have a wallet by then and
        // must not be yanked out from under the user.
        return atEntry ? AppRoute.portfolio : null;
      }
      if (location == AppRoute.splash ||
          AppRoute.needsWallet.contains(location)) {
        return AppRoute.getStarted;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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

/// Exists only to expose `notifyListeners`, which is protected on the base
/// class. Carries no state: go_router re-reads the wallet state itself.
class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}
