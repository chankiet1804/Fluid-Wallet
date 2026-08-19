import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme.dart';
import '../../../data/models/wallet_meta.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';
import 'add_wallet_sheet.dart';

/// Label for a wallet in the UI.
///
/// The fallback covers wallets stored before default naming existed — their
/// `name` is null and position is the only thing left to identify them by.
String walletDisplayName(WalletMeta wallet, int index) =>
    wallet.name ?? 'Wallet ${index + 1}';

/// Opens the wallet switcher. Drag-to-dismiss and tap-outside are the sheet
/// defaults, so both are left alone.
Future<void> showWalletSwitcherSheet(BuildContext context) {
  return showAppSheet<void>(context, (_) => const WalletSwitcherSheet());
}

/// Current wallet on top, the others below it, and the destructive action for
/// the current one in between.
///
/// Everything here reads from [walletControllerProvider] rather than taking a
/// wallet through the constructor — switching has to rebuild this sheet, not
/// leave it showing the wallet it was opened with.
class WalletSwitcherSheet extends ConsumerWidget {
  const WalletSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(walletControllerProvider).value;
    final current = state?.currentWallet;
    if (state == null || current == null) return const SizedBox.shrink();

    final indexed = state.wallets.indexed.toList();
    final others = indexed.where((entry) => entry.$2.id != current.id).toList();
    final currentIndex = state.wallets.indexWhere((w) => w.id == current.id);

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CurrentWalletHeader(
            wallet: current,
            name: walletDisplayName(current, currentIndex),
          ),
          const SizedBox(height: AppDimens.space24),
          Text(
            'Fluid Wallets',
            style: context.typo.caption.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: AppDimens.space8),
          for (final (index, wallet) in others)
            _WalletRow(wallet: wallet, name: walletDisplayName(wallet, index)),
          const _AddWalletRow(),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}

class _CurrentWalletHeader extends ConsumerWidget {
  const _CurrentWalletHeader({required this.wallet, required this.name});

  final WalletMeta wallet;
  final String name;

  /// Confirms, closes the sheet, then deletes.
  ///
  /// The order matters: deleting the last wallet flips the router guard and
  /// sends the app back to Get started, and a sheet left on the stack would
  /// sit on top of that screen. The notifier is captured up front because this
  /// widget is gone by the time the delete runs.
  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showAppConfirmSheet(
      context,
      tone: AppSheetTone.danger,
      icon: Icons.delete_outline,
      title: 'Delete $name?',
      message: wallet.isBackedUp
          ? 'This removes the wallet and its recovery phrase from this phone. '
                'You can import it again with the phrase you wrote down — '
                'without it, the funds are gone for good.'
          : 'This wallet has no confirmed backup. Deleting it removes the only '
                'copy of its recovery phrase, and any funds it holds become '
                'unreachable forever.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
    );
    if (!confirmed || !context.mounted) return;

    final controller = ref.read(walletControllerProvider.notifier);
    Navigator.of(context).pop();
    await controller.deleteWallet(wallet.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = wallet.accounts.first.address;

    return Column(
      children: [
        WalletAvatar(address: address, size: 72),
        const SizedBox(height: AppDimens.space12),
        Text(name, style: context.typo.titleLarge),
        const SizedBox(height: AppDimens.space4),
        _AddressLine(address: address),
        const SizedBox(height: AppDimens.space20),
        Row(
          children: [
            // Renaming lands with the wallet settings screen; the affordance is
            // here so the layout does not shift when it arrives.
            const Expanded(
              child: SecondaryButton(label: 'Edit name', onPressed: null),
            ),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: DangerButton(
                label: 'Delete',
                onPressed: () => _delete(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalletRow extends ConsumerWidget {
  const _WalletRow({required this.wallet, required this.name});

  final WalletMeta wallet;
  final String name;

  Future<void> _switchTo(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(walletControllerProvider.notifier);
    Navigator.of(context).pop();
    await controller.switchAccount(
      walletId: wallet.id,
      accountId: wallet.accounts.first.id,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = wallet.accounts.first.address;

    return InkWell(
      onTap: () => _switchTo(context, ref),
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
        child: Row(
          children: [
            WalletAvatar(address: address, size: 40),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.typo.titleMedium),
                  const SizedBox(height: AppDimens.space4),
                  _AddressLine(address: address),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.space8),
            // Per-wallet totals are not fetched yet: showing every other wallet
            // would mean a balance request per wallet on every open. An em dash
            // says "not known"; "$0.00" would say "empty", and a user reading
            // that about a funded wallet has every reason to panic.
            Text(
              '—',
              style: context.typo.amountMedium.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddWalletRow extends StatelessWidget {
  const _AddWalletRow();

  /// Closes the switcher before opening the chooser, so the create flow does
  /// not end up with a stale sheet underneath it. The Navigator's own context
  /// survives the pop; this widget's does not.
  Future<void> _open(BuildContext context) async {
    final navigator = Navigator.of(context);
    final host = navigator.context;
    navigator.pop();
    await showAddWalletSheet(host);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, size: 20, color: colors.textPrimary),
            ),
            const SizedBox(width: AppDimens.space12),
            Text('Add Wallet', style: context.typo.titleMedium),
          ],
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
