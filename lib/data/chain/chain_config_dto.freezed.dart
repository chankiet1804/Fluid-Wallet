// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chain_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChainConfigDto {

 String get chainId; String get chainName; String get chain; String get groupChain; String get symbol; String get rpcUrl; String get explorerUrl; int get decimals; String get derivationPath; String get status; String? get icon; List<RpcOptionDto> get rpcOptions; List<TokenConfigDto> get tokens;
/// Create a copy of ChainConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChainConfigDtoCopyWith<ChainConfigDto> get copyWith => _$ChainConfigDtoCopyWithImpl<ChainConfigDto>(this as ChainConfigDto, _$identity);

  /// Serializes this ChainConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChainConfigDto&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.groupChain, groupChain) || other.groupChain == groupChain)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.rpcUrl, rpcUrl) || other.rpcUrl == rpcUrl)&&(identical(other.explorerUrl, explorerUrl) || other.explorerUrl == explorerUrl)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.derivationPath, derivationPath) || other.derivationPath == derivationPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.rpcOptions, rpcOptions)&&const DeepCollectionEquality().equals(other.tokens, tokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainId,chainName,chain,groupChain,symbol,rpcUrl,explorerUrl,decimals,derivationPath,status,icon,const DeepCollectionEquality().hash(rpcOptions),const DeepCollectionEquality().hash(tokens));

@override
String toString() {
  return 'ChainConfigDto(chainId: $chainId, chainName: $chainName, chain: $chain, groupChain: $groupChain, symbol: $symbol, rpcUrl: $rpcUrl, explorerUrl: $explorerUrl, decimals: $decimals, derivationPath: $derivationPath, status: $status, icon: $icon, rpcOptions: $rpcOptions, tokens: $tokens)';
}


}

/// @nodoc
abstract mixin class $ChainConfigDtoCopyWith<$Res>  {
  factory $ChainConfigDtoCopyWith(ChainConfigDto value, $Res Function(ChainConfigDto) _then) = _$ChainConfigDtoCopyWithImpl;
@useResult
$Res call({
 String chainId, String chainName, String chain, String groupChain, String symbol, String rpcUrl, String explorerUrl, int decimals, String derivationPath, String status, String? icon, List<RpcOptionDto> rpcOptions, List<TokenConfigDto> tokens
});




}
/// @nodoc
class _$ChainConfigDtoCopyWithImpl<$Res>
    implements $ChainConfigDtoCopyWith<$Res> {
  _$ChainConfigDtoCopyWithImpl(this._self, this._then);

  final ChainConfigDto _self;
  final $Res Function(ChainConfigDto) _then;

/// Create a copy of ChainConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chainId = null,Object? chainName = null,Object? chain = null,Object? groupChain = null,Object? symbol = null,Object? rpcUrl = null,Object? explorerUrl = null,Object? decimals = null,Object? derivationPath = null,Object? status = null,Object? icon = freezed,Object? rpcOptions = null,Object? tokens = null,}) {
  return _then(_self.copyWith(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,groupChain: null == groupChain ? _self.groupChain : groupChain // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,rpcUrl: null == rpcUrl ? _self.rpcUrl : rpcUrl // ignore: cast_nullable_to_non_nullable
as String,explorerUrl: null == explorerUrl ? _self.explorerUrl : explorerUrl // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,derivationPath: null == derivationPath ? _self.derivationPath : derivationPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,rpcOptions: null == rpcOptions ? _self.rpcOptions : rpcOptions // ignore: cast_nullable_to_non_nullable
as List<RpcOptionDto>,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<TokenConfigDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChainConfigDto].
extension ChainConfigDtoPatterns on ChainConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChainConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChainConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChainConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _ChainConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChainConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChainConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chainId,  String chainName,  String chain,  String groupChain,  String symbol,  String rpcUrl,  String explorerUrl,  int decimals,  String derivationPath,  String status,  String? icon,  List<RpcOptionDto> rpcOptions,  List<TokenConfigDto> tokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChainConfigDto() when $default != null:
return $default(_that.chainId,_that.chainName,_that.chain,_that.groupChain,_that.symbol,_that.rpcUrl,_that.explorerUrl,_that.decimals,_that.derivationPath,_that.status,_that.icon,_that.rpcOptions,_that.tokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chainId,  String chainName,  String chain,  String groupChain,  String symbol,  String rpcUrl,  String explorerUrl,  int decimals,  String derivationPath,  String status,  String? icon,  List<RpcOptionDto> rpcOptions,  List<TokenConfigDto> tokens)  $default,) {final _that = this;
switch (_that) {
case _ChainConfigDto():
return $default(_that.chainId,_that.chainName,_that.chain,_that.groupChain,_that.symbol,_that.rpcUrl,_that.explorerUrl,_that.decimals,_that.derivationPath,_that.status,_that.icon,_that.rpcOptions,_that.tokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chainId,  String chainName,  String chain,  String groupChain,  String symbol,  String rpcUrl,  String explorerUrl,  int decimals,  String derivationPath,  String status,  String? icon,  List<RpcOptionDto> rpcOptions,  List<TokenConfigDto> tokens)?  $default,) {final _that = this;
switch (_that) {
case _ChainConfigDto() when $default != null:
return $default(_that.chainId,_that.chainName,_that.chain,_that.groupChain,_that.symbol,_that.rpcUrl,_that.explorerUrl,_that.decimals,_that.derivationPath,_that.status,_that.icon,_that.rpcOptions,_that.tokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChainConfigDto implements ChainConfigDto {
  const _ChainConfigDto({required this.chainId, required this.chainName, required this.chain, required this.groupChain, required this.symbol, required this.rpcUrl, required this.explorerUrl, required this.decimals, required this.derivationPath, required this.status, this.icon, final  List<RpcOptionDto> rpcOptions = const <RpcOptionDto>[], final  List<TokenConfigDto> tokens = const <TokenConfigDto>[]}): _rpcOptions = rpcOptions,_tokens = tokens;
  factory _ChainConfigDto.fromJson(Map<String, dynamic> json) => _$ChainConfigDtoFromJson(json);

@override final  String chainId;
@override final  String chainName;
@override final  String chain;
@override final  String groupChain;
@override final  String symbol;
@override final  String rpcUrl;
@override final  String explorerUrl;
@override final  int decimals;
@override final  String derivationPath;
@override final  String status;
@override final  String? icon;
 final  List<RpcOptionDto> _rpcOptions;
@override@JsonKey() List<RpcOptionDto> get rpcOptions {
  if (_rpcOptions is EqualUnmodifiableListView) return _rpcOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rpcOptions);
}

 final  List<TokenConfigDto> _tokens;
@override@JsonKey() List<TokenConfigDto> get tokens {
  if (_tokens is EqualUnmodifiableListView) return _tokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tokens);
}


/// Create a copy of ChainConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChainConfigDtoCopyWith<_ChainConfigDto> get copyWith => __$ChainConfigDtoCopyWithImpl<_ChainConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChainConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChainConfigDto&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.chain, chain) || other.chain == chain)&&(identical(other.groupChain, groupChain) || other.groupChain == groupChain)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.rpcUrl, rpcUrl) || other.rpcUrl == rpcUrl)&&(identical(other.explorerUrl, explorerUrl) || other.explorerUrl == explorerUrl)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.derivationPath, derivationPath) || other.derivationPath == derivationPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._rpcOptions, _rpcOptions)&&const DeepCollectionEquality().equals(other._tokens, _tokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainId,chainName,chain,groupChain,symbol,rpcUrl,explorerUrl,decimals,derivationPath,status,icon,const DeepCollectionEquality().hash(_rpcOptions),const DeepCollectionEquality().hash(_tokens));

@override
String toString() {
  return 'ChainConfigDto(chainId: $chainId, chainName: $chainName, chain: $chain, groupChain: $groupChain, symbol: $symbol, rpcUrl: $rpcUrl, explorerUrl: $explorerUrl, decimals: $decimals, derivationPath: $derivationPath, status: $status, icon: $icon, rpcOptions: $rpcOptions, tokens: $tokens)';
}


}

/// @nodoc
abstract mixin class _$ChainConfigDtoCopyWith<$Res> implements $ChainConfigDtoCopyWith<$Res> {
  factory _$ChainConfigDtoCopyWith(_ChainConfigDto value, $Res Function(_ChainConfigDto) _then) = __$ChainConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 String chainId, String chainName, String chain, String groupChain, String symbol, String rpcUrl, String explorerUrl, int decimals, String derivationPath, String status, String? icon, List<RpcOptionDto> rpcOptions, List<TokenConfigDto> tokens
});




}
/// @nodoc
class __$ChainConfigDtoCopyWithImpl<$Res>
    implements _$ChainConfigDtoCopyWith<$Res> {
  __$ChainConfigDtoCopyWithImpl(this._self, this._then);

  final _ChainConfigDto _self;
  final $Res Function(_ChainConfigDto) _then;

/// Create a copy of ChainConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainId = null,Object? chainName = null,Object? chain = null,Object? groupChain = null,Object? symbol = null,Object? rpcUrl = null,Object? explorerUrl = null,Object? decimals = null,Object? derivationPath = null,Object? status = null,Object? icon = freezed,Object? rpcOptions = null,Object? tokens = null,}) {
  return _then(_ChainConfigDto(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String,groupChain: null == groupChain ? _self.groupChain : groupChain // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,rpcUrl: null == rpcUrl ? _self.rpcUrl : rpcUrl // ignore: cast_nullable_to_non_nullable
as String,explorerUrl: null == explorerUrl ? _self.explorerUrl : explorerUrl // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,derivationPath: null == derivationPath ? _self.derivationPath : derivationPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,rpcOptions: null == rpcOptions ? _self._rpcOptions : rpcOptions // ignore: cast_nullable_to_non_nullable
as List<RpcOptionDto>,tokens: null == tokens ? _self._tokens : tokens // ignore: cast_nullable_to_non_nullable
as List<TokenConfigDto>,
  ));
}


}


/// @nodoc
mixin _$RpcOptionDto {

 String get name; String get url; String? get source;
/// Create a copy of RpcOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RpcOptionDtoCopyWith<RpcOptionDto> get copyWith => _$RpcOptionDtoCopyWithImpl<RpcOptionDto>(this as RpcOptionDto, _$identity);

  /// Serializes this RpcOptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RpcOptionDto&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,source);

@override
String toString() {
  return 'RpcOptionDto(name: $name, url: $url, source: $source)';
}


}

/// @nodoc
abstract mixin class $RpcOptionDtoCopyWith<$Res>  {
  factory $RpcOptionDtoCopyWith(RpcOptionDto value, $Res Function(RpcOptionDto) _then) = _$RpcOptionDtoCopyWithImpl;
@useResult
$Res call({
 String name, String url, String? source
});




}
/// @nodoc
class _$RpcOptionDtoCopyWithImpl<$Res>
    implements $RpcOptionDtoCopyWith<$Res> {
  _$RpcOptionDtoCopyWithImpl(this._self, this._then);

  final RpcOptionDto _self;
  final $Res Function(RpcOptionDto) _then;

/// Create a copy of RpcOptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RpcOptionDto].
extension RpcOptionDtoPatterns on RpcOptionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RpcOptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RpcOptionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RpcOptionDto value)  $default,){
final _that = this;
switch (_that) {
case _RpcOptionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RpcOptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _RpcOptionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String url,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RpcOptionDto() when $default != null:
return $default(_that.name,_that.url,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String url,  String? source)  $default,) {final _that = this;
switch (_that) {
case _RpcOptionDto():
return $default(_that.name,_that.url,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String url,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _RpcOptionDto() when $default != null:
return $default(_that.name,_that.url,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RpcOptionDto implements RpcOptionDto {
  const _RpcOptionDto({required this.name, required this.url, this.source});
  factory _RpcOptionDto.fromJson(Map<String, dynamic> json) => _$RpcOptionDtoFromJson(json);

@override final  String name;
@override final  String url;
@override final  String? source;

/// Create a copy of RpcOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RpcOptionDtoCopyWith<_RpcOptionDto> get copyWith => __$RpcOptionDtoCopyWithImpl<_RpcOptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RpcOptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RpcOptionDto&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,source);

@override
String toString() {
  return 'RpcOptionDto(name: $name, url: $url, source: $source)';
}


}

/// @nodoc
abstract mixin class _$RpcOptionDtoCopyWith<$Res> implements $RpcOptionDtoCopyWith<$Res> {
  factory _$RpcOptionDtoCopyWith(_RpcOptionDto value, $Res Function(_RpcOptionDto) _then) = __$RpcOptionDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String url, String? source
});




}
/// @nodoc
class __$RpcOptionDtoCopyWithImpl<$Res>
    implements _$RpcOptionDtoCopyWith<$Res> {
  __$RpcOptionDtoCopyWithImpl(this._self, this._then);

  final _RpcOptionDto _self;
  final $Res Function(_RpcOptionDto) _then;

/// Create a copy of RpcOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? source = freezed,}) {
  return _then(_RpcOptionDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TokenConfigDto {

 String get name; String get symbol; String get address; int get decimals; String get status; String? get icon; String? get type; String? get coingeckoId;/// Comma-separated TradingView symbols. Carried through untouched; nothing
/// reads it yet.
 String? get tradingSymbol;
/// Create a copy of TokenConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenConfigDtoCopyWith<TokenConfigDto> get copyWith => _$TokenConfigDtoCopyWithImpl<TokenConfigDto>(this as TokenConfigDto, _$identity);

  /// Serializes this TokenConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenConfigDto&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.address, address) || other.address == address)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.status, status) || other.status == status)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.coingeckoId, coingeckoId) || other.coingeckoId == coingeckoId)&&(identical(other.tradingSymbol, tradingSymbol) || other.tradingSymbol == tradingSymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,symbol,address,decimals,status,icon,type,coingeckoId,tradingSymbol);

@override
String toString() {
  return 'TokenConfigDto(name: $name, symbol: $symbol, address: $address, decimals: $decimals, status: $status, icon: $icon, type: $type, coingeckoId: $coingeckoId, tradingSymbol: $tradingSymbol)';
}


}

/// @nodoc
abstract mixin class $TokenConfigDtoCopyWith<$Res>  {
  factory $TokenConfigDtoCopyWith(TokenConfigDto value, $Res Function(TokenConfigDto) _then) = _$TokenConfigDtoCopyWithImpl;
@useResult
$Res call({
 String name, String symbol, String address, int decimals, String status, String? icon, String? type, String? coingeckoId, String? tradingSymbol
});




}
/// @nodoc
class _$TokenConfigDtoCopyWithImpl<$Res>
    implements $TokenConfigDtoCopyWith<$Res> {
  _$TokenConfigDtoCopyWithImpl(this._self, this._then);

  final TokenConfigDto _self;
  final $Res Function(TokenConfigDto) _then;

/// Create a copy of TokenConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? symbol = null,Object? address = null,Object? decimals = null,Object? status = null,Object? icon = freezed,Object? type = freezed,Object? coingeckoId = freezed,Object? tradingSymbol = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coingeckoId: freezed == coingeckoId ? _self.coingeckoId : coingeckoId // ignore: cast_nullable_to_non_nullable
as String?,tradingSymbol: freezed == tradingSymbol ? _self.tradingSymbol : tradingSymbol // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenConfigDto].
extension TokenConfigDtoPatterns on TokenConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _TokenConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _TokenConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String symbol,  String address,  int decimals,  String status,  String? icon,  String? type,  String? coingeckoId,  String? tradingSymbol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenConfigDto() when $default != null:
return $default(_that.name,_that.symbol,_that.address,_that.decimals,_that.status,_that.icon,_that.type,_that.coingeckoId,_that.tradingSymbol);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String symbol,  String address,  int decimals,  String status,  String? icon,  String? type,  String? coingeckoId,  String? tradingSymbol)  $default,) {final _that = this;
switch (_that) {
case _TokenConfigDto():
return $default(_that.name,_that.symbol,_that.address,_that.decimals,_that.status,_that.icon,_that.type,_that.coingeckoId,_that.tradingSymbol);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String symbol,  String address,  int decimals,  String status,  String? icon,  String? type,  String? coingeckoId,  String? tradingSymbol)?  $default,) {final _that = this;
switch (_that) {
case _TokenConfigDto() when $default != null:
return $default(_that.name,_that.symbol,_that.address,_that.decimals,_that.status,_that.icon,_that.type,_that.coingeckoId,_that.tradingSymbol);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenConfigDto implements TokenConfigDto {
  const _TokenConfigDto({required this.name, required this.symbol, required this.address, required this.decimals, required this.status, this.icon, this.type, this.coingeckoId, this.tradingSymbol});
  factory _TokenConfigDto.fromJson(Map<String, dynamic> json) => _$TokenConfigDtoFromJson(json);

@override final  String name;
@override final  String symbol;
@override final  String address;
@override final  int decimals;
@override final  String status;
@override final  String? icon;
@override final  String? type;
@override final  String? coingeckoId;
/// Comma-separated TradingView symbols. Carried through untouched; nothing
/// reads it yet.
@override final  String? tradingSymbol;

/// Create a copy of TokenConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenConfigDtoCopyWith<_TokenConfigDto> get copyWith => __$TokenConfigDtoCopyWithImpl<_TokenConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenConfigDto&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.address, address) || other.address == address)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.status, status) || other.status == status)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.coingeckoId, coingeckoId) || other.coingeckoId == coingeckoId)&&(identical(other.tradingSymbol, tradingSymbol) || other.tradingSymbol == tradingSymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,symbol,address,decimals,status,icon,type,coingeckoId,tradingSymbol);

@override
String toString() {
  return 'TokenConfigDto(name: $name, symbol: $symbol, address: $address, decimals: $decimals, status: $status, icon: $icon, type: $type, coingeckoId: $coingeckoId, tradingSymbol: $tradingSymbol)';
}


}

/// @nodoc
abstract mixin class _$TokenConfigDtoCopyWith<$Res> implements $TokenConfigDtoCopyWith<$Res> {
  factory _$TokenConfigDtoCopyWith(_TokenConfigDto value, $Res Function(_TokenConfigDto) _then) = __$TokenConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String symbol, String address, int decimals, String status, String? icon, String? type, String? coingeckoId, String? tradingSymbol
});




}
/// @nodoc
class __$TokenConfigDtoCopyWithImpl<$Res>
    implements _$TokenConfigDtoCopyWith<$Res> {
  __$TokenConfigDtoCopyWithImpl(this._self, this._then);

  final _TokenConfigDto _self;
  final $Res Function(_TokenConfigDto) _then;

/// Create a copy of TokenConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? symbol = null,Object? address = null,Object? decimals = null,Object? status = null,Object? icon = freezed,Object? type = freezed,Object? coingeckoId = freezed,Object? tradingSymbol = freezed,}) {
  return _then(_TokenConfigDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,coingeckoId: freezed == coingeckoId ? _self.coingeckoId : coingeckoId // ignore: cast_nullable_to_non_nullable
as String?,tradingSymbol: freezed == tradingSymbol ? _self.tradingSymbol : tradingSymbol // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
