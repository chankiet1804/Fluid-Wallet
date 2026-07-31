// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountMeta {

 String get id; int get index;/// EIP-55 checksummed.
 String get address; String? get name;
/// Create a copy of AccountMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountMetaCopyWith<AccountMeta> get copyWith => _$AccountMetaCopyWithImpl<AccountMeta>(this as AccountMeta, _$identity);

  /// Serializes this AccountMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,address,name);

@override
String toString() {
  return 'AccountMeta(id: $id, index: $index, address: $address, name: $name)';
}


}

/// @nodoc
abstract mixin class $AccountMetaCopyWith<$Res>  {
  factory $AccountMetaCopyWith(AccountMeta value, $Res Function(AccountMeta) _then) = _$AccountMetaCopyWithImpl;
@useResult
$Res call({
 String id, int index, String address, String? name
});




}
/// @nodoc
class _$AccountMetaCopyWithImpl<$Res>
    implements $AccountMetaCopyWith<$Res> {
  _$AccountMetaCopyWithImpl(this._self, this._then);

  final AccountMeta _self;
  final $Res Function(AccountMeta) _then;

/// Create a copy of AccountMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? index = null,Object? address = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountMeta].
extension AccountMetaPatterns on AccountMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountMeta value)  $default,){
final _that = this;
switch (_that) {
case _AccountMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountMeta value)?  $default,){
final _that = this;
switch (_that) {
case _AccountMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int index,  String address,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountMeta() when $default != null:
return $default(_that.id,_that.index,_that.address,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int index,  String address,  String? name)  $default,) {final _that = this;
switch (_that) {
case _AccountMeta():
return $default(_that.id,_that.index,_that.address,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int index,  String address,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _AccountMeta() when $default != null:
return $default(_that.id,_that.index,_that.address,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountMeta implements AccountMeta {
  const _AccountMeta({required this.id, required this.index, required this.address, this.name});
  factory _AccountMeta.fromJson(Map<String, dynamic> json) => _$AccountMetaFromJson(json);

@override final  String id;
@override final  int index;
/// EIP-55 checksummed.
@override final  String address;
@override final  String? name;

/// Create a copy of AccountMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountMetaCopyWith<_AccountMeta> get copyWith => __$AccountMetaCopyWithImpl<_AccountMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,address,name);

@override
String toString() {
  return 'AccountMeta(id: $id, index: $index, address: $address, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AccountMetaCopyWith<$Res> implements $AccountMetaCopyWith<$Res> {
  factory _$AccountMetaCopyWith(_AccountMeta value, $Res Function(_AccountMeta) _then) = __$AccountMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String address, String? name
});




}
/// @nodoc
class __$AccountMetaCopyWithImpl<$Res>
    implements _$AccountMetaCopyWith<$Res> {
  __$AccountMetaCopyWithImpl(this._self, this._then);

  final _AccountMeta _self;
  final $Res Function(_AccountMeta) _then;

/// Create a copy of AccountMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? address = null,Object? name = freezed,}) {
  return _then(_AccountMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WalletMeta {

 String get id; WalletSource get source; List<AccountMeta> get accounts; String? get name; bool get isBackedUp;
/// Create a copy of WalletMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletMetaCopyWith<WalletMeta> get copyWith => _$WalletMetaCopyWithImpl<WalletMeta>(this as WalletMeta, _$identity);

  /// Serializes this WalletMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.name, name) || other.name == name)&&(identical(other.isBackedUp, isBackedUp) || other.isBackedUp == isBackedUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,const DeepCollectionEquality().hash(accounts),name,isBackedUp);

@override
String toString() {
  return 'WalletMeta(id: $id, source: $source, accounts: $accounts, name: $name, isBackedUp: $isBackedUp)';
}


}

/// @nodoc
abstract mixin class $WalletMetaCopyWith<$Res>  {
  factory $WalletMetaCopyWith(WalletMeta value, $Res Function(WalletMeta) _then) = _$WalletMetaCopyWithImpl;
@useResult
$Res call({
 String id, WalletSource source, List<AccountMeta> accounts, String? name, bool isBackedUp
});




}
/// @nodoc
class _$WalletMetaCopyWithImpl<$Res>
    implements $WalletMetaCopyWith<$Res> {
  _$WalletMetaCopyWithImpl(this._self, this._then);

  final WalletMeta _self;
  final $Res Function(WalletMeta) _then;

/// Create a copy of WalletMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? accounts = null,Object? name = freezed,Object? isBackedUp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WalletSource,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountMeta>,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isBackedUp: null == isBackedUp ? _self.isBackedUp : isBackedUp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletMeta].
extension WalletMetaPatterns on WalletMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletMeta value)  $default,){
final _that = this;
switch (_that) {
case _WalletMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletMeta value)?  $default,){
final _that = this;
switch (_that) {
case _WalletMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  WalletSource source,  List<AccountMeta> accounts,  String? name,  bool isBackedUp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletMeta() when $default != null:
return $default(_that.id,_that.source,_that.accounts,_that.name,_that.isBackedUp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  WalletSource source,  List<AccountMeta> accounts,  String? name,  bool isBackedUp)  $default,) {final _that = this;
switch (_that) {
case _WalletMeta():
return $default(_that.id,_that.source,_that.accounts,_that.name,_that.isBackedUp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  WalletSource source,  List<AccountMeta> accounts,  String? name,  bool isBackedUp)?  $default,) {final _that = this;
switch (_that) {
case _WalletMeta() when $default != null:
return $default(_that.id,_that.source,_that.accounts,_that.name,_that.isBackedUp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletMeta implements WalletMeta {
  const _WalletMeta({required this.id, required this.source, required final  List<AccountMeta> accounts, this.name, this.isBackedUp = false}): _accounts = accounts;
  factory _WalletMeta.fromJson(Map<String, dynamic> json) => _$WalletMetaFromJson(json);

@override final  String id;
@override final  WalletSource source;
 final  List<AccountMeta> _accounts;
@override List<AccountMeta> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override final  String? name;
@override@JsonKey() final  bool isBackedUp;

/// Create a copy of WalletMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletMetaCopyWith<_WalletMeta> get copyWith => __$WalletMetaCopyWithImpl<_WalletMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.name, name) || other.name == name)&&(identical(other.isBackedUp, isBackedUp) || other.isBackedUp == isBackedUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,const DeepCollectionEquality().hash(_accounts),name,isBackedUp);

@override
String toString() {
  return 'WalletMeta(id: $id, source: $source, accounts: $accounts, name: $name, isBackedUp: $isBackedUp)';
}


}

/// @nodoc
abstract mixin class _$WalletMetaCopyWith<$Res> implements $WalletMetaCopyWith<$Res> {
  factory _$WalletMetaCopyWith(_WalletMeta value, $Res Function(_WalletMeta) _then) = __$WalletMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, WalletSource source, List<AccountMeta> accounts, String? name, bool isBackedUp
});




}
/// @nodoc
class __$WalletMetaCopyWithImpl<$Res>
    implements _$WalletMetaCopyWith<$Res> {
  __$WalletMetaCopyWithImpl(this._self, this._then);

  final _WalletMeta _self;
  final $Res Function(_WalletMeta) _then;

/// Create a copy of WalletMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? accounts = null,Object? name = freezed,Object? isBackedUp = null,}) {
  return _then(_WalletMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WalletSource,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountMeta>,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isBackedUp: null == isBackedUp ? _self.isBackedUp : isBackedUp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WalletState {

 List<WalletMeta> get wallets; String? get currentWalletId; String? get currentAccountId;
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletStateCopyWith<WalletState> get copyWith => _$WalletStateCopyWithImpl<WalletState>(this as WalletState, _$identity);

  /// Serializes this WalletState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletState&&const DeepCollectionEquality().equals(other.wallets, wallets)&&(identical(other.currentWalletId, currentWalletId) || other.currentWalletId == currentWalletId)&&(identical(other.currentAccountId, currentAccountId) || other.currentAccountId == currentAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(wallets),currentWalletId,currentAccountId);

@override
String toString() {
  return 'WalletState(wallets: $wallets, currentWalletId: $currentWalletId, currentAccountId: $currentAccountId)';
}


}

/// @nodoc
abstract mixin class $WalletStateCopyWith<$Res>  {
  factory $WalletStateCopyWith(WalletState value, $Res Function(WalletState) _then) = _$WalletStateCopyWithImpl;
@useResult
$Res call({
 List<WalletMeta> wallets, String? currentWalletId, String? currentAccountId
});




}
/// @nodoc
class _$WalletStateCopyWithImpl<$Res>
    implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._self, this._then);

  final WalletState _self;
  final $Res Function(WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallets = null,Object? currentWalletId = freezed,Object? currentAccountId = freezed,}) {
  return _then(_self.copyWith(
wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletMeta>,currentWalletId: freezed == currentWalletId ? _self.currentWalletId : currentWalletId // ignore: cast_nullable_to_non_nullable
as String?,currentAccountId: freezed == currentAccountId ? _self.currentAccountId : currentAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletState value)  $default,){
final _that = this;
switch (_that) {
case _WalletState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WalletMeta> wallets,  String? currentWalletId,  String? currentAccountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.wallets,_that.currentWalletId,_that.currentAccountId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WalletMeta> wallets,  String? currentWalletId,  String? currentAccountId)  $default,) {final _that = this;
switch (_that) {
case _WalletState():
return $default(_that.wallets,_that.currentWalletId,_that.currentAccountId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WalletMeta> wallets,  String? currentWalletId,  String? currentAccountId)?  $default,) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.wallets,_that.currentWalletId,_that.currentAccountId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletState extends WalletState {
  const _WalletState({final  List<WalletMeta> wallets = const [], this.currentWalletId, this.currentAccountId}): _wallets = wallets,super._();
  factory _WalletState.fromJson(Map<String, dynamic> json) => _$WalletStateFromJson(json);

 final  List<WalletMeta> _wallets;
@override@JsonKey() List<WalletMeta> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}

@override final  String? currentWalletId;
@override final  String? currentAccountId;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletStateCopyWith<_WalletState> get copyWith => __$WalletStateCopyWithImpl<_WalletState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletState&&const DeepCollectionEquality().equals(other._wallets, _wallets)&&(identical(other.currentWalletId, currentWalletId) || other.currentWalletId == currentWalletId)&&(identical(other.currentAccountId, currentAccountId) || other.currentAccountId == currentAccountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_wallets),currentWalletId,currentAccountId);

@override
String toString() {
  return 'WalletState(wallets: $wallets, currentWalletId: $currentWalletId, currentAccountId: $currentAccountId)';
}


}

/// @nodoc
abstract mixin class _$WalletStateCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletStateCopyWith(_WalletState value, $Res Function(_WalletState) _then) = __$WalletStateCopyWithImpl;
@override @useResult
$Res call({
 List<WalletMeta> wallets, String? currentWalletId, String? currentAccountId
});




}
/// @nodoc
class __$WalletStateCopyWithImpl<$Res>
    implements _$WalletStateCopyWith<$Res> {
  __$WalletStateCopyWithImpl(this._self, this._then);

  final _WalletState _self;
  final $Res Function(_WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallets = null,Object? currentWalletId = freezed,Object? currentAccountId = freezed,}) {
  return _then(_WalletState(
wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletMeta>,currentWalletId: freezed == currentWalletId ? _self.currentWalletId : currentWalletId // ignore: cast_nullable_to_non_nullable
as String?,currentAccountId: freezed == currentAccountId ? _self.currentAccountId : currentAccountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
