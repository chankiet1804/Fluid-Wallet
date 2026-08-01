import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'backup_warning_sheet.dart';

/// Entry point of the backup flow, opened from the Backup row in Settings.
///
/// This is the counterpart of "Back up later" during onboarding: a wallet whose
/// phrase was never written down keeps `isBackedUp == false`, and this is where
/// the user finally does it.
Future<void> showBackupSheet(BuildContext context, String walletId) {
  return showAppSheet<void>(context, (_) => BackupSheet(walletId: walletId));
}

class BackupSheet extends StatelessWidget {
  const BackupSheet({super.key, required this.walletId});

  final String walletId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Backup',
            textAlign: TextAlign.center,
            style: context.typo.titleLarge,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            'Backup of your wallet by recording your recovery phrase',
            textAlign: TextAlign.center,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          _ShowPhraseRow(
            // Stacks on top rather than replacing this sheet: the warning is a
            // step forward in the same flow, and closing it must land back
            // here.
            onTap: () => showBackupWarningSheet(context, walletId),
          ),
          const SizedBox(height: AppDimens.space32),
        ],
      ),
    );
  }
}

class _ShowPhraseRow extends StatelessWidget {
  const _ShowPhraseRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppDimens.radiusMd);

    return Material(
      color: colors.surfaceElevated,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.vpn_key_outlined,
                  size: 20,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Show recovery phrase',
                      style: context.typo.titleMedium,
                    ),
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      '12 words',
                      style: context.typo.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
