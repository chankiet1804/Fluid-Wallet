// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolved_tokens.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolvedTokens {

 List<TokenBalance> get balances; List<UnresolvedAsset> get unresolved;
/// Create a copy of ResolvedTokens
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolvedTokensCopyWith<ResolvedTokens> get copyWith => _$ResolvedTokensCopyWithImpl<ResolvedTokens>(this as ResolvedTokens, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolvedTokens&&const DeepCollectionEquality().equals(other.balances, balances)&&const DeepCollectionEquality().equals(other.unresolved, unresolved));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(balances),const DeepCollectionEquality().hash(unresolved));

@override
String toString() {
  return 'ResolvedTokens(balances: $balances, unresolved: $unresolved)';
}


}

/// @nodoc
abstract mixin class $ResolvedTokensCopyWith<$Res>  {
  factory $ResolvedTokensCopyWith(ResolvedTokens value, $Res Function(ResolvedTokens) _then) = _$ResolvedTokensCopyWithImpl;
@useResult
$Res call({
 List<TokenBalance> balances, List<UnresolvedAsset> unresolved
});




}
/// @nodoc
class _$ResolvedTokensCopyWithImpl<$Res>
    implements $ResolvedTokensCopyWith<$Res> {
  _$ResolvedTokensCopyWithImpl(this._self, this._then);

  final ResolvedTokens _self;
  final $Res Function(ResolvedTokens) _then;

/// Create a copy of ResolvedTokens
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balances = null,Object? unresolved = null,}) {
  return _then(_self.copyWith(
balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as List<TokenBalance>,unresolved: null == unresolved ? _self.unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as List<UnresolvedAsset>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolvedTokens].
extension ResolvedTokensPatterns on ResolvedTokens {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolvedTokens value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolvedTokens() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolvedTokens value)  $default,){
final _that = this;
switch (_that) {
case _ResolvedTokens():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolvedTokens value)?  $default,){
final _that = this;
switch (_that) {
case _ResolvedTokens() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TokenBalance> balances,  List<UnresolvedAsset> unresolved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolvedTokens() when $default != null:
return $default(_that.balances,_that.unresolved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TokenBalance> balances,  List<UnresolvedAsset> unresolved)  $default,) {final _that = this;
switch (_that) {
case _ResolvedTokens():
return $default(_that.balances,_that.unresolved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TokenBalance> balances,  List<UnresolvedAsset> unresolved)?  $default,) {final _that = this;
switch (_that) {
case _ResolvedTokens() when $default != null:
return $default(_that.balances,_that.unresolved);case _:
  return null;

}
}

}

/// @nodoc


class _ResolvedTokens implements ResolvedTokens {
  const _ResolvedTokens({final  List<TokenBalance> balances = const <TokenBalance>[], final  List<UnresolvedAsset> unresolved = const <UnresolvedAsset>[]}): _balances = balances,_unresolved = unresolved;
  

 final  List<TokenBalance> _balances;
@override@JsonKey() List<TokenBalance> get balances {
  if (_balances is EqualUnmodifiableListView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_balances);
}

 final  List<UnresolvedAsset> _unresolved;
@override@JsonKey() List<UnresolvedAsset> get unresolved {
  if (_unresolved is EqualUnmodifiableListView) return _unresolved;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unresolved);
}


/// Create a copy of ResolvedTokens
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolvedTokensCopyWith<_ResolvedTokens> get copyWith => __$ResolvedTokensCopyWithImpl<_ResolvedTokens>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolvedTokens&&const DeepCollectionEquality().equals(other._balances, _balances)&&const DeepCollectionEquality().equals(other._unresolved, _unresolved));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_balances),const DeepCollectionEquality().hash(_unresolved));

@override
String toString() {
  return 'ResolvedTokens(balances: $balances, unresolved: $unresolved)';
}


}

/// @nodoc
abstract mixin class _$ResolvedTokensCopyWith<$Res> implements $ResolvedTokensCopyWith<$Res> {
  factory _$ResolvedTokensCopyWith(_ResolvedTokens value, $Res Function(_ResolvedTokens) _then) = __$ResolvedTokensCopyWithImpl;
@override @useResult
$Res call({
 List<TokenBalance> balances, List<UnresolvedAsset> unresolved
});




}
/// @nodoc
class __$ResolvedTokensCopyWithImpl<$Res>
    implements _$ResolvedTokensCopyWith<$Res> {
  __$ResolvedTokensCopyWithImpl(this._self, this._then);

  final _ResolvedTokens _self;
  final $Res Function(_ResolvedTokens) _then;

/// Create a copy of ResolvedTokens
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balances = null,Object? unresolved = null,}) {
  return _then(_ResolvedTokens(
balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as List<TokenBalance>,unresolved: null == unresolved ? _self._unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as List<UnresolvedAsset>,
  ));
}


}

// dart format on
