import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Decorative chain badges drifting across a shallow arc behind the app mark.
///
/// Purely visual — no wallet state, no network. The arc crest sits on the logo
/// centre, so badges pass under it as long as this widget is painted before
/// the logo in the parent [Stack].
class ChainArc extends StatefulWidget {
  const ChainArc({super.key, required this.crestY});

  /// Vertical offset of the arc crest inside this box. Must be the logo's
  /// centre, otherwise the badges pass beside it instead of behind it.
  final double crestY;

  /// Ordered so neighbouring badges never share a backdrop tone — the badges
  /// carry their own brand colour now, so two dark ones in a row read as a gap.
  static const _assets = <String>[
    'assets/icons/networks/ethereum.svg',
    'assets/icons/networks/avalanche.svg',
    'assets/icons/networks/arbitrum-one.svg',
    'assets/icons/networks/sonic.svg',
    'assets/icons/networks/polygon.svg',
    'assets/icons/networks/optimism.svg',
    'assets/icons/networks/swell.svg',
    'assets/icons/networks/binance-smart-chain.svg',
    'assets/icons/networks/ronin.svg',
    'assets/icons/networks/lycan.svg',
  ];

  /// One full trip around the conveyor. Slow on purpose — this runs behind the
  /// first screen the user ever sees, it should not compete with the buttons.
  /// The conveyor is roughly twice the screen width, so a single badge takes
  /// about half of this to cross from edge to edge.
  static const _period = Duration(seconds: 52);

  static const _bubbleSize = 48.0;

  /// Gap between badge centres along the conveyor. This is the knob for how
  /// dense the arc reads — comfortably wider than [_bubbleSize] so badges
  /// never touch, no matter how many chains the list grows to.
  static const _spacing = 96.0;

  /// How far the arc ends drop below the crest. Small on purpose — the design
  /// is a wide, shallow curve, not an orbit.
  static const _sagitta = 44.0;

  /// Fraction of the sweep spent fading in at each end.
  static const _edgeFade = 0.12;

  /// Opacity of a badge at the middle of the sweep. Held below 1 so the
  /// backdrop layer stays visibly behind the logo instead of competing with it.
  static const _badgeOpacity = 0.8;

  @override
  State<ChainArc> createState() => _ChainArcState();
}

class _ChainArcState extends State<ChainArc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ChainArc._period,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // Overshoot both sides so badges enter and leave past the edges
          // instead of appearing inside the screen.
          final travel = width + ChainArc._bubbleSize * 2;

          // Built once, outside the per-frame builder: identical widget
          // instances let the SVG subtrees skip rebuilding on every tick.
          final badges = [
            for (final asset in ChainArc._assets) _ChainBadge(asset: asset),
          ];

          // Badges ride a conveyor longer than the visible span, so only a
          // handful are on screen at a time. The floor keeps the conveyor from
          // wrapping mid-screen on very wide layouts.
          final loop = math.max(
            ChainArc._spacing * badges.length,
            travel + ChainArc._spacing,
          );

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < badges.length; i++)
                    _positioned(
                      badge: badges[i],
                      crestY: widget.crestY,
                      travel: travel,
                      loop: loop,
                      phase: (_controller.value + i / badges.length) % 1.0,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _positioned({
    required Widget badge,
    required double crestY,
    required double travel,
    required double loop,
    required double phase,
  }) {
    // Left to right at a constant horizontal speed along the conveyor.
    final x = phase * loop - ChainArc._bubbleSize;

    // Where the badge sits across the visible span: 0 just off the left edge,
    // 1 just off the right. Past that it is still on the conveyor but behind
    // the screen, so there is nothing to lay out.
    final progress = (x + ChainArc._bubbleSize) / travel;
    if (progress > 1) return const SizedBox.shrink();

    // The vertical offset draws the curve. A parabola reads the same as a
    // circular arc this shallow and keeps the ends from running off the top
    // of the box.
    final offset = 2 * progress - 1;
    final position = Offset(x, crestY + ChainArc._sagitta * offset * offset);

    // Fade and shrink near both ends so badges never pop in or out.
    final fade = (math.min(progress, 1 - progress) / ChainArc._edgeFade).clamp(
      0.0,
      1.0,
    );
    final scale = 0.7 + 0.3 * fade;

    return Positioned(
      left: position.dx - ChainArc._bubbleSize / 2,
      top: position.dy - ChainArc._bubbleSize / 2,
      child: Opacity(
        opacity: fade * ChainArc._badgeOpacity,
        child: Transform.scale(scale: scale, child: badge),
      ),
    );
  }
}

class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    // The `background` variant ships its own brand backdrop, but as a
    // full-bleed square — clipping is what makes it a badge.
    return ClipOval(
      child: SvgPicture.asset(
        asset,
        width: ChainArc._bubbleSize,
        height: ChainArc._bubbleSize,
      ),
    );
  }
}
