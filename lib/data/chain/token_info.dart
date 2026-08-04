import 'package:freezed_annotation/freezed_annotation.dart';

import 'asset_ref.dart';

part 'token_info.freezed.dart';

/// Where a token's identity came from.
///
/// This drives the unverified affordance in the UI: an airdropped contract that
/// calls itself `USDC` must not look like the real one.
enum TokenSource {
  /// Listed in `assets/config/chains-default.json`. Address and decimals are
  /// asserted by the registry tests.
  registry,

  /// Returned by the balance API and typed by the metadata endpoint. Shown, but
  /// flagged, and left out of the portfolio total.
  discovered,
}

/// One token on one chain.
///
/// [decimals] is required and has no default. A discovered token whose metadata
/// cannot be resolved does NOT become a `TokenInfo` with 18 — it stays an
/// `UnresolvedAsset` that renders no number at all. Guessing 18 for a 6-decimal
/// token overstates a balance by 10^12, and the registry has both: USDT is 6 on
/// Ethereum and 18 on BNB Chain.
@freezed
abstract class TokenInfo with _$TokenInfo {
  const factory TokenInfo({
    required AssetRef ref,
    required String symbol,
    required String name,
    required int decimals,
    required TokenSource source,

    /// `status == 'enabled'` in the file. Discovered tokens are always true.
    @Default(true) bool isEnabled,

    /// EIP-55 checksummed, for display and explorer links. `ref.address` stays
    /// lower case and is the only value used as a key. Null for native.
    String? checksumAddress,

    /// Remote logo from the registry, and what `TokenIcon` renders first. The
    /// bundled SVG for the symbol is the fallback, then the letter badge.
    String? iconUrl,

    /// CoinGecko coin id. The primary pricing key — never the symbol, because
    /// the registry carries eight different USDT contracts across eight chains
    /// under five distinct ids.
    String? coingeckoId,

    /// Comma-separated TradingView symbols, carried through from the registry.
    String? tradingSymbol,

    /// Order of appearance within its chain in the file.
    @Default(0) int sortOrder,
  }) = _TokenInfo;

  const TokenInfo._();

  int get chainId => ref.chainId;
  bool get isNative => ref.isNative;
  bool get isVerified => source == TokenSource.registry;

  /// Null for native. The nullability is deliberate: this is the one place the
  /// analyzer forces Phase 4/5 code to acknowledge that a native coin has no
  /// contract — the safety a sealed union would buy, at the single call site
  /// that needs it rather than at all of them.
  String? get contractAddress => isNative ? null : checksumAddress;
}
