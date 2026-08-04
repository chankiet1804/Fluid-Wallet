import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/theme.dart';

/// Round badge for a token, optionally stamped with its chain.
///
/// Three fallback tiers, in order: the remote logo from `chains-default.json`,
/// the bundled SVG for a known symbol, then a lettered badge. The file is the
/// single source for chains and tokens, so its `icon` wins — editing the JSON
/// has to be enough to change what renders. The bundled SVG doubles as the
/// placeholder while the remote image loads and as the error fallback, so a
/// dead URL degrades to a real mark instead of a letter.
class TokenIcon extends StatelessWidget {
  const TokenIcon({
    super.key,
    required this.symbol,
    this.size = 40,
    this.iconUrl,
    this.chainIconAsset,
    this.chainIconUrl,
    this.badgeSize = 16,
  });

  final String symbol;
  final double size;

  /// Remote logo from `chains-default.json`. Preferred over the bundled asset.
  final String? iconUrl;

  /// Bundled network mark for the corner badge, used when [chainIconUrl] is
  /// missing or fails. Both null hides the badge — pass null for each when the
  /// list is already filtered to one chain and the badge would be noise on
  /// every row.
  final String? chainIconAsset;

  /// Remote network logo from `chains-default.json`. Preferred over
  /// [chainIconAsset].
  final String? chainIconUrl;

  final double badgeSize;

  /// Keyed by upper-cased symbol. `wstETH` maps to the ETH mark: it is wrapped
  /// staked ETH and the set ships no separate asset for it.
  static const _assets = <String, String>{
    'ETH': 'assets/icons/tokens/eth.svg',
    'WETH': 'assets/icons/tokens/eth.svg',
    'WSTETH': 'assets/icons/tokens/eth.svg',
    'USDC': 'assets/icons/tokens/usdc.svg',
    'USDT': 'assets/icons/tokens/usdt.svg',
    'BNB': 'assets/icons/tokens/bnb.svg',
    'ARB': 'assets/icons/tokens/arb.svg',
    'OP': 'assets/icons/tokens/op.svg',
    'POL': 'assets/icons/tokens/pol.svg',
    'MATIC': 'assets/icons/tokens/matic.svg',
  };

  @override
  Widget build(BuildContext context) {
    final mark = _mark(context);
    if (chainIconAsset == null && chainIconUrl == null) return mark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          mark,
          Positioned(
            right: -badgeSize / 6,
            bottom: -badgeSize / 6,
            child: _ChainBadge(
              asset: chainIconAsset,
              url: chainIconUrl,
              size: badgeSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mark(BuildContext context) {
    final asset = _assets[symbol.toUpperCase()];
    final fallback = asset != null
        ? SvgPicture.asset(asset, width: size, height: size)
        : _LetterBadge(symbol: symbol, size: size);

    // Both the remote PNG and the `background` SVG variant ship their own
    // full-bleed brand backdrop — clipping is what makes either a badge.
    return ClipOval(child: _remoteOr(iconUrl, fallback, size));
  }
}

/// The remote image when there is one, [fallback] otherwise — and [fallback]
/// again while it loads or if it fails.
Widget _remoteOr(String? url, Widget fallback, double size) {
  if (url == null || url.isEmpty) return fallback;

  return CachedNetworkImage(
    imageUrl: url,
    width: size,
    height: size,
    fit: BoxFit.cover,
    placeholder: (_, _) => fallback,
    errorWidget: (_, _, _) => fallback,
  );
}

class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.size, this.asset, this.url});

  final String? asset;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final asset = this.asset;
    final url = this.url;

    if (asset == null && (url == null || url.isEmpty)) {
      return const SizedBox.shrink();
    }

    final inner = _remoteOr(
      url,
      asset != null
          ? SvgPicture.asset(asset, width: size, height: size)
          : const SizedBox.shrink(),
      size,
    );

    // The ring is what keeps a dark chain mark readable against a dark token
    // mark; without it the two shapes merge.
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
      child: ClipOval(child: inner),
    );
  }
}

class _LetterBadge extends StatelessWidget {
  const _LetterBadge({required this.symbol, required this.size});

  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final letter = symbol.isEmpty ? '?' : symbol.characters.first.toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: context.typo.label.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
