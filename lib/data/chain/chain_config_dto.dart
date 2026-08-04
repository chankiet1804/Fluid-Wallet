import 'package:freezed_annotation/freezed_annotation.dart';

part 'chain_config_dto.freezed.dart';
part 'chain_config_dto.g.dart';

/// A 1:1 mirror of one entry in `assets/config/chains-default.json`.
///
/// This layer exists so the file's shape stops here. It keeps `chainId` as the
/// [String] the file actually writes, `status` as a raw string, and addresses in
/// whatever casing the file uses — Base writes USDC lower case while Ethereum
/// writes it checksummed. `ChainRegistry.fromDtos` is the one place that turns
/// all of it into app types, which is also the one place that can validate it.
///
/// Adding a field: append an optional parameter with a default. Entries written
/// before the field existed keep parsing.
@freezed
abstract class ChainConfigDto with _$ChainConfigDto {
  const factory ChainConfigDto({
    required String chainId,
    required String chainName,
    required String chain,
    required String groupChain,
    required String symbol,
    required String rpcUrl,
    required String explorerUrl,
    required int decimals,
    required String derivationPath,
    required String status,
    String? icon,
    @Default(<RpcOptionDto>[]) List<RpcOptionDto> rpcOptions,
    @Default(<TokenConfigDto>[]) List<TokenConfigDto> tokens,
  }) = _ChainConfigDto;

  factory ChainConfigDto.fromJson(Map<String, dynamic> json) =>
      _$ChainConfigDtoFromJson(json);
}

@freezed
abstract class RpcOptionDto with _$RpcOptionDto {
  const factory RpcOptionDto({
    required String name,
    required String url,
    String? source,
  }) = _RpcOptionDto;

  factory RpcOptionDto.fromJson(Map<String, dynamic> json) =>
      _$RpcOptionDtoFromJson(json);
}

/// One token entry. Note that [decimals] is required and has no default: a
/// token whose scale is unknown must fail to parse, not silently become 18.
@freezed
abstract class TokenConfigDto with _$TokenConfigDto {
  const factory TokenConfigDto({
    required String name,
    required String symbol,
    required String address,
    required int decimals,
    required String status,
    String? icon,
    String? type,
    String? coingeckoId,

    /// Comma-separated TradingView symbols. Carried through untouched; nothing
    /// reads it yet.
    String? tradingSymbol,
  }) = _TokenConfigDto;

  factory TokenConfigDto.fromJson(Map<String, dynamic> json) =>
      _$TokenConfigDtoFromJson(json);
}
