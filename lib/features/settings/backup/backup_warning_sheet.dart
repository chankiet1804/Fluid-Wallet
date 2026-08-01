import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'recovery_phrase_sheet.dart';

/// The one screen between the user and twelve words that spend their funds.
///
/// It exists to slow the flow down, not to gate it: the real gate is Face ID,
/// and it is not built yet.
Future<void> showBackupWarningSheet(BuildContext context, String walletId) {
  return showAppSheet<void>(
    context,
    (_) => BackupWarningSheet(walletId: walletId),
  );
}

class BackupWarningSheet extends StatelessWidget {
  const BackupWarningSheet({super.key, required this.walletId});

  final String walletId;

  static const _rules = [
    'Never write your recovery phrase outside of Fluid wallet',
    'Fluid support will never ask for your recovery phrase',
    'Anyone with your recovery phrase has access to your wallet',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.warningSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.priority_high, size: 28, color: colors.warning),
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          Text(
            'Attention',
            textAlign: TextAlign.center,
            style: context.typo.titleLarge,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            'Please take the time to read the recommendations before viewing '
            'the recovery phrase',
            textAlign: TextAlign.center,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          Container(
            padding: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, rule) in _rules.indexed) ...[
                  if (index > 0) const SizedBox(height: AppDimens.space16),
                  _Bullet(text: rule),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          PrimaryButton(
            label: 'Continue',
            // TODO(phase6): gate this behind local_auth. Until the biometric
            // gate lands, tapping Continue is all it takes to reveal the
            // phrase — another reason this build must not hold real funds.
            onPressed: () => showRecoveryPhraseSheet(context, walletId),
          ),
          const SizedBox(height: AppDimens.space32),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppDimens.space8),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: colors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.space12),
        Expanded(
          child: Text(
            text,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
