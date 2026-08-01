import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';
import '../../wallet/portfolio/wallet_switcher_sheet.dart';

/// The wallet header at the top of Settings — same entry point to the switcher
/// as the account pill on Portfolio.
///
/// Reads the wallet from the provider rather than a constructor argument, so
/// switching accounts rebuilds this card instead of leaving the previous
/// wallet on screen.
class SettingsWalletCard extends ConsumerWidget {
  const SettingsWalletCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(walletControllerProvider).value;
    final wallet = ref.watch(currentWalletProvider);
    final account = ref.watch(currentAccountProvider);
    // The router guard keeps Settings unreachable without a wallet; this is
    // only for the frame between deleting the last one and the redirect.
    if (state == null || wallet == null || account == null) {
      return const SizedBox.shrink();
    }

    final name = walletDisplayName(
      wallet,
      state.wallets.indexWhere((w) => w.id == wallet.id),
    );

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        onTap: () => showWalletSwitcherSheet(context),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: [
              WalletAvatar(address: account.address, size: 44),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.typo.titleMedium),
                    const SizedBox(height: AppDimens.space4),
                    _AddressLine(address: account.address),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              Icon(Icons.chevron_right, size: 22, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shortened address with a copy affordance. An address is public — unlike the
/// recovery phrase, copying it is exactly what it is for.
class _AddressLine extends StatelessWidget {
  const _AddressLine({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppFormat.shortAddress(address),
          style: context.typo.address.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: AppDimens.space4),
        InkWell(
          onTap: () => Clipboard.setData(ClipboardData(text: address)),
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space4),
            child: Icon(
              Icons.copy_outlined,
              size: 14,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
