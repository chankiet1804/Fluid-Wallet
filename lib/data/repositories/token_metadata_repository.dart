import 'package:dio/dio.dart';

import '../../core/network/network.dart';
import '../chain/asset_ref.dart';
import '../chain/chain_info.dart';
import '../chain/token_info.dart';

/// Types a contract the balance API returned but the registry does not list.
///
/// Returns null whenever the token's scale cannot be established. That null is
/// the whole point of this class: the caller turns it into an `UnresolvedAsset`
/// that renders no number, instead of a `TokenInfo` with a guessed 18 decimals.
class TokenMetadataRepository {
  const TokenMetadataRepository(this._dio);

  final Dio _dio;

  Future<TokenInfo?> fetch(AssetRef ref, ChainInfo chain) async {
    final network = chain.alchemyNetwork;
    if (network == null || !ApiConfig.hasAlchemyKey) return null;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConfig.alchemyRpcUrl(network),
        data: <String, dynamic>{
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'alchemy_getTokenMetadata',
          'params': [ref.address],
        },
        options: Options(headers: {'content-type': 'application/json'}),
      );

      final result = response.data?['result'];
      if (result is! Map<String, dynamic>) return null;

      // No usable scale means no usable amount. Bail rather than default.
      final decimals = result['decimals'];
      if (decimals is! int || decimals < 0 || decimals > 36) return null;

      final symbol = (result['symbol'] as String?)?.trim();
      if (symbol == null || symbol.isEmpty) return null;

      return TokenInfo(
        ref: ref,
        symbol: symbol,
        name: (result['name'] as String?)?.trim() ?? symbol,
        decimals: decimals,
        source: TokenSource.discovered,
        iconUrl: result['logo'] as String?,
      );
    } on Object {
      // A metadata miss must not fail the portfolio; the balance still shows up
      // as unresolved.
      return null;
    }
  }
}
