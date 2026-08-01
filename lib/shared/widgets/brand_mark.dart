import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/theme.dart';

/// The Fluid glyph on its light disc.
///
/// The disc uses the `qrSurface` token on purpose: the mark is drawn for a
/// light background and stays readable that way in the dark theme.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.size});

  final double size;

  /// The glyph never fills the disc edge to edge.
  static const _glyphRatio = 0.875;

  @override
  Widget build(BuildContext context) {
    final glyphSize = size * _glyphRatio;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.qrSurface,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/icons/brand/fluid.svg',
        width: glyphSize,
        height: glyphSize,
      ),
    );
  }
}
