import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../onboarding/import_wallet/import_phrase_form.dart';

/// Asks whether the new wallet is generated or imported, then hands off to the
/// same two flows onboarding uses.
Future<void> showAddWalletSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AddWalletSheet(),
  );
}

/// Hosts the onboarding import form in a sheet.
Future<void> showImportWalletSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ImportWalletSheet(),
  );
}

class AddWalletSheet extends StatelessWidget {
  const AddWalletSheet({super.key});

  /// Closes this sheet before opening what comes next: the create flow takes
  /// over the whole screen, and a sheet left on the stack would sit on top of
  /// it. [Navigator]'s own context outlives this widget, so it is what carries
  /// the follow-up.
  Future<void> _handOff(
    BuildContext context,
    Future<void> Function(BuildContext host) next,
  ) async {
    final navigator = Navigator.of(context);
    final host = navigator.context;
    navigator.pop();
    await next(host);
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: 'Add wallet',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _OptionRow(
            icon: Icons.add,
            title: 'Create a new wallet',
            subtitle: 'Generates a new recovery phrase',
            onTap: () => _handOff(
              context,
              (host) async =>
                  host.push(AppRoute.createWalletPath(fromApp: true)),
            ),
          ),
          _OptionRow(
            icon: Icons.download_outlined,
            title: 'Import an existing wallet',
            subtitle: 'Use a phrase you already have',
            onTap: () => _handOff(context, showImportWalletSheet),
          ),
          const SizedBox(height: AppDimens.space8),
        ],
      ),
    );
  }
}

class ImportWalletSheet extends StatelessWidget {
  const ImportWalletSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: 'Import wallet',
      // Lifts the form clear of the keyboard, which would otherwise cover the
      // import button on every phone.
      bottomInset: MediaQuery.viewInsetsOf(context).bottom,
      child: ImportPhraseForm(
        onImported: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Shared frame for both sheets — same surface, corner radius and close
/// affordance as the wallet switcher.
class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.title,
    required this.child,
    this.bottomInset = 0,
  });

  final String title;
  final Widget child;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusSheet),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                AppDimens.space16,
                AppDimens.space12,
                0,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: context.typo.titleMedium)),
                  Material(
                    color: colors.surfaceElevated,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.space4),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  AppDimens.space16,
                  AppDimens.screenPadding,
                  bottomInset,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
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
              child: Icon(icon, size: 20, color: colors.textPrimary),
            ),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.typo.titleMedium),
                  const SizedBox(height: AppDimens.space4),
                  Text(
                    subtitle,
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
    );
  }
}
