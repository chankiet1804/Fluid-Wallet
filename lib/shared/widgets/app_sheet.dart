import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Opens a bottom sheet with the app's standard configuration.
///
/// `backgroundColor` is transparent because [AppSheet] paints its own surface —
/// the Material default would show a second, differently coloured layer behind
/// the rounded corners.
/// Pass `dismissible: false` only when the sheet reports something the user
/// must acknowledge; it blocks both tap-outside and drag-to-dismiss.
Future<T?> showAppSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    isDismissible: dismissible,
    enableDrag: dismissible,
    builder: builder,
  );
}

/// Shared frame for every sheet in the app — same surface, corner radius,
/// height cap and close affordance.
///
/// Sheets are the app's only confirmation and notification surface; see the
/// "Confirm & thông báo" section of the plan overview.
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    this.title,
    this.showClose = true,
    this.bottomInset = 0,
    required this.child,
  });

  /// Null renders the header as a bare close button, right-aligned.
  final String? title;

  final bool showClose;

  /// Pass `MediaQuery.viewInsetsOf(context).bottom` when the sheet hosts a text
  /// field, so the keyboard does not cover the action.
  final double bottomInset;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = this.title;

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
            if (title != null || showClose)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  AppDimens.space16,
                  AppDimens.space12,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: title == null
                          ? const SizedBox.shrink()
                          : Text(title, style: context.typo.titleMedium),
                    ),
                    if (showClose) const _CloseButton(),
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

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceElevated,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space4),
          child: Icon(Icons.close, size: 20, color: colors.textSecondary),
        ),
      ),
    );
  }
}
