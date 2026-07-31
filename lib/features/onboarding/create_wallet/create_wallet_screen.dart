import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// Generates the mnemonic and derives account 0.
///
/// Back is blocked while this runs: leaving halfway would strand a secret in
/// the keystore with no metadata pointing at it.
class CreateWalletScreen extends ConsumerStatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  ConsumerState<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends ConsumerState<CreateWalletScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _create());
  }

  Future<void> _create() async {
    setState(() => _error = null);
    try {
      await ref.read(walletControllerProvider.notifier).createWallet();
      if (!mounted) return;

      final walletId = ref.read(currentWalletProvider)?.id;
      if (walletId == null) {
        setState(() => _error = 'Wallet was created but could not be read back.');
        return;
      }
      // Straight into backup — a wallet nobody has written down is a wallet
      // one lost phone away from being gone.
      context.go('${AppRoute.backupPhrase}?walletId=$walletId');
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not create the wallet. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final failed = _error != null;

    return PopScope(
      canPop: failed,
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
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (failed) ...[
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: colors.danger,
                          ),
                          const SizedBox(height: AppDimens.space24),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: context.typo.bodyLarge.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ] else ...[
                          CircularProgressIndicator(color: colors.accent),
                          const SizedBox(height: AppDimens.space32),
                          Text(
                            'Creating your wallet',
                            textAlign: TextAlign.center,
                            style: context.typo.titleLarge,
                          ),
                          const SizedBox(height: AppDimens.space8),
                          Text(
                            'This only takes a moment.',
                            textAlign: TextAlign.center,
                            style: context.typo.bodyMedium.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (failed) ...[
                  PrimaryButton(label: 'Try again', onPressed: _create),
                  const SizedBox(height: AppDimens.space12),
                  SecondaryButton(
                    label: 'Back',
                    onPressed: () => context.go(AppRoute.getStarted),
                  ),
                  const SizedBox(height: AppDimens.space16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
