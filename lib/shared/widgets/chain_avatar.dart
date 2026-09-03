import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/chain/chain.dart';

/// A chain's mark: the registry's URL, with the bundled SVG standing in while
/// it loads and if it fails.
class ChainAvatar extends StatelessWidget {
  const ChainAvatar({super.key, required this.chain, this.size = 20});

  final ChainInfo chain;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = chain.bundledIconAsset;
    final url = chain.iconUrl;

    final Widget fallback = asset == null
        ? SizedBox(width: size, height: size)
        : SvgPicture.asset(asset, width: size, height: size);

    if (url == null || url.isEmpty) return ClipOval(child: fallback);

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}
