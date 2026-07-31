// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountMeta _$AccountMetaFromJson(Map<String, dynamic> json) => _AccountMeta(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  address: json['address'] as String,
  name: json['name'] as String?,
);

Map<String, dynamic> _$AccountMetaToJson(_AccountMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'address': instance.address,
      'name': instance.name,
    };

_WalletMeta _$WalletMetaFromJson(Map<String, dynamic> json) => _WalletMeta(
  id: json['id'] as String,
  source: $enumDecode(_$WalletSourceEnumMap, json['source']),
  accounts: (json['accounts'] as List<dynamic>)
      .map((e) => AccountMeta.fromJson(e as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String?,
  isBackedUp: json['isBackedUp'] as bool? ?? false,
);

Map<String, dynamic> _$WalletMetaToJson(_WalletMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': _$WalletSourceEnumMap[instance.source]!,
      'accounts': instance.accounts,
      'name': instance.name,
      'isBackedUp': instance.isBackedUp,
    };

const _$WalletSourceEnumMap = {
  WalletSource.created: 'created',
  WalletSource.imported: 'imported',
};

_WalletState _$WalletStateFromJson(Map<String, dynamic> json) => _WalletState(
  wallets:
      (json['wallets'] as List<dynamic>?)
          ?.map((e) => WalletMeta.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentWalletId: json['currentWalletId'] as String?,
  currentAccountId: json['currentAccountId'] as String?,
);

Map<String, dynamic> _$WalletStateToJson(_WalletState instance) =>
    <String, dynamic>{
      'wallets': instance.wallets,
      'currentWalletId': instance.currentWalletId,
      'currentAccountId': instance.currentAccountId,
    };
