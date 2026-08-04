import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/money/money.dart';
import 'asset_ref.dart';
import 'token_info.dart';

part 'token_balance.freezed.dart';

/// A token joined to how much of it an address holds, and what that is worth.
@freezed
abstract class TokenBalance with _$TokenBalance {
  const factory TokenBalance({
    required TokenInfo token,
    required TokenAmount amount,

    /// Null means "no price available", never "worth zero". A null here keeps
    /// the holding out of the total and increments
    /// `PortfolioSnapshot.unpricedCount`, so the UI can say the total is a lower
    /// bound instead of quietly understating it.
    FiatValue? fiat,
  }) = _TokenBalance;

  const TokenBalance._();

  AssetRef get ref => token.ref;
  int get chainId => token.chainId;
  bool get isZero => amount.isZero;
}

/// A balance the API returned for a contract we could not type.
///
/// Rendered in its own "Unrecognised" section with no amount and no fiat value:
/// without trustworthy `decimals`, any number printed here is a fabrication.
@freezed
abstract class UnresolvedAsset with _$UnresolvedAsset {
  const factory UnresolvedAsset({
    required AssetRef ref,
    required BigInt rawBalance,
    String? symbol,
  }) = _UnresolvedAsset;
}
