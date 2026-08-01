import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';
import 'app_button.dart';
import 'app_sheet.dart';

/// Role of the message. Drives the icon colours only — which button style the
/// action gets is decided separately, so a warning can still carry a normal
/// primary action.
enum AppSheetTone { neutral, success, warning, danger }

/// One button in an action sheet.
///
/// By default the sheet pops with [result]; [onPressed] replaces that entirely,
/// for the rare case where the button has to do something before closing.
class AppSheetAction<T> {
  const AppSheetAction({required this.label, this.result, this.onPressed});

  final String label;
  final T? result;
  final VoidCallback? onPressed;
}

/// The app's single confirmation / notification surface: icon, title, message,
/// then one or two full-width buttons.
///
/// Full-width stacked buttons rather than a row of text actions on purpose —
/// this sheet also asks "delete this wallet?", and a small destructive label
/// sitting next to Cancel is a mis-tap that costs funds.
Future<T?> showAppActionSheet<T>(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required AppSheetAction<T> primary,
  AppSheetTone tone = AppSheetTone.neutral,
  AppSheetAction<T>? secondary,
  bool dismissible = true,
}) {
  return showAppSheet<T>(
    context,
    (_) => _ActionSheetBody<T>(
      icon: icon,
      title: title,
      message: message,
      tone: tone,
      primary: primary,
      secondary: secondary,
      showClose: dismissible,
    ),
    dismissible: dismissible,
  );
}

/// Two-button confirmation. Returns true only when the user picks [confirmLabel]
/// — dismissing the sheet counts as declining.
Future<bool> showAppConfirmSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  AppSheetTone tone = AppSheetTone.neutral,
}) async {
  final result = await showAppActionSheet<bool>(
    context,
    icon: icon,
    title: title,
    message: message,
    tone: tone,
    primary: AppSheetAction(label: confirmLabel, result: true),
    secondary: AppSheetAction(label: cancelLabel, result: false),
  );
  return result ?? false;
}

class _ActionSheetBody<T> extends StatelessWidget {
  const _ActionSheetBody({
    required this.icon,
    required this.title,
    required this.message,
    required this.tone,
    required this.primary,
    required this.secondary,
    required this.showClose,
  });

  final IconData icon;
  final String title;
  final String message;
  final AppSheetTone tone;
  final AppSheetAction<T> primary;
  final AppSheetAction<T>? secondary;
  final bool showClose;

  VoidCallback _handler(BuildContext context, AppSheetAction<T> action) {
    final onPressed = action.onPressed;
    if (onPressed != null) return onPressed;
    return () => Navigator.of(context).pop(action.result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final secondary = this.secondary;

    return AppSheet(
      showClose: showClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: _ToneIcon(icon: icon, tone: tone)),
          const SizedBox(height: AppDimens.space20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.typo.titleLarge,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          if (tone == AppSheetTone.danger)
            DangerButton(
              label: primary.label,
              onPressed: _handler(context, primary),
            )
          else
            PrimaryButton(
              label: primary.label,
              onPressed: _handler(context, primary),
            ),
          if (secondary != null) ...[
            const SizedBox(height: AppDimens.space12),
            SecondaryButton(
              label: secondary.label,
              onPressed: _handler(context, secondary),
            ),
          ],
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}

/// Circular badge; tinted surface behind a role-coloured glyph.
class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.tone});

  final IconData icon;
  final AppSheetTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      AppSheetTone.success => (colors.successSurface, colors.success),
      AppSheetTone.warning => (colors.warningSurface, colors.warning),
      AppSheetTone.danger => (colors.dangerSurface, colors.danger),
      AppSheetTone.neutral => (colors.surfaceElevated, colors.textPrimary),
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 28, color: foreground),
    );
  }
}
