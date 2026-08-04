// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fiat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FiatPrice {

/// ISO 4217, upper case. Only `USD` is produced today.
 String get currency; Decimal get value; DateTime get asOf;/// Fraction, not percent: `0.0512` is +5.12%.
 Decimal? get change24h;
/// Create a copy of FiatPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiatPriceCopyWith<FiatPrice> get copyWith => _$FiatPriceCopyWithImpl<FiatPrice>(this as FiatPrice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FiatPrice&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.value, value) || other.value == value)&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.change24h, change24h) || other.change24h == change24h));
}


@override
int get hashCode => Object.hash(runtimeType,currency,value,asOf,change24h);

@override
String toString() {
  return 'FiatPrice(currency: $currency, value: $value, asOf: $asOf, change24h: $change24h)';
}


}

/// @nodoc
abstract mixin class $FiatPriceCopyWith<$Res>  {
  factory $FiatPriceCopyWith(FiatPrice value, $Res Function(FiatPrice) _then) = _$FiatPriceCopyWithImpl;
@useResult
$Res call({
 String currency, Decimal value, DateTime asOf, Decimal? change24h
});




}
/// @nodoc
class _$FiatPriceCopyWithImpl<$Res>
    implements $FiatPriceCopyWith<$Res> {
  _$FiatPriceCopyWithImpl(this._self, this._then);

  final FiatPrice _self;
  final $Res Function(FiatPrice) _then;

/// Create a copy of FiatPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? value = null,Object? asOf = null,Object? change24h = freezed,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,change24h: freezed == change24h ? _self.change24h : change24h // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}

}


/// Adds pattern-matching-related methods to [FiatPrice].
extension FiatPricePatterns on FiatPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FiatPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FiatPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FiatPrice value)  $default,){
final _that = this;
switch (_that) {
case _FiatPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FiatPrice value)?  $default,){
final _that = this;
switch (_that) {
case _FiatPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  Decimal value,  DateTime asOf,  Decimal? change24h)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FiatPrice() when $default != null:
return $default(_that.currency,_that.value,_that.asOf,_that.change24h);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  Decimal value,  DateTime asOf,  Decimal? change24h)  $default,) {final _that = this;
switch (_that) {
case _FiatPrice():
return $default(_that.currency,_that.value,_that.asOf,_that.change24h);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  Decimal value,  DateTime asOf,  Decimal? change24h)?  $default,) {final _that = this;
switch (_that) {
case _FiatPrice() when $default != null:
return $default(_that.currency,_that.value,_that.asOf,_that.change24h);case _:
  return null;

}
}

}

/// @nodoc


class _FiatPrice implements FiatPrice {
  const _FiatPrice({required this.currency, required this.value, required this.asOf, this.change24h});
  

/// ISO 4217, upper case. Only `USD` is produced today.
@override final  String currency;
@override final  Decimal value;
@override final  DateTime asOf;
/// Fraction, not percent: `0.0512` is +5.12%.
@override final  Decimal? change24h;

/// Create a copy of FiatPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiatPriceCopyWith<_FiatPrice> get copyWith => __$FiatPriceCopyWithImpl<_FiatPrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiatPrice&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.value, value) || other.value == value)&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.change24h, change24h) || other.change24h == change24h));
}


@override
int get hashCode => Object.hash(runtimeType,currency,value,asOf,change24h);

@override
String toString() {
  return 'FiatPrice(currency: $currency, value: $value, asOf: $asOf, change24h: $change24h)';
}


}

/// @nodoc
abstract mixin class _$FiatPriceCopyWith<$Res> implements $FiatPriceCopyWith<$Res> {
  factory _$FiatPriceCopyWith(_FiatPrice value, $Res Function(_FiatPrice) _then) = __$FiatPriceCopyWithImpl;
@override @useResult
$Res call({
 String currency, Decimal value, DateTime asOf, Decimal? change24h
});




}
/// @nodoc
class __$FiatPriceCopyWithImpl<$Res>
    implements _$FiatPriceCopyWith<$Res> {
  __$FiatPriceCopyWithImpl(this._self, this._then);

  final _FiatPrice _self;
  final $Res Function(_FiatPrice) _then;

/// Create a copy of FiatPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? value = null,Object? asOf = null,Object? change24h = freezed,}) {
  return _then(_FiatPrice(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,change24h: freezed == change24h ? _self.change24h : change24h // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}


}

/// @nodoc
mixin _$FiatValue {

 String get currency; Decimal get value;
/// Create a copy of FiatValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FiatValueCopyWith<FiatValue> get copyWith => _$FiatValueCopyWithImpl<FiatValue>(this as FiatValue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FiatValue&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,currency,value);

@override
String toString() {
  return 'FiatValue(currency: $currency, value: $value)';
}


}

/// @nodoc
abstract mixin class $FiatValueCopyWith<$Res>  {
  factory $FiatValueCopyWith(FiatValue value, $Res Function(FiatValue) _then) = _$FiatValueCopyWithImpl;
@useResult
$Res call({
 String currency, Decimal value
});




}
/// @nodoc
class _$FiatValueCopyWithImpl<$Res>
    implements $FiatValueCopyWith<$Res> {
  _$FiatValueCopyWithImpl(this._self, this._then);

  final FiatValue _self;
  final $Res Function(FiatValue) _then;

/// Create a copy of FiatValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? value = null,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [FiatValue].
extension FiatValuePatterns on FiatValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FiatValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FiatValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FiatValue value)  $default,){
final _that = this;
switch (_that) {
case _FiatValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FiatValue value)?  $default,){
final _that = this;
switch (_that) {
case _FiatValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  Decimal value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FiatValue() when $default != null:
return $default(_that.currency,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  Decimal value)  $default,) {final _that = this;
switch (_that) {
case _FiatValue():
return $default(_that.currency,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  Decimal value)?  $default,) {final _that = this;
switch (_that) {
case _FiatValue() when $default != null:
return $default(_that.currency,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _FiatValue extends FiatValue {
  const _FiatValue({required this.currency, required this.value}): super._();
  

@override final  String currency;
@override final  Decimal value;

/// Create a copy of FiatValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FiatValueCopyWith<_FiatValue> get copyWith => __$FiatValueCopyWithImpl<_FiatValue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FiatValue&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,currency,value);

@override
String toString() {
  return 'FiatValue(currency: $currency, value: $value)';
}


}

/// @nodoc
abstract mixin class _$FiatValueCopyWith<$Res> implements $FiatValueCopyWith<$Res> {
  factory _$FiatValueCopyWith(_FiatValue value, $Res Function(_FiatValue) _then) = __$FiatValueCopyWithImpl;
@override @useResult
$Res call({
 String currency, Decimal value
});




}
/// @nodoc
class __$FiatValueCopyWithImpl<$Res>
    implements _$FiatValueCopyWith<$Res> {
  __$FiatValueCopyWithImpl(this._self, this._then);

  final _FiatValue _self;
  final $Res Function(_FiatValue) _then;

/// Create a copy of FiatValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? value = null,}) {
  return _then(_FiatValue(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

// dart format on
