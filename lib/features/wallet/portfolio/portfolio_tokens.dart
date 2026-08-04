import 'package:flutter/foundation.dart';

import '../../../core/money/money.dart';
import '../../../data/chain/chain.dart';

/// One row of the portfolio token list, already formatted.
///
/// Every number becomes a string here, once. No widget below this holds a
/// `Decimal`, a `BigInt` or a `TokenAmount`, and none of them does arithmetic —
/// which keeps the money rules in one place instead of spread across the widget
/// tree.
@immutable
class PortfolioRowVm {
  const PortfolioRowVm({
    required this.symbol,
    required this.name,
    required this.amountText,
    required this.fiatText,
    required this.isVerified,
    this.iconUrl,
    this.chainName,
    this.chainIconAsset,
    this.chainIconUrl,
  });

  /// Builds a row from a balance.
  ///
  /// [showChainBadge] is false when the list is already filtered to one chain —
  /// the same badge on every row is noise, not information.
  factory PortfolioRowVm.from(
    TokenBalance balance, {
    ChainInfo? chain,
    bool showChainBadge = true,
  }) {
    final fiat = balance.fiat;

    return PortfolioRowVm(
      symbol: balance.token.symbol,
      name: balance.token.name,
      amountText: balance.amount.formatOrDust(),
      // An em dash, never "$0.00": a holding with no quote is unpriced, not
      // worthless, and the two must not look the same.
      fiatText: fiat == null
          ? '—'
          : FiatFormat.formatOrDust(fiat.value, currency: fiat.currency),
      isVerified: balance.token.isVerified,
      iconUrl: balance.token.iconUrl,
      chainName: chain?.name,
      // Both are passed; `TokenIcon` is the one place that ranks them.
      chainIconAsset: showChainBadge ? chain?.bundledIconAsset : null,
      chainIconUrl: showChainBadge ? chain?.iconUrl : null,
    );
  }

  final String symbol;
  final String name;
  final String amountText;
  final String fiatText;

  /// False for a token the registry does not list. Drives the unverified mark —
  /// an airdropped contract calling itself `USDC` must not read as the real one.
  final bool isVerified;

  final String? iconUrl;
  final String? chainName;
  final String? chainIconAsset;
  final String? chainIconUrl;
}
