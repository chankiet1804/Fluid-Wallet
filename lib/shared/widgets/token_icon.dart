import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/theme.dart';

/// Round badge for a token symbol.
///
/// Symbols the bundled icon set does not cover fall back to a lettered badge
/// rather than throwing — the token list is data-driven from Phase 2 on, so an
/// unknown symbol must degrade, not crash the portfolio.
class TokenIcon extends StatelessWidget {
  const TokenIcon({super.key, required this.symbol, this.size = 40});

  final String symbol;
  final double size;

  /// Keyed by upper-cased symbol. `wstETH` maps to the ETH mark: it is wrapped
  /// staked ETH and the set ships no separate asset for it.
  static const _assets = <String, String>{
    'ETH': 'assets/icons/tokens/eth.svg',
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
    final asset = _assets[symbol.toUpperCase()];
    if (asset == null) return _LetterBadge(symbol: symbol, size: size);

    // The `background` variant ships its own brand backdrop as a full-bleed
    // square — clipping is what makes it a badge.
    return ClipOval(
      child: SvgPicture.asset(asset, width: size, height: size),
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
