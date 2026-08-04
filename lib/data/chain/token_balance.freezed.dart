// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TokenBalance {

 TokenInfo get token; TokenAmount get amount;/// Null means "no price available", never "worth zero". A null here keeps
/// the holding out of the total and increments
/// `PortfolioSnapshot.unpricedCount`, so the UI can say the total is a lower
/// bound instead of quietly understating it.
 FiatValue? get fiat;
/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenBalanceCopyWith<TokenBalance> get copyWith => _$TokenBalanceCopyWithImpl<TokenBalance>(this as TokenBalance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenBalance&&(identical(other.token, token) || other.token == token)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fiat, fiat) || other.fiat == fiat));
}


@override
int get hashCode => Object.hash(runtimeType,token,amount,fiat);

@override
String toString() {
  return 'TokenBalance(token: $token, amount: $amount, fiat: $fiat)';
}


}

/// @nodoc
abstract mixin class $TokenBalanceCopyWith<$Res>  {
  factory $TokenBalanceCopyWith(TokenBalance value, $Res Function(TokenBalance) _then) = _$TokenBalanceCopyWithImpl;
@useResult
$Res call({
 TokenInfo token, TokenAmount amount, FiatValue? fiat
});


$TokenInfoCopyWith<$Res> get token;$TokenAmountCopyWith<$Res> get amount;$FiatValueCopyWith<$Res>? get fiat;

}
/// @nodoc
class _$TokenBalanceCopyWithImpl<$Res>
    implements $TokenBalanceCopyWith<$Res> {
  _$TokenBalanceCopyWithImpl(this._self, this._then);

  final TokenBalance _self;
  final $Res Function(TokenBalance) _then;

/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? amount = null,Object? fiat = freezed,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TokenInfo,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as TokenAmount,fiat: freezed == fiat ? _self.fiat : fiat // ignore: cast_nullable_to_non_nullable
as FiatValue?,
  ));
}
/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get token {
  
  return $TokenInfoCopyWith<$Res>(_self.token, (value) {
    return _then(_self.copyWith(token: value));
  });
}/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenAmountCopyWith<$Res> get amount {
  
  return $TokenAmountCopyWith<$Res>(_self.amount, (value) {
    return _then(_self.copyWith(amount: value));
  });
}/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FiatValueCopyWith<$Res>? get fiat {
    if (_self.fiat == null) {
    return null;
  }

  return $FiatValueCopyWith<$Res>(_self.fiat!, (value) {
    return _then(_self.copyWith(fiat: value));
  });
}
}


/// Adds pattern-matching-related methods to [TokenBalance].
extension TokenBalancePatterns on TokenBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenBalance value)  $default,){
final _that = this;
switch (_that) {
case _TokenBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenBalance value)?  $default,){
final _that = this;
switch (_that) {
case _TokenBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TokenInfo token,  TokenAmount amount,  FiatValue? fiat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenBalance() when $default != null:
return $default(_that.token,_that.amount,_that.fiat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TokenInfo token,  TokenAmount amount,  FiatValue? fiat)  $default,) {final _that = this;
switch (_that) {
case _TokenBalance():
return $default(_that.token,_that.amount,_that.fiat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TokenInfo token,  TokenAmount amount,  FiatValue? fiat)?  $default,) {final _that = this;
switch (_that) {
case _TokenBalance() when $default != null:
return $default(_that.token,_that.amount,_that.fiat);case _:
  return null;

}
}

}

/// @nodoc


class _TokenBalance extends TokenBalance {
  const _TokenBalance({required this.token, required this.amount, this.fiat}): super._();
  

@override final  TokenInfo token;
@override final  TokenAmount amount;
/// Null means "no price available", never "worth zero". A null here keeps
/// the holding out of the total and increments
/// `PortfolioSnapshot.unpricedCount`, so the UI can say the total is a lower
/// bound instead of quietly understating it.
@override final  FiatValue? fiat;

/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenBalanceCopyWith<_TokenBalance> get copyWith => __$TokenBalanceCopyWithImpl<_TokenBalance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenBalance&&(identical(other.token, token) || other.token == token)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fiat, fiat) || other.fiat == fiat));
}


@override
int get hashCode => Object.hash(runtimeType,token,amount,fiat);

@override
String toString() {
  return 'TokenBalance(token: $token, amount: $amount, fiat: $fiat)';
}


}

/// @nodoc
abstract mixin class _$TokenBalanceCopyWith<$Res> implements $TokenBalanceCopyWith<$Res> {
  factory _$TokenBalanceCopyWith(_TokenBalance value, $Res Function(_TokenBalance) _then) = __$TokenBalanceCopyWithImpl;
@override @useResult
$Res call({
 TokenInfo token, TokenAmount amount, FiatValue? fiat
});


@override $TokenInfoCopyWith<$Res> get token;@override $TokenAmountCopyWith<$Res> get amount;@override $FiatValueCopyWith<$Res>? get fiat;

}
/// @nodoc
class __$TokenBalanceCopyWithImpl<$Res>
    implements _$TokenBalanceCopyWith<$Res> {
  __$TokenBalanceCopyWithImpl(this._self, this._then);

  final _TokenBalance _self;
  final $Res Function(_TokenBalance) _then;

/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? amount = null,Object? fiat = freezed,}) {
  return _then(_TokenBalance(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TokenInfo,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as TokenAmount,fiat: freezed == fiat ? _self.fiat : fiat // ignore: cast_nullable_to_non_nullable
as FiatValue?,
  ));
}

/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get token {
  
  return $TokenInfoCopyWith<$Res>(_self.token, (value) {
    return _then(_self.copyWith(token: value));
  });
}/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenAmountCopyWith<$Res> get amount {
  
  return $TokenAmountCopyWith<$Res>(_self.amount, (value) {
    return _then(_self.copyWith(amount: value));
  });
}/// Create a copy of TokenBalance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FiatValueCopyWith<$Res>? get fiat {
    if (_self.fiat == null) {
    return null;
  }

  return $FiatValueCopyWith<$Res>(_self.fiat!, (value) {
    return _then(_self.copyWith(fiat: value));
  });
}
}

/// @nodoc
mixin _$UnresolvedAsset {

 AssetRef get ref; BigInt get rawBalance; String? get symbol;
/// Create a copy of UnresolvedAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnresolvedAssetCopyWith<UnresolvedAsset> get copyWith => _$UnresolvedAssetCopyWithImpl<UnresolvedAsset>(this as UnresolvedAsset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnresolvedAsset&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.rawBalance, rawBalance) || other.rawBalance == rawBalance)&&(identical(other.symbol, symbol) || other.symbol == symbol));
}


@override
int get hashCode => Object.hash(runtimeType,ref,rawBalance,symbol);

@override
String toString() {
  return 'UnresolvedAsset(ref: $ref, rawBalance: $rawBalance, symbol: $symbol)';
}


}

/// @nodoc
abstract mixin class $UnresolvedAssetCopyWith<$Res>  {
  factory $UnresolvedAssetCopyWith(UnresolvedAsset value, $Res Function(UnresolvedAsset) _then) = _$UnresolvedAssetCopyWithImpl;
@useResult
$Res call({
 AssetRef ref, BigInt rawBalance, String? symbol
});




}
/// @nodoc
class _$UnresolvedAssetCopyWithImpl<$Res>
    implements $UnresolvedAssetCopyWith<$Res> {
  _$UnresolvedAssetCopyWithImpl(this._self, this._then);

  final UnresolvedAsset _self;
  final $Res Function(UnresolvedAsset) _then;

/// Create a copy of UnresolvedAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? rawBalance = null,Object? symbol = freezed,}) {
  return _then(_self.copyWith(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as AssetRef,rawBalance: null == rawBalance ? _self.rawBalance : rawBalance // ignore: cast_nullable_to_non_nullable
as BigInt,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnresolvedAsset].
extension UnresolvedAssetPatterns on UnresolvedAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnresolvedAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnresolvedAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnresolvedAsset value)  $default,){
final _that = this;
switch (_that) {
case _UnresolvedAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnresolvedAsset value)?  $default,){
final _that = this;
switch (_that) {
case _UnresolvedAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssetRef ref,  BigInt rawBalance,  String? symbol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnresolvedAsset() when $default != null:
return $default(_that.ref,_that.rawBalance,_that.symbol);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssetRef ref,  BigInt rawBalance,  String? symbol)  $default,) {final _that = this;
switch (_that) {
case _UnresolvedAsset():
return $default(_that.ref,_that.rawBalance,_that.symbol);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssetRef ref,  BigInt rawBalance,  String? symbol)?  $default,) {final _that = this;
switch (_that) {
case _UnresolvedAsset() when $default != null:
return $default(_that.ref,_that.rawBalance,_that.symbol);case _:
  return null;

}
}

}

/// @nodoc


class _UnresolvedAsset implements UnresolvedAsset {
  const _UnresolvedAsset({required this.ref, required this.rawBalance, this.symbol});
  

@override final  AssetRef ref;
@override final  BigInt rawBalance;
@override final  String? symbol;

/// Create a copy of UnresolvedAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnresolvedAssetCopyWith<_UnresolvedAsset> get copyWith => __$UnresolvedAssetCopyWithImpl<_UnresolvedAsset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnresolvedAsset&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.rawBalance, rawBalance) || other.rawBalance == rawBalance)&&(identical(other.symbol, symbol) || other.symbol == symbol));
}


@override
int get hashCode => Object.hash(runtimeType,ref,rawBalance,symbol);

@override
String toString() {
  return 'UnresolvedAsset(ref: $ref, rawBalance: $rawBalance, symbol: $symbol)';
}


}

/// @nodoc
abstract mixin class _$UnresolvedAssetCopyWith<$Res> implements $UnresolvedAssetCopyWith<$Res> {
  factory _$UnresolvedAssetCopyWith(_UnresolvedAsset value, $Res Function(_UnresolvedAsset) _then) = __$UnresolvedAssetCopyWithImpl;
@override @useResult
$Res call({
 AssetRef ref, BigInt rawBalance, String? symbol
});




}
/// @nodoc
class __$UnresolvedAssetCopyWithImpl<$Res>
    implements _$UnresolvedAssetCopyWith<$Res> {
  __$UnresolvedAssetCopyWithImpl(this._self, this._then);

  final _UnresolvedAsset _self;
  final $Res Function(_UnresolvedAsset) _then;

/// Create a copy of UnresolvedAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? rawBalance = null,Object? symbol = freezed,}) {
  return _then(_UnresolvedAsset(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as AssetRef,rawBalance: null == rawBalance ? _self.rawBalance : rawBalance // ignore: cast_nullable_to_non_nullable
as BigInt,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
