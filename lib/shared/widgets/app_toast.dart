import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../app/theme/theme.dart';

/// Role of a toast. Only two, on purpose.
///
/// A toast reports something that already happened and then disappears on its
/// own. Anything the user has to decide, and every transaction result, is a
/// bottom sheet — see the plan overview §4.6.
enum AppToastType { success, error }

/// The app's ephemeral feedback surface: an icon, a title, an optional
/// subtitle, sliding down from the top and closing itself.
///
/// Deliberately not a channel for money: a failed transfer is a sheet the user
/// has to acknowledge, never a strip that vanishes after three seconds.
///
/// Needs [ToastificationWrapper] above [MaterialApp] (see `main.dart`); that is
/// what makes the `context` argument unnecessary here, so a Riverpod listener
/// or a repository error path can report without holding a [BuildContext].
abstract final class AppToast {
  static const _autoClose = Duration(seconds: 3);

  static void success({required String title, String? subtitle}) =>
      _show(AppToastType.success, title, subtitle);

  static void error({required String title, String? subtitle}) =>
      _show(AppToastType.error, title, subtitle);

  static void _show(AppToastType type, String title, String? subtitle) {
    toastification.showCustom(
      alignment: Alignment.topCenter,
      autoCloseDuration: _autoClose,
      animationDuration: AppDimens.durationMedium,
      callbacks: ToastificationCallbacks(
        onTap: (item) => toastification.dismiss(item),
      ),
      builder: (context, item) => _AppToastBody(
        item: item,
        type: type,
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}

class _AppToastBody extends StatelessWidget {
  const _AppToastBody({
    required this.item,
    required this.type,
    required this.title,
    required this.subtitle,
  });

  final ToastificationItem item;
  final AppToastType type;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;

    final (tone, tint) = switch (type) {
      AppToastType.success => (colors.success, colors.successSurface),
      AppToastType.error => (colors.danger, colors.dangerSurface),
    };

    // Sized against the screen rather than against the incoming constraints on
    // purpose: the overlay hands the toast a fixed width from its own config,
    // and that width is captured when the manager is first created — a stale
    // one (hot reload, a different config) would run the strip off the edge.
    // Centring a screen-derived width inside whatever we are given is correct
    // either way. The overlay already keeps clear of the status bar and the
    // keyboard; only the side gutter is ours.
    final width =
        MediaQuery.sizeOf(context).width - AppDimens.screenPadding * 2;

    return Center(
      child: SizedBox(
        width: width,
        child: Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.up,
          onDismissed: (_) =>
              toastification.dismiss(item, showRemoveAnimation: false),
          child: Container(
            decoration: BoxDecoration(
              // The tone surfaces are ~12% alpha. A toast floats over
              // arbitrary content, so the tint is blended onto an opaque
              // surface here rather than painted over whatever happens to be
              // behind it — otherwise a chart or a token logo reads straight
              // through the text.
              color: Color.alphaBlend(tint, colors.surfaceElevated),
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: tone),
            ),
            padding: const EdgeInsets.all(AppDimens.space12),
            child: Row(
              children: [
                _ToastIcon(type: type, tone: tone),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: context.typo.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppDimens.space4),
                        Text(
                          subtitle,
                          style: context.typo.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                          // Tx hashes and RPC error strings run long.
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Solid tone circle with a white glyph — same badge idea as the action sheet,
/// sized down for a strip. [AppColors.onAccent] is the token for a foreground
/// sitting on a filled colour.
class _ToastIcon extends StatelessWidget {
  const _ToastIcon({required this.type, required this.tone});

  final AppToastType type;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      AppToastType.success => Icons.check_rounded,
      AppToastType.error => Icons.close_rounded,
    };

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: context.colors.onAccent),
    );
  }
}
