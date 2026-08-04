// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TokenInfo {

 AssetRef get ref; String get symbol; String get name; int get decimals; TokenSource get source;/// `status == 'enabled'` in the file. Discovered tokens are always true.
 bool get isEnabled;/// EIP-55 checksummed, for display and explorer links. `ref.address` stays
/// lower case and is the only value used as a key. Null for native.
 String? get checksumAddress;/// Remote logo from the registry, and what `TokenIcon` renders first. The
/// bundled SVG for the symbol is the fallback, then the letter badge.
 String? get iconUrl;/// CoinGecko coin id. The primary pricing key — never the symbol, because
/// the registry carries eight different USDT contracts across eight chains
/// under five distinct ids.
 String? get coingeckoId;/// Comma-separated TradingView symbols, carried through from the registry.
 String? get tradingSymbol;/// Order of appearance within its chain in the file.
 int get sortOrder;
/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<TokenInfo> get copyWith => _$TokenInfoCopyWithImpl<TokenInfo>(this as TokenInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenInfo&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.source, source) || other.source == source)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.checksumAddress, checksumAddress) || other.checksumAddress == checksumAddress)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.coingeckoId, coingeckoId) || other.coingeckoId == coingeckoId)&&(identical(other.tradingSymbol, tradingSymbol) || other.tradingSymbol == tradingSymbol)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,ref,symbol,name,decimals,source,isEnabled,checksumAddress,iconUrl,coingeckoId,tradingSymbol,sortOrder);

@override
String toString() {
  return 'TokenInfo(ref: $ref, symbol: $symbol, name: $name, decimals: $decimals, source: $source, isEnabled: $isEnabled, checksumAddress: $checksumAddress, iconUrl: $iconUrl, coingeckoId: $coingeckoId, tradingSymbol: $tradingSymbol, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $TokenInfoCopyWith<$Res>  {
  factory $TokenInfoCopyWith(TokenInfo value, $Res Function(TokenInfo) _then) = _$TokenInfoCopyWithImpl;
@useResult
$Res call({
 AssetRef ref, String symbol, String name, int decimals, TokenSource source, bool isEnabled, String? checksumAddress, String? iconUrl, String? coingeckoId, String? tradingSymbol, int sortOrder
});




}
/// @nodoc
class _$TokenInfoCopyWithImpl<$Res>
    implements $TokenInfoCopyWith<$Res> {
  _$TokenInfoCopyWithImpl(this._self, this._then);

  final TokenInfo _self;
  final $Res Function(TokenInfo) _then;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? symbol = null,Object? name = null,Object? decimals = null,Object? source = null,Object? isEnabled = null,Object? checksumAddress = freezed,Object? iconUrl = freezed,Object? coingeckoId = freezed,Object? tradingSymbol = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as AssetRef,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TokenSource,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,checksumAddress: freezed == checksumAddress ? _self.checksumAddress : checksumAddress // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,coingeckoId: freezed == coingeckoId ? _self.coingeckoId : coingeckoId // ignore: cast_nullable_to_non_nullable
as String?,tradingSymbol: freezed == tradingSymbol ? _self.tradingSymbol : tradingSymbol // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenInfo].
extension TokenInfoPatterns on TokenInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenInfo value)  $default,){
final _that = this;
switch (_that) {
case _TokenInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TokenInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssetRef ref,  String symbol,  String name,  int decimals,  TokenSource source,  bool isEnabled,  String? checksumAddress,  String? iconUrl,  String? coingeckoId,  String? tradingSymbol,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenInfo() when $default != null:
return $default(_that.ref,_that.symbol,_that.name,_that.decimals,_that.source,_that.isEnabled,_that.checksumAddress,_that.iconUrl,_that.coingeckoId,_that.tradingSymbol,_that.sortOrder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssetRef ref,  String symbol,  String name,  int decimals,  TokenSource source,  bool isEnabled,  String? checksumAddress,  String? iconUrl,  String? coingeckoId,  String? tradingSymbol,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _TokenInfo():
return $default(_that.ref,_that.symbol,_that.name,_that.decimals,_that.source,_that.isEnabled,_that.checksumAddress,_that.iconUrl,_that.coingeckoId,_that.tradingSymbol,_that.sortOrder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssetRef ref,  String symbol,  String name,  int decimals,  TokenSource source,  bool isEnabled,  String? checksumAddress,  String? iconUrl,  String? coingeckoId,  String? tradingSymbol,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _TokenInfo() when $default != null:
return $default(_that.ref,_that.symbol,_that.name,_that.decimals,_that.source,_that.isEnabled,_that.checksumAddress,_that.iconUrl,_that.coingeckoId,_that.tradingSymbol,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _TokenInfo extends TokenInfo {
  const _TokenInfo({required this.ref, required this.symbol, required this.name, required this.decimals, required this.source, this.isEnabled = true, this.checksumAddress, this.iconUrl, this.coingeckoId, this.tradingSymbol, this.sortOrder = 0}): super._();
  

@override final  AssetRef ref;
@override final  String symbol;
@override final  String name;
@override final  int decimals;
@override final  TokenSource source;
/// `status == 'enabled'` in the file. Discovered tokens are always true.
@override@JsonKey() final  bool isEnabled;
/// EIP-55 checksummed, for display and explorer links. `ref.address` stays
/// lower case and is the only value used as a key. Null for native.
@override final  String? checksumAddress;
/// Remote logo from the registry, and what `TokenIcon` renders first. The
/// bundled SVG for the symbol is the fallback, then the letter badge.
@override final  String? iconUrl;
/// CoinGecko coin id. The primary pricing key — never the symbol, because
/// the registry carries eight different USDT contracts across eight chains
/// under five distinct ids.
@override final  String? coingeckoId;
/// Comma-separated TradingView symbols, carried through from the registry.
@override final  String? tradingSymbol;
/// Order of appearance within its chain in the file.
@override@JsonKey() final  int sortOrder;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenInfoCopyWith<_TokenInfo> get copyWith => __$TokenInfoCopyWithImpl<_TokenInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenInfo&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.source, source) || other.source == source)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.checksumAddress, checksumAddress) || other.checksumAddress == checksumAddress)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.coingeckoId, coingeckoId) || other.coingeckoId == coingeckoId)&&(identical(other.tradingSymbol, tradingSymbol) || other.tradingSymbol == tradingSymbol)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,ref,symbol,name,decimals,source,isEnabled,checksumAddress,iconUrl,coingeckoId,tradingSymbol,sortOrder);

@override
String toString() {
  return 'TokenInfo(ref: $ref, symbol: $symbol, name: $name, decimals: $decimals, source: $source, isEnabled: $isEnabled, checksumAddress: $checksumAddress, iconUrl: $iconUrl, coingeckoId: $coingeckoId, tradingSymbol: $tradingSymbol, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$TokenInfoCopyWith<$Res> implements $TokenInfoCopyWith<$Res> {
  factory _$TokenInfoCopyWith(_TokenInfo value, $Res Function(_TokenInfo) _then) = __$TokenInfoCopyWithImpl;
@override @useResult
$Res call({
 AssetRef ref, String symbol, String name, int decimals, TokenSource source, bool isEnabled, String? checksumAddress, String? iconUrl, String? coingeckoId, String? tradingSymbol, int sortOrder
});




}
/// @nodoc
class __$TokenInfoCopyWithImpl<$Res>
    implements _$TokenInfoCopyWith<$Res> {
  __$TokenInfoCopyWithImpl(this._self, this._then);

  final _TokenInfo _self;
  final $Res Function(_TokenInfo) _then;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? symbol = null,Object? name = null,Object? decimals = null,Object? source = null,Object? isEnabled = null,Object? checksumAddress = freezed,Object? iconUrl = freezed,Object? coingeckoId = freezed,Object? tradingSymbol = freezed,Object? sortOrder = null,}) {
  return _then(_TokenInfo(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as AssetRef,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TokenSource,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,checksumAddress: freezed == checksumAddress ? _self.checksumAddress : checksumAddress // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,coingeckoId: freezed == coingeckoId ? _self.coingeckoId : coingeckoId // ignore: cast_nullable_to_non_nullable
as String?,tradingSymbol: freezed == tradingSymbol ? _self.tradingSymbol : tradingSymbol // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
