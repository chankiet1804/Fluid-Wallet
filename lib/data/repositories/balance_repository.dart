import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import '../../core/network/network.dart';
import '../chain/asset_ref.dart';
import '../chain/chain_info.dart';
import '../chain/portfolio_snapshot.dart';
import '../chain/raw_balance_result.dart';

/// Alchemy Portfolio API — token balances for one address across many chains.
///
/// One request covers up to 20 networks for a single address, so the whole
/// enabled chain set is normally a single round trip. Requests are still chunked
/// and each chunk isolated, so one failing group degrades to a [ChainFailure]
/// for its chains instead of losing the entire portfolio.
class BalanceRepository {
  const BalanceRepository(this._dio);

  final Dio _dio;

  Future<RawBalanceResult> fetchBalances({
    required String address,
    required List<ChainInfo> chains,
  }) async {
    final fetchable = <ChainInfo>[];
    final failures = <ChainFailure>[];

    for (final c in chains) {
      if (c.supportsBalanceFetch) {
        fetchable.add(c);
      } else {
        failures.add(
          ChainFailure(
            chainId: c.chainId,
            kind: ChainFailureKind.unsupported,
            message: '${c.name} has no balance provider configured',
          ),
        );
      }
    }

    if (!ApiConfig.hasAlchemyKey) {
      return RawBalanceResult(
        balances: const {},
        fetchedAt: DateTime.now(),
        failures: [
          ...failures,
          for (final c in fetchable)
            ChainFailure(
              chainId: c.chainId,
              kind: ChainFailureKind.unauthorized,
              message: 'ALCHEMY_API_KEY is not set for this build',
            ),
        ],
      );
    }

    final balances = <AssetRef, BigInt>{};

    for (final chunk in _chunk(fetchable, ApiConfig.maxNetworksPerPair)) {
      try {
        await _fetchChunk(address: address, chains: chunk, into: balances);
      } on Object catch (error) {
        final failure = ApiException.from(error);
        failures.addAll(
          chunk.map(
            (c) => ChainFailure(
              chainId: c.chainId,
              kind: chainFailureKindOf(failure),
              message: failure.detail,
            ),
          ),
        );
      }
    }

    return RawBalanceResult(
      balances: balances,
      fetchedAt: DateTime.now(),
      failures: failures,
    );
  }

  Future<void> _fetchChunk({
    required String address,
    required List<ChainInfo> chains,
    required Map<AssetRef, BigInt> into,
  }) async {
    final bySlug = {for (final c in chains) c.alchemyNetwork!: c};
    String? pageKey;

    for (var page = 0; page < ApiConfig.maxBalancePages; page++) {
      final response = await _dio.post<Map<String, dynamic>>(
        '/${ApiConfig.alchemyKey}/assets/tokens/by-address',
        data: <String, dynamic>{
          'addresses': [
            {'address': address, 'networks': bySlug.keys.toList()},
          ],
          'includeNativeTokens': true,
          'pageKey': ?pageKey,
        },
      );

      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) {
        throw const ApiException(ApiFailureKind.parse, detail: 'missing data');
      }

      pageKey = parsePage(data, bySlug, into);
      if (pageKey == null) return;
    }

    // Ran out of pages. Surfacing this as a failure keeps the total honestly
    // marked incomplete rather than silently truncated.
    throw const ApiException(
      ApiFailureKind.parse,
      detail: 'balance pagination exceeded the page cap',
    );
  }

  /// Reads one `data` object into [into] and returns the next `pageKey`.
  ///
  /// Split out so the parsing test can drive a captured response through the
  /// exact code path the app uses. Defensive on purpose: a malformed entry is
  /// skipped, never guessed at.
  @visibleForTesting
  static String? parsePage(
    Map<String, dynamic> data,
    Map<String, ChainInfo> bySlug,
    Map<AssetRef, BigInt> into,
  ) {
    for (final entry in (data['tokens'] as List? ?? const [])) {
      if (entry is! Map<String, dynamic>) continue;

      // A network we did not ask for, or a slug we do not know: skip rather
      // than guess which chain it belongs to.
      final chain = bySlug[entry['network']];
      if (chain == null) continue;

      final raw = entry['tokenBalance'];
      if (raw is! String || raw.isEmpty) continue;
      final amount = parseHexBalance(raw);
      if (amount == BigInt.zero) continue;

      // A null or empty tokenAddress is the chain's own coin.
      final tokenAddress = entry['tokenAddress'] as String?;
      final ref = tokenAddress == null || tokenAddress.isEmpty
          ? AssetRef.native(chain.chainId)
          : AssetRef(chain.chainId, tokenAddress);

      into[ref] = amount;
    }

    return data['pageKey'] as String?;
  }

  /// Hex to [BigInt] directly. `int.parse` would overflow above 2^63, which a
  /// large-supply token reaches without being remarkable.
  @visibleForTesting
  static BigInt parseHexBalance(String hex) {
    final digits = hex.startsWith('0x') || hex.startsWith('0X')
        ? hex.substring(2)
        : hex;
    if (digits.isEmpty) return BigInt.zero;
    return BigInt.tryParse(digits, radix: 16) ?? BigInt.zero;
  }

  static Iterable<List<T>> _chunk<T>(List<T> items, int size) sync* {
    for (var i = 0; i < items.length; i += size) {
      yield items.sublist(i, (i + size).clamp(0, items.length));
    }
  }
}

ChainFailureKind chainFailureKindOf(ApiException e) => switch (e.kind) {
  ApiFailureKind.rateLimited => ChainFailureKind.rateLimited,
  ApiFailureKind.unauthorized ||
  ApiFailureKind.notConfigured => ChainFailureKind.unauthorized,
  ApiFailureKind.parse => ChainFailureKind.parse,
  _ => ChainFailureKind.network,
};
