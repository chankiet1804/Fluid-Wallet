// For `@immutable` only — freezed_annotation re-exports package:meta, and this
// file deliberately imports nothing from Flutter so its tests need no binding.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'native_asset.dart';

/// Identifies one asset on one chain — the key for every balance, price and
/// metadata lookup in the app.
///
/// [address] is always lower case. Display code uses the checksummed string on
/// `TokenInfo`; keys are canonicalised so `0xA0b8…` and `0xa0b8…` can never
/// become two entries for the same token. That bug does not crash — it shows up
/// as a duplicated row or a balance that quietly vanishes.
///
/// A `(int, String)` record would give value equality just as cheaply, but it
/// cannot normalise its own fields, and `chains-default.json` really does mix
/// casing: Base writes USDC lower case, Ethereum writes it checksummed.
@immutable
class AssetRef {
  /// [address] must already be lower case. Only [ChainRegistry] should reach
  /// for this; everything else goes through the normalising constructor.
  const AssetRef.raw(this.chainId, this.address);

  factory AssetRef(int chainId, String address) =>
      AssetRef.raw(chainId, address.toLowerCase());

  factory AssetRef.native(int chainId) => AssetRef.raw(chainId, kNativeAddress);

  final int chainId;

  /// Lower case, `0x`-prefixed.
  final String address;

  bool get isNative => address == kNativeAddress;

  /// CAIP-19. Not a key today — it is here so that adding a non-EVM namespace
  /// later is a promotion of this getter rather than a redesign.
  String get caip19 => isNative
      ? 'eip155:$chainId/slip44:60'
      : 'eip155:$chainId/erc20:$address';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRef &&
          other.chainId == chainId &&
          other.address == address);

  @override
  int get hashCode => Object.hash(chainId, address);

  @override
  String toString() => 'AssetRef($chainId, $address)';
}

/// One wallet address on one chain.
///
/// Kept as a distinct type from [AssetRef] even though the shape matches: the
/// two are never interchangeable, and a compiler error beats a lookup that
/// silently returns nothing.
@immutable
class ChainAddress {
  const ChainAddress.raw(this.chainId, this.address);

  factory ChainAddress(int chainId, String address) =>
      ChainAddress.raw(chainId, address.toLowerCase());

  final int chainId;
  final String address;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChainAddress &&
          other.chainId == chainId &&
          other.address == address);

  @override
  int get hashCode => Object.hash(chainId, address);

  @override
  String toString() => 'ChainAddress($chainId, $address)';
}
