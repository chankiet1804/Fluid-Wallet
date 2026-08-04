// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_amount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TokenAmount {

 BigInt get raw; int get decimals;
/// Create a copy of TokenAmount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenAmountCopyWith<TokenAmount> get copyWith => _$TokenAmountCopyWithImpl<TokenAmount>(this as TokenAmount, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenAmount&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.decimals, decimals) || other.decimals == decimals));
}


@override
int get hashCode => Object.hash(runtimeType,raw,decimals);

@override
String toString() {
  return 'TokenAmount(raw: $raw, decimals: $decimals)';
}


}

/// @nodoc
abstract mixin class $TokenAmountCopyWith<$Res>  {
  factory $TokenAmountCopyWith(TokenAmount value, $Res Function(TokenAmount) _then) = _$TokenAmountCopyWithImpl;
@useResult
$Res call({
 BigInt raw, int decimals
});




}
/// @nodoc
class _$TokenAmountCopyWithImpl<$Res>
    implements $TokenAmountCopyWith<$Res> {
  _$TokenAmountCopyWithImpl(this._self, this._then);

  final TokenAmount _self;
  final $Res Function(TokenAmount) _then;

/// Create a copy of TokenAmount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? raw = null,Object? decimals = null,}) {
  return _then(_self.copyWith(
raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as BigInt,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenAmount].
extension TokenAmountPatterns on TokenAmount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenAmount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenAmount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenAmount value)  $default,){
final _that = this;
switch (_that) {
case _TokenAmount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenAmount value)?  $default,){
final _that = this;
switch (_that) {
case _TokenAmount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BigInt raw,  int decimals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenAmount() when $default != null:
return $default(_that.raw,_that.decimals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BigInt raw,  int decimals)  $default,) {final _that = this;
switch (_that) {
case _TokenAmount():
return $default(_that.raw,_that.decimals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BigInt raw,  int decimals)?  $default,) {final _that = this;
switch (_that) {
case _TokenAmount() when $default != null:
return $default(_that.raw,_that.decimals);case _:
  return null;

}
}

}

/// @nodoc


class _TokenAmount extends TokenAmount {
  const _TokenAmount({required this.raw, required this.decimals}): super._();
  

@override final  BigInt raw;
@override final  int decimals;

/// Create a copy of TokenAmount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenAmountCopyWith<_TokenAmount> get copyWith => __$TokenAmountCopyWithImpl<_TokenAmount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenAmount&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.decimals, decimals) || other.decimals == decimals));
}


@override
int get hashCode => Object.hash(runtimeType,raw,decimals);

@override
String toString() {
  return 'TokenAmount(raw: $raw, decimals: $decimals)';
}


}

/// @nodoc
abstract mixin class _$TokenAmountCopyWith<$Res> implements $TokenAmountCopyWith<$Res> {
  factory _$TokenAmountCopyWith(_TokenAmount value, $Res Function(_TokenAmount) _then) = __$TokenAmountCopyWithImpl;
@override @useResult
$Res call({
 BigInt raw, int decimals
});




}
/// @nodoc
class __$TokenAmountCopyWithImpl<$Res>
    implements _$TokenAmountCopyWith<$Res> {
  __$TokenAmountCopyWithImpl(this._self, this._then);

  final _TokenAmount _self;
  final $Res Function(_TokenAmount) _then;

/// Create a copy of TokenAmount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? raw = null,Object? decimals = null,}) {
  return _then(_TokenAmount(
raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as BigInt,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
