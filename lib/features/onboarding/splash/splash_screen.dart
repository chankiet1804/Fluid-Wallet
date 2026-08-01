import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// Held while the keystore is read, then the router redirects away.
///
/// It exists so someone who already has a wallet never sees onboarding flash
/// past on launch. The routing decision itself belongs to the redirect in
/// `routerProvider` — duplicating it here would give two places that can
/// disagree. What this screen does own is the failure case: a keystore read
/// that throws leaves the redirect with no answer, so without a retry the app
/// would sit on this screen forever.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const _markSize = 96.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final failed = ref.watch(walletControllerProvider).hasError;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Center(child: BrandMark(size: _markSize)),
              ),
              if (failed) ...[
                Text(
                  'Could not open your wallet storage.',
                  textAlign: TextAlign.center,
                  style: context.typo.bodyLarge.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimens.space24),
                PrimaryButton(
                  label: 'Try again',
                  // Re-runs the load. Nothing was written, so a retry is safe.
                  onPressed: () => ref.invalidate(walletControllerProvider),
                ),
                const SizedBox(height: AppDimens.space16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
