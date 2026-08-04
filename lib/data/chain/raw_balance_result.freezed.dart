// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_balance_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RawBalanceResult {

 Map<AssetRef, BigInt> get balances; DateTime get fetchedAt; List<ChainFailure> get failures;
/// Create a copy of RawBalanceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawBalanceResultCopyWith<RawBalanceResult> get copyWith => _$RawBalanceResultCopyWithImpl<RawBalanceResult>(this as RawBalanceResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawBalanceResult&&const DeepCollectionEquality().equals(other.balances, balances)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&const DeepCollectionEquality().equals(other.failures, failures));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(balances),fetchedAt,const DeepCollectionEquality().hash(failures));

@override
String toString() {
  return 'RawBalanceResult(balances: $balances, fetchedAt: $fetchedAt, failures: $failures)';
}


}

/// @nodoc
abstract mixin class $RawBalanceResultCopyWith<$Res>  {
  factory $RawBalanceResultCopyWith(RawBalanceResult value, $Res Function(RawBalanceResult) _then) = _$RawBalanceResultCopyWithImpl;
@useResult
$Res call({
 Map<AssetRef, BigInt> balances, DateTime fetchedAt, List<ChainFailure> failures
});




}
/// @nodoc
class _$RawBalanceResultCopyWithImpl<$Res>
    implements $RawBalanceResultCopyWith<$Res> {
  _$RawBalanceResultCopyWithImpl(this._self, this._then);

  final RawBalanceResult _self;
  final $Res Function(RawBalanceResult) _then;

/// Create a copy of RawBalanceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balances = null,Object? fetchedAt = null,Object? failures = null,}) {
  return _then(_self.copyWith(
balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as Map<AssetRef, BigInt>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as List<ChainFailure>,
  ));
}

}


/// Adds pattern-matching-related methods to [RawBalanceResult].
extension RawBalanceResultPatterns on RawBalanceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawBalanceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawBalanceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawBalanceResult value)  $default,){
final _that = this;
switch (_that) {
case _RawBalanceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawBalanceResult value)?  $default,){
final _that = this;
switch (_that) {
case _RawBalanceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<AssetRef, BigInt> balances,  DateTime fetchedAt,  List<ChainFailure> failures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawBalanceResult() when $default != null:
return $default(_that.balances,_that.fetchedAt,_that.failures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<AssetRef, BigInt> balances,  DateTime fetchedAt,  List<ChainFailure> failures)  $default,) {final _that = this;
switch (_that) {
case _RawBalanceResult():
return $default(_that.balances,_that.fetchedAt,_that.failures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<AssetRef, BigInt> balances,  DateTime fetchedAt,  List<ChainFailure> failures)?  $default,) {final _that = this;
switch (_that) {
case _RawBalanceResult() when $default != null:
return $default(_that.balances,_that.fetchedAt,_that.failures);case _:
  return null;

}
}

}

/// @nodoc


class _RawBalanceResult extends RawBalanceResult {
  const _RawBalanceResult({required final  Map<AssetRef, BigInt> balances, required this.fetchedAt, final  List<ChainFailure> failures = const <ChainFailure>[]}): _balances = balances,_failures = failures,super._();
  

 final  Map<AssetRef, BigInt> _balances;
@override Map<AssetRef, BigInt> get balances {
  if (_balances is EqualUnmodifiableMapView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_balances);
}

@override final  DateTime fetchedAt;
 final  List<ChainFailure> _failures;
@override@JsonKey() List<ChainFailure> get failures {
  if (_failures is EqualUnmodifiableListView) return _failures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failures);
}


/// Create a copy of RawBalanceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawBalanceResultCopyWith<_RawBalanceResult> get copyWith => __$RawBalanceResultCopyWithImpl<_RawBalanceResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawBalanceResult&&const DeepCollectionEquality().equals(other._balances, _balances)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&const DeepCollectionEquality().equals(other._failures, _failures));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_balances),fetchedAt,const DeepCollectionEquality().hash(_failures));

@override
String toString() {
  return 'RawBalanceResult(balances: $balances, fetchedAt: $fetchedAt, failures: $failures)';
}


}

/// @nodoc
abstract mixin class _$RawBalanceResultCopyWith<$Res> implements $RawBalanceResultCopyWith<$Res> {
  factory _$RawBalanceResultCopyWith(_RawBalanceResult value, $Res Function(_RawBalanceResult) _then) = __$RawBalanceResultCopyWithImpl;
@override @useResult
$Res call({
 Map<AssetRef, BigInt> balances, DateTime fetchedAt, List<ChainFailure> failures
});




}
/// @nodoc
class __$RawBalanceResultCopyWithImpl<$Res>
    implements _$RawBalanceResultCopyWith<$Res> {
  __$RawBalanceResultCopyWithImpl(this._self, this._then);

  final _RawBalanceResult _self;
  final $Res Function(_RawBalanceResult) _then;

/// Create a copy of RawBalanceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balances = null,Object? fetchedAt = null,Object? failures = null,}) {
  return _then(_RawBalanceResult(
balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as Map<AssetRef, BigInt>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,failures: null == failures ? _self._failures : failures // ignore: cast_nullable_to_non_nullable
as List<ChainFailure>,
  ));
}


}

// dart format on
