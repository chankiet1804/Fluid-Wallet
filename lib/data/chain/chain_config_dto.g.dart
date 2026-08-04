// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChainConfigDto _$ChainConfigDtoFromJson(Map<String, dynamic> json) =>
    _ChainConfigDto(
      chainId: json['chainId'] as String,
      chainName: json['chainName'] as String,
      chain: json['chain'] as String,
      groupChain: json['groupChain'] as String,
      symbol: json['symbol'] as String,
      rpcUrl: json['rpcUrl'] as String,
      explorerUrl: json['explorerUrl'] as String,
      decimals: (json['decimals'] as num).toInt(),
      derivationPath: json['derivationPath'] as String,
      status: json['status'] as String,
      icon: json['icon'] as String?,
      rpcOptions:
          (json['rpcOptions'] as List<dynamic>?)
              ?.map((e) => RpcOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RpcOptionDto>[],
      tokens:
          (json['tokens'] as List<dynamic>?)
              ?.map((e) => TokenConfigDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TokenConfigDto>[],
    );

Map<String, dynamic> _$ChainConfigDtoToJson(_ChainConfigDto instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'chainName': instance.chainName,
      'chain': instance.chain,
      'groupChain': instance.groupChain,
      'symbol': instance.symbol,
      'rpcUrl': instance.rpcUrl,
      'explorerUrl': instance.explorerUrl,
      'decimals': instance.decimals,
      'derivationPath': instance.derivationPath,
      'status': instance.status,
      'icon': instance.icon,
      'rpcOptions': instance.rpcOptions,
      'tokens': instance.tokens,
    };

_RpcOptionDto _$RpcOptionDtoFromJson(Map<String, dynamic> json) =>
    _RpcOptionDto(
      name: json['name'] as String,
      url: json['url'] as String,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$RpcOptionDtoToJson(_RpcOptionDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'source': instance.source,
    };

_TokenConfigDto _$TokenConfigDtoFromJson(Map<String, dynamic> json) =>
    _TokenConfigDto(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      address: json['address'] as String,
      decimals: (json['decimals'] as num).toInt(),
      status: json['status'] as String,
      icon: json['icon'] as String?,
      type: json['type'] as String?,
      coingeckoId: json['coingeckoId'] as String?,
      tradingSymbol: json['tradingSymbol'] as String?,
    );

Map<String, dynamic> _$TokenConfigDtoToJson(_TokenConfigDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'address': instance.address,
      'decimals': instance.decimals,
      'status': instance.status,
      'icon': instance.icon,
      'type': instance.type,
      'coingeckoId': instance.coingeckoId,
      'tradingSymbol': instance.tradingSymbol,
    };
