// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChainFailure {

 int get chainId; ChainFailureKind get kind; String? get message;
/// Create a copy of ChainFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChainFailureCopyWith<ChainFailure> get copyWith => _$ChainFailureCopyWithImpl<ChainFailure>(this as ChainFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChainFailure&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,chainId,kind,message);

@override
String toString() {
  return 'ChainFailure(chainId: $chainId, kind: $kind, message: $message)';
}


}

/// @nodoc
abstract mixin class $ChainFailureCopyWith<$Res>  {
  factory $ChainFailureCopyWith(ChainFailure value, $Res Function(ChainFailure) _then) = _$ChainFailureCopyWithImpl;
@useResult
$Res call({
 int chainId, ChainFailureKind kind, String? message
});




}
/// @nodoc
class _$ChainFailureCopyWithImpl<$Res>
    implements $ChainFailureCopyWith<$Res> {
  _$ChainFailureCopyWithImpl(this._self, this._then);

  final ChainFailure _self;
  final $Res Function(ChainFailure) _then;

/// Create a copy of ChainFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chainId = null,Object? kind = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChainFailureKind,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChainFailure].
extension ChainFailurePatterns on ChainFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChainFailure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChainFailure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChainFailure value)  $default,){
final _that = this;
switch (_that) {
case _ChainFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChainFailure value)?  $default,){
final _that = this;
switch (_that) {
case _ChainFailure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chainId,  ChainFailureKind kind,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChainFailure() when $default != null:
return $default(_that.chainId,_that.kind,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chainId,  ChainFailureKind kind,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ChainFailure():
return $default(_that.chainId,_that.kind,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chainId,  ChainFailureKind kind,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ChainFailure() when $default != null:
return $default(_that.chainId,_that.kind,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ChainFailure implements ChainFailure {
  const _ChainFailure({required this.chainId, required this.kind, this.message});
  

@override final  int chainId;
@override final  ChainFailureKind kind;
@override final  String? message;

/// Create a copy of ChainFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChainFailureCopyWith<_ChainFailure> get copyWith => __$ChainFailureCopyWithImpl<_ChainFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChainFailure&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,chainId,kind,message);

@override
String toString() {
  return 'ChainFailure(chainId: $chainId, kind: $kind, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChainFailureCopyWith<$Res> implements $ChainFailureCopyWith<$Res> {
  factory _$ChainFailureCopyWith(_ChainFailure value, $Res Function(_ChainFailure) _then) = __$ChainFailureCopyWithImpl;
@override @useResult
$Res call({
 int chainId, ChainFailureKind kind, String? message
});




}
/// @nodoc
class __$ChainFailureCopyWithImpl<$Res>
    implements _$ChainFailureCopyWith<$Res> {
  __$ChainFailureCopyWithImpl(this._self, this._then);

  final _ChainFailure _self;
  final $Res Function(_ChainFailure) _then;

/// Create a copy of ChainFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainId = null,Object? kind = null,Object? message = freezed,}) {
  return _then(_ChainFailure(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChainFailureKind,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PortfolioSnapshot {

 String get address; List<TokenBalance> get balances; String get currency; DateTime get fetchedAt; List<UnresolvedAsset> get unresolved; List<ChainFailure> get failures;/// Balances that priced to null and are therefore absent from [total].
 int get unpricedCount;
/// Create a copy of PortfolioSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioSnapshotCopyWith<PortfolioSnapshot> get copyWith => _$PortfolioSnapshotCopyWithImpl<PortfolioSnapshot>(this as PortfolioSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioSnapshot&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.balances, balances)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&const DeepCollectionEquality().equals(other.unresolved, unresolved)&&const DeepCollectionEquality().equals(other.failures, failures)&&(identical(other.unpricedCount, unpricedCount) || other.unpricedCount == unpricedCount));
}


@override
int get hashCode => Object.hash(runtimeType,address,const DeepCollectionEquality().hash(balances),currency,fetchedAt,const DeepCollectionEquality().hash(unresolved),const DeepCollectionEquality().hash(failures),unpricedCount);

@override
String toString() {
  return 'PortfolioSnapshot(address: $address, balances: $balances, currency: $currency, fetchedAt: $fetchedAt, unresolved: $unresolved, failures: $failures, unpricedCount: $unpricedCount)';
}


}

/// @nodoc
abstract mixin class $PortfolioSnapshotCopyWith<$Res>  {
  factory $PortfolioSnapshotCopyWith(PortfolioSnapshot value, $Res Function(PortfolioSnapshot) _then) = _$PortfolioSnapshotCopyWithImpl;
@useResult
$Res call({
 String address, List<TokenBalance> balances, String currency, DateTime fetchedAt, List<UnresolvedAsset> unresolved, List<ChainFailure> failures, int unpricedCount
});




}
/// @nodoc
class _$PortfolioSnapshotCopyWithImpl<$Res>
    implements $PortfolioSnapshotCopyWith<$Res> {
  _$PortfolioSnapshotCopyWithImpl(this._self, this._then);

  final PortfolioSnapshot _self;
  final $Res Function(PortfolioSnapshot) _then;

/// Create a copy of PortfolioSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? balances = null,Object? currency = null,Object? fetchedAt = null,Object? unresolved = null,Object? failures = null,Object? unpricedCount = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as List<TokenBalance>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,unresolved: null == unresolved ? _self.unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as List<UnresolvedAsset>,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as List<ChainFailure>,unpricedCount: null == unpricedCount ? _self.unpricedCount : unpricedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioSnapshot].
extension PortfolioSnapshotPatterns on PortfolioSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  List<TokenBalance> balances,  String currency,  DateTime fetchedAt,  List<UnresolvedAsset> unresolved,  List<ChainFailure> failures,  int unpricedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioSnapshot() when $default != null:
return $default(_that.address,_that.balances,_that.currency,_that.fetchedAt,_that.unresolved,_that.failures,_that.unpricedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  List<TokenBalance> balances,  String currency,  DateTime fetchedAt,  List<UnresolvedAsset> unresolved,  List<ChainFailure> failures,  int unpricedCount)  $default,) {final _that = this;
switch (_that) {
case _PortfolioSnapshot():
return $default(_that.address,_that.balances,_that.currency,_that.fetchedAt,_that.unresolved,_that.failures,_that.unpricedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  List<TokenBalance> balances,  String currency,  DateTime fetchedAt,  List<UnresolvedAsset> unresolved,  List<ChainFailure> failures,  int unpricedCount)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioSnapshot() when $default != null:
return $default(_that.address,_that.balances,_that.currency,_that.fetchedAt,_that.unresolved,_that.failures,_that.unpricedCount);case _:
  return null;

}
}

}

/// @nodoc


class _PortfolioSnapshot extends PortfolioSnapshot {
  const _PortfolioSnapshot({required this.address, required final  List<TokenBalance> balances, required this.currency, required this.fetchedAt, final  List<UnresolvedAsset> unresolved = const <UnresolvedAsset>[], final  List<ChainFailure> failures = const <ChainFailure>[], this.unpricedCount = 0}): _balances = balances,_unresolved = unresolved,_failures = failures,super._();
  

@override final  String address;
 final  List<TokenBalance> _balances;
@override List<TokenBalance> get balances {
  if (_balances is EqualUnmodifiableListView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_balances);
}

@override final  String currency;
@override final  DateTime fetchedAt;
 final  List<UnresolvedAsset> _unresolved;
@override@JsonKey() List<UnresolvedAsset> get unresolved {
  if (_unresolved is EqualUnmodifiableListView) return _unresolved;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unresolved);
}

 final  List<ChainFailure> _failures;
@override@JsonKey() List<ChainFailure> get failures {
  if (_failures is EqualUnmodifiableListView) return _failures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failures);
}

/// Balances that priced to null and are therefore absent from [total].
@override@JsonKey() final  int unpricedCount;

/// Create a copy of PortfolioSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioSnapshotCopyWith<_PortfolioSnapshot> get copyWith => __$PortfolioSnapshotCopyWithImpl<_PortfolioSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioSnapshot&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._balances, _balances)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&const DeepCollectionEquality().equals(other._unresolved, _unresolved)&&const DeepCollectionEquality().equals(other._failures, _failures)&&(identical(other.unpricedCount, unpricedCount) || other.unpricedCount == unpricedCount));
}


@override
int get hashCode => Object.hash(runtimeType,address,const DeepCollectionEquality().hash(_balances),currency,fetchedAt,const DeepCollectionEquality().hash(_unresolved),const DeepCollectionEquality().hash(_failures),unpricedCount);

@override
String toString() {
  return 'PortfolioSnapshot(address: $address, balances: $balances, currency: $currency, fetchedAt: $fetchedAt, unresolved: $unresolved, failures: $failures, unpricedCount: $unpricedCount)';
}


}

/// @nodoc
abstract mixin class _$PortfolioSnapshotCopyWith<$Res> implements $PortfolioSnapshotCopyWith<$Res> {
  factory _$PortfolioSnapshotCopyWith(_PortfolioSnapshot value, $Res Function(_PortfolioSnapshot) _then) = __$PortfolioSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String address, List<TokenBalance> balances, String currency, DateTime fetchedAt, List<UnresolvedAsset> unresolved, List<ChainFailure> failures, int unpricedCount
});




}
/// @nodoc
class __$PortfolioSnapshotCopyWithImpl<$Res>
    implements _$PortfolioSnapshotCopyWith<$Res> {
  __$PortfolioSnapshotCopyWithImpl(this._self, this._then);

  final _PortfolioSnapshot _self;
  final $Res Function(_PortfolioSnapshot) _then;

/// Create a copy of PortfolioSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? balances = null,Object? currency = null,Object? fetchedAt = null,Object? unresolved = null,Object? failures = null,Object? unpricedCount = null,}) {
  return _then(_PortfolioSnapshot(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as List<TokenBalance>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,unresolved: null == unresolved ? _self._unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as List<UnresolvedAsset>,failures: null == failures ? _self._failures : failures // ignore: cast_nullable_to_non_nullable
as List<ChainFailure>,unpricedCount: null == unpricedCount ? _self.unpricedCount : unpricedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
