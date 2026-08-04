// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceQuery {

 List<AssetRef> get refs; String get currency;
/// Create a copy of PriceQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceQueryCopyWith<PriceQuery> get copyWith => _$PriceQueryCopyWithImpl<PriceQuery>(this as PriceQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceQuery&&const DeepCollectionEquality().equals(other.refs, refs)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(refs),currency);

@override
String toString() {
  return 'PriceQuery(refs: $refs, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $PriceQueryCopyWith<$Res>  {
  factory $PriceQueryCopyWith(PriceQuery value, $Res Function(PriceQuery) _then) = _$PriceQueryCopyWithImpl;
@useResult
$Res call({
 List<AssetRef> refs, String currency
});




}
/// @nodoc
class _$PriceQueryCopyWithImpl<$Res>
    implements $PriceQueryCopyWith<$Res> {
  _$PriceQueryCopyWithImpl(this._self, this._then);

  final PriceQuery _self;
  final $Res Function(PriceQuery) _then;

/// Create a copy of PriceQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refs = null,Object? currency = null,}) {
  return _then(_self.copyWith(
refs: null == refs ? _self.refs : refs // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceQuery].
extension PriceQueryPatterns on PriceQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PriceQuery value)?  sorted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceQuery() when sorted != null:
return sorted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PriceQuery value)  sorted,}){
final _that = this;
switch (_that) {
case _PriceQuery():
return sorted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PriceQuery value)?  sorted,}){
final _that = this;
switch (_that) {
case _PriceQuery() when sorted != null:
return sorted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<AssetRef> refs,  String currency)?  sorted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceQuery() when sorted != null:
return sorted(_that.refs,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<AssetRef> refs,  String currency)  sorted,}) {final _that = this;
switch (_that) {
case _PriceQuery():
return sorted(_that.refs,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<AssetRef> refs,  String currency)?  sorted,}) {final _that = this;
switch (_that) {
case _PriceQuery() when sorted != null:
return sorted(_that.refs,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _PriceQuery extends PriceQuery {
  const _PriceQuery({required final  List<AssetRef> refs, required this.currency}): _refs = refs,super._();
  

 final  List<AssetRef> _refs;
@override List<AssetRef> get refs {
  if (_refs is EqualUnmodifiableListView) return _refs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_refs);
}

@override final  String currency;

/// Create a copy of PriceQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceQueryCopyWith<_PriceQuery> get copyWith => __$PriceQueryCopyWithImpl<_PriceQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceQuery&&const DeepCollectionEquality().equals(other._refs, _refs)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_refs),currency);

@override
String toString() {
  return 'PriceQuery.sorted(refs: $refs, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$PriceQueryCopyWith<$Res> implements $PriceQueryCopyWith<$Res> {
  factory _$PriceQueryCopyWith(_PriceQuery value, $Res Function(_PriceQuery) _then) = __$PriceQueryCopyWithImpl;
@override @useResult
$Res call({
 List<AssetRef> refs, String currency
});




}
/// @nodoc
class __$PriceQueryCopyWithImpl<$Res>
    implements _$PriceQueryCopyWith<$Res> {
  __$PriceQueryCopyWithImpl(this._self, this._then);

  final _PriceQuery _self;
  final $Res Function(_PriceQuery) _then;

/// Create a copy of PriceQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refs = null,Object? currency = null,}) {
  return _then(_PriceQuery(
refs: null == refs ? _self._refs : refs // ignore: cast_nullable_to_non_nullable
as List<AssetRef>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
