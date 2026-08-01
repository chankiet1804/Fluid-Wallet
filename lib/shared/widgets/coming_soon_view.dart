import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';

/// Empty state for a tab that has no content yet.
///
/// Body only — screens that use this sit inside a shell that supplies the
/// Scaffold.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    this.title = 'Coming Soon',
    this.message =
        'We are already working on this functionality '
        'and it will be coming soon.',
  });

  final String title;
  final String message;

  /// Keeps the message on two balanced lines instead of one wide one.
  static const _messageWidth = 320.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Hourglass(size: 112),
            const SizedBox(height: AppDimens.space32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.typo.displayMedium,
            ),
            const SizedBox(height: AppDimens.space12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _messageWidth),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: context.typo.bodyLarge.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An hourglass that pours, empties, flips, and starts over.
class _Hourglass extends StatefulWidget {
  const _Hourglass({required this.size});

  /// Height of the glass. Width is derived so the shape keeps its proportions.
  final double size;

  static const _widthRatio = 0.66;

  /// One pour + flip. Slow on purpose — this sits behind a "nothing here yet"
  /// message and must not read as a loading spinner.
  static const _period = Duration(milliseconds: 5200);

  /// Normalised cycle boundaries. Sand runs out at [_pourEnd], then the glass
  /// rests until [_flipStart] so the eye registers "empty" before it turns.
  static const _pourEnd = 0.80;
  static const _flipStart = 0.88;

  /// How many grains pass down the stream over a full cycle. This is what
  /// reads as *falling* — a level that only sinks looks like a progress bar.
  static const _grainCycles = 11.0;

  /// Frame held when the platform asks for no animations: half poured, so the
  /// shape is still legible as an hourglass.
  static const _stillFrame = 0.4;

  @override
  State<_Hourglass> createState() => _HourglassState();
}

class _HourglassState extends State<_Hourglass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _Hourglass._period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = _Hourglass._stillFrame;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = Size(
      widget.size * _Hourglass._widthRatio,
      widget.size,
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pouring = t < _Hourglass._pourEnd;

          // Share of sand still in the upper bulb. Linear, so the stream runs
          // at a constant rate the way a real one does.
          final fill = pouring ? 1 - t / _Hourglass._pourEnd : 0.0;

          // The turn only happens in the last slice of the cycle. When the
          // cycle wraps, the angle snaps back to 0 while `fill` snaps back to
          // 1 — those cancel out only because the drawing is symmetric about
          // its centre, which is why the two bulbs and caps must stay
          // identical.
          final angle = t < _Hourglass._flipStart
              ? 0.0
              : math.pi *
                    Curves.easeInOutCubic.transform(
                      (t - _Hourglass._flipStart) /
                          (1 - _Hourglass._flipStart),
                    );

          return Transform.rotate(
            angle: angle,
            child: CustomPaint(
              size: size,
              painter: _HourglassPainter(
                fill: fill,
                pouring: pouring,
                grainPhase: (t * _Hourglass._grainCycles) % 1.0,
                frame: colors.textSecondary,
                // Elevated rather than `surface`: the glass sits directly on
                // the screen background and needs a step of contrast to read
                // as a body at all.
                glass: colors.surfaceElevated,
                outline: colors.textTertiary,
                sand: colors.warning,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HourglassPainter extends CustomPainter {
  const _HourglassPainter({
    required this.fill,
    required this.pouring,
    required this.grainPhase,
    required this.frame,
    required this.glass,
    required this.outline,
    required this.sand,
  });

  /// Share of sand left in the upper bulb, 1 down to 0.
  final double fill;
  final bool pouring;
  final double grainPhase;
  final Color frame;
  final Color glass;

  /// Edge of the glass. Without it the bulbs disappear wherever sand covers
  /// them and the whole thing reads as a rectangle with a triangle inside.
  final Color outline;
  final Color sand;

  // All geometry is expressed as a fraction of the box so the widget scales.
  static const _capHeight = 0.07;
  /// Held clear of the posts so the glass edge reads as its own line instead
  /// of merging into the frame.
  static const _bulbHalfWidth = 0.37;
  static const _neckHalfWidth = 0.05;
  static const _outlineWidth = 0.022;

  /// Pulls the side curve inward so the bulb reads as a funnel, not a bubble.
  static const _waistPull = 0.62;

  static const _streamWidth = 0.03;
  static const _grainRadius = 0.022;
  static const _grainCount = 3;

  /// Height of the cone on top of the settled sand, as a share of one bulb.
  static const _moundPeak = 0.14;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final capH = h * _capHeight;
    final neckY = h / 2;
    final bulbTop = capH;
    final bulbBottom = h - capH;
    final bulbHeight = neckY - bulbTop;

    final topBulb = _bulb(size, top: true);
    final bottomBulb = _bulb(size, top: false);

    final glassPaint = Paint()..color = glass;
    canvas.drawPath(topBulb, glassPaint);
    canvas.drawPath(bottomBulb, glassPaint);

    final sandPaint = Paint()..color = sand;

    // Upper bulb: a flat level that sinks toward the neck. The funnel shape
    // comes from the clip, so the sand never needs its own outline.
    if (fill > 0) {
      final level = bulbTop + bulbHeight * (1 - fill);
      canvas.save();
      canvas.clipPath(topBulb);
      canvas.drawRect(Rect.fromLTRB(0, level, w, neckY), sandPaint);
      canvas.restore();
    }

    // Lower bulb: the mound rises, with a cone on top so it reads as a heap
    // rather than a filled container.
    final settled = 1 - fill;
    final moundTop = bulbBottom - bulbHeight * settled;
    final peakH = bulbHeight * _moundPeak * math.min(settled * 4, 1);
    final apexY = moundTop - peakH;

    canvas.save();
    canvas.clipPath(bottomBulb);
    canvas.drawRect(Rect.fromLTRB(0, moundTop, w, bulbBottom), sandPaint);
    if (peakH > 0) {
      final cone = Path()
        ..moveTo(cx - w * 0.22, moundTop)
        ..lineTo(cx, apexY)
        ..lineTo(cx + w * 0.22, moundTop)
        ..close();
      canvas.drawPath(cone, sandPaint);
    }
    canvas.restore();

    if (pouring) {
      canvas.save();
      canvas.clipPath(bottomBulb);
      canvas.drawLine(
        Offset(cx, neckY),
        Offset(cx, apexY),
        Paint()
          ..color = sand
          ..strokeWidth = w * _streamWidth,
      );
      // Grains spaced evenly along the stream, each on its own phase, so the
      // column looks like it is moving instead of just standing there.
      for (var i = 0; i < _grainCount; i++) {
        final phase = (grainPhase + i / _grainCount) % 1.0;
        canvas.drawCircle(
          Offset(cx, neckY + (apexY - neckY) * phase),
          w * _grainRadius,
          sandPaint,
        );
      }
      canvas.restore();
    }

    // Glass edge over the sand, so the funnel silhouette stays visible even
    // when a bulb is completely full.
    final outlinePaint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, w * _outlineWidth)
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(topBulb, outlinePaint);
    canvas.drawPath(bottomBulb, outlinePaint);

    // Frame last so it covers the glass edges.
    final framePaint = Paint()..color = frame;
    final capRadius = Radius.circular(capH * 0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, capH), capRadius),
      framePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h - capH, w, capH),
        capRadius,
      ),
      framePaint,
    );
  }

  /// One bulb: straight across the cap end, then two curves pinching into the
  /// neck. The bottom is the top mirrored, which keeps the whole drawing
  /// symmetric about its centre — required for the flip to loop seamlessly.
  Path _bulb(Size size, {required bool top}) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final capH = h * _capHeight;
    final neckY = h / 2;
    final endY = top ? capH : h - capH;
    final bulbHeight = neckY - capH;
    final waistY = top
        ? capH + bulbHeight * _waistPull
        : h - capH - bulbHeight * _waistPull;
    final halfW = w * _bulbHalfWidth;
    final neckW = w * _neckHalfWidth;

    return Path()
      ..moveTo(cx - halfW, endY)
      ..lineTo(cx + halfW, endY)
      ..quadraticBezierTo(cx + halfW * 0.9, waistY, cx + neckW, neckY)
      ..lineTo(cx - neckW, neckY)
      ..quadraticBezierTo(cx - halfW * 0.9, waistY, cx - halfW, endY)
      ..close();
  }

  @override
  bool shouldRepaint(_HourglassPainter old) {
    return old.fill != fill ||
        old.pouring != pouring ||
        old.grainPhase != grainPhase ||
        old.frame != frame ||
        old.glass != glass ||
        old.outline != outline ||
        old.sand != sand;
  }
}
