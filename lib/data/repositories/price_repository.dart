import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';

import '../../core/money/money.dart';
import '../chain/asset_ref.dart';
import '../chain/chain_registry.dart';
import '../chain/price_query.dart';

/// CoinGecko prices.
///
/// Two lookup routes, in order of preference:
///  1. the token's own `coingeckoId` from the registry — one batched
///     `/simple/price?ids=` call for all of them;
///  2. otherwise `(chain platform, contract address)` — one batched
///     `/simple/token_price/{platform}` call per chain.
///
/// **Never by symbol.** The registry carries eight USDT contracts across eight
/// chains under five distinct CoinGecko ids; matching on `USDT` would hand one
/// chain's price to another chain's asset, and a bridged token on a chain with
/// no platform id would silently inherit mainnet's price.
///
/// An asset with neither route resolves to an absent key, never to zero. Absent
/// keeps the holding out of the total and marks the snapshot incomplete; zero
/// would understate the total while still looking complete.
class PriceRepository {
  const PriceRepository(this._dio, this._registry);

  static final _hundred = Decimal.fromInt(100);

  final Dio _dio;
  final ChainRegistry _registry;

  Future<Map<AssetRef, FiatPrice>> fetch(PriceQuery query) async {
    if (query.isEmpty) return const {};

    final byCoingeckoId = <String, List<AssetRef>>{};
    final byPlatform = <String, List<AssetRef>>{};

    for (final ref in query.refs) {
      final id = _registry.token(ref)?.coingeckoId;
      if (id != null && id.isNotEmpty) {
        byCoingeckoId.putIfAbsent(id, () => []).add(ref);
        continue;
      }
      // Testnets deliberately have no platform: a testnet balance must never
      // show a fiat value.
      final platform = _registry.chain(ref.chainId)?.coingeckoPlatform;
      if (platform != null && !ref.isNative) {
        byPlatform.putIfAbsent(platform, () => []).add(ref);
      }
    }

    final prices = <AssetRef, FiatPrice>{};
    final currency = query.currency.toLowerCase();

    if (byCoingeckoId.isNotEmpty) {
      await _fetchByIds(byCoingeckoId, currency, prices);
    }
    for (final entry in byPlatform.entries) {
      await _fetchByContracts(entry.key, entry.value, currency, prices);
    }

    return prices;
  }

  Future<void> _fetchByIds(
    Map<String, List<AssetRef>> byId,
    String currency,
    Map<AssetRef, FiatPrice> into,
  ) async {
    final body = await _get('/simple/price', {
      'ids': byId.keys.join(','),
      'vs_currencies': currency,
      'include_24hr_change': 'true',
    });
    if (body == null) return;

    final now = DateTime.now();
    for (final entry in byId.entries) {
      final price = _readPrice(body[entry.key], currency, now);
      if (price == null) continue;
      for (final ref in entry.value) {
        into[ref] = price;
      }
    }
  }

  Future<void> _fetchByContracts(
    String platform,
    List<AssetRef> refs,
    String currency,
    Map<AssetRef, FiatPrice> into,
  ) async {
    final body = await _get('/simple/token_price/$platform', {
      'contract_addresses': refs.map((r) => r.address).join(','),
      'vs_currencies': currency,
      'include_24hr_change': 'true',
    });
    if (body == null) return;

    // CoinGecko echoes contract addresses lower-cased, which is also how
    // AssetRef stores them — but normalise anyway rather than rely on it.
    final lowered = {
      for (final e in body.entries) e.key.toLowerCase(): e.value,
    };

    final now = DateTime.now();
    for (final ref in refs) {
      final price = _readPrice(lowered[ref.address], currency, now);
      if (price != null) into[ref] = price;
    }
  }

  Future<Map<String, dynamic>?> _get(
    String path,
    Map<String, String> query,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data;
    } on Object {
      // Prices are best-effort. A CoinGecko outage degrades the snapshot to
      // "amounts, no fiat" — balances are what the user actually needs.
      return null;
    }
  }

  static FiatPrice? _readPrice(
    Object? entry,
    String currency,
    DateTime asOf,
  ) {
    if (entry is! Map) return null;

    final value = _toDecimal(entry[currency]);
    if (value == null) return null;

    return FiatPrice(
      currency: currency.toUpperCase(),
      value: value,
      asOf: asOf,
      // CoinGecko reports percent; the model stores a fraction. Dividing by a
      // power of ten is exact, so `toDecimal()` cannot lose anything here.
      change24h: switch (_toDecimal(entry['${currency}_24h_change'])) {
        final change? => (change / _hundred).toDecimal(),
        null => null,
      },
    );
  }

  /// Numbers arrive as JSON doubles. This is the only place a `double` is
  /// allowed anywhere near money, and it is converted immediately and never
  /// used for arithmetic: a price is a market quote, not a balance, and its
  /// precision was already fixed by the wire format.
  static Decimal? _toDecimal(Object? raw) => switch (raw) {
    final num n => Decimal.tryParse(n.toString()),
    final String s => Decimal.tryParse(s),
    _ => null,
  };
}
