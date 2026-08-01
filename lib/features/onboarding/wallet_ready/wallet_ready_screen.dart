import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// Last step of onboarding, shown after a wallet is created or imported.
///
/// The wallet already exists in the keystore by the time this screen opens, so
/// there is no back step and no skip: the only way out is forward. Popping back
/// would land on a verify/import screen that no longer has anything to do.
class WalletReadyScreen extends ConsumerWidget {
  const WalletReadyScreen({super.key});

  static const _avatarSize = 96.0;
  static const _brandMarkSize = 56.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    // The only sanctioned source of the active address — never a constructor
    // argument, so switching accounts later rebuilds this on its own.
    final account = ref.watch(currentAccountProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.space40),
                const Center(child: BrandMark(size: _brandMarkSize)),
                const SizedBox(height: AppDimens.space24),
                Text(
                  'Your wallet is ready',
                  textAlign: TextAlign.center,
                  style: context.typo.titleLarge,
                ),
                const SizedBox(height: AppDimens.space8),
                Text(
                  'This is your Base address. Tap continue to open your '
                  'wallet.',
                  textAlign: TextAlign.center,
                  style: context.typo.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: account == null
                        ? CircularProgressIndicator(color: colors.accent)
                        : _AccountIdentity(address: account.address),
                  ),
                ),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: account == null
                      ? null
                      : () => context.go(AppRoute.portfolio),
                ),
                const SizedBox(height: AppDimens.space16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountIdentity extends StatelessWidget {
  const _AccountIdentity({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WalletAvatar(address: address, size: WalletReadyScreen._avatarSize),
        const SizedBox(height: AppDimens.space20),
        Text(
          AppFormat.shortAddress(address),
          style: context.typo.address.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
