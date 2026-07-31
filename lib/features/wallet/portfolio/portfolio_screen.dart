import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';

/// Placeholder home. Phase 2 replaces this with balances and the portfolio
/// total; for now it shows the derived address so it can be checked against
/// MetaMask by importing the same phrase there.
///
/// Note how the address is read: `currentAccountProvider`, never a constructor
/// argument. That is what makes switching accounts a one-line state change
/// later instead of a rewrite.
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final account = ref.watch(currentAccountProvider);
    final wallet = ref.watch(currentWalletProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Wallet', style: context.typo.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: account == null
              ? Center(
                  child: Text(
                    'No wallet yet.',
                    style: context.typo.bodyLarge.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.space32),
                    Text(
                      'Account ${account.index + 1}',
                      style: context.typo.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space8),
                    _AddressCard(address: account.address),
                    if (wallet != null && !wallet.isBackedUp) ...[
                      const SizedBox(height: AppDimens.space16),
                      _BackupWarning(),
                    ],
                    const Spacer(),
                    Text(
                      'Balances arrive in Phase 2.',
                      textAlign: TextAlign.center,
                      style: context.typo.bodyMedium.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space32),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            // Full address, not shortened: this screen exists to be compared
            // against another wallet character by character.
            child: SelectableText(address, style: context.typo.address),
          ),
          IconButton(
            icon: Icon(Icons.copy, size: 20, color: colors.textSecondary),
            // An address is public — unlike the recovery phrase, copying it is
            // exactly what it is for.
            onPressed: () => Clipboard.setData(ClipboardData(text: address)),
          ),
        ],
      ),
    );
  }
}

class _BackupWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: colors.warningSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, size: 20, color: colors.warning),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              'This wallet has no confirmed backup.',
              style: context.typo.bodyMedium.copyWith(color: colors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
