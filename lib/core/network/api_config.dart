/// Compile-time API configuration.
///
/// Keys come from `--dart-define` and have **no default**. A build without them
/// ships an empty key, and the app is expected to degrade visibly ("balances not
/// configured") rather than fire unauthenticated requests that 401 in a way
/// nobody can read.
///
/// Run with:
///   flutter run --dart-define-from-file=env.json
/// and keep `env.json` in `.gitignore`.
///
/// Overview §3: a key inside a shipped binary IS extractable. That is accepted
/// at this scale only alongside a bundle-ID restriction and a spend cap on the
/// Alchemy dashboard. Public distribution needs a proxy instead.
abstract final class ApiConfig {
  static const String alchemyKey = String.fromEnvironment('ALCHEMY_API_KEY');
  static const String coingeckoKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
  );

  static bool get hasAlchemyKey => alchemyKey.isNotEmpty;
  static bool get hasCoingeckoKey => coingeckoKey.isNotEmpty;

  /// Alchemy Portfolio API. The key sits in the PATH, not a header — which is
  /// why request logging has to be redacted (see `RedactingLogInterceptor`).
  static const String alchemyDataBase = 'https://api.g.alchemy.com/data/v1';

  /// Per-chain JSON-RPC, used for token metadata lookups.
  static String alchemyRpcUrl(String network) =>
      'https://$network.g.alchemy.com/v2/$alchemyKey';

  static const String coingeckoBase = 'https://api.coingecko.com/api/v3';

  /// Alchemy Portfolio limits: at most three `{address, networks}` pairs per
  /// request, and at most twenty networks inside one pair.
  ///
  /// Note what this means for a single wallet: all its chains fit in ONE pair,
  /// so eight chains is one request, not eight. That is the whole reason the
  /// balance provider is keyed by address and chunks internally, instead of
  /// being a `.family` over `(address, chainId)` that would issue one request
  /// per chain and multiply the rate-limit pressure.
  static const int maxAddressNetworkPairs = 3;
  static const int maxNetworksPerPair = 20;

  /// Circuit breaker for `pageKey` looping. An address spammed with thousands
  /// of dust airdrops must not paginate forever on a mobile connection; hitting
  /// this records a ChainFailure so the total is honestly marked incomplete.
  static const int maxBalancePages = 10;

  /// Cap on metadata lookups per refresh, for the same reason.
  static const int maxMetadataLookups = 40;

  /// How long a price stays fresh. Short enough to feel live, long enough that
  /// tab switching does not exhaust the CoinGecko free tier.
  static const Duration priceTtl = Duration(seconds: 60);

  /// How long a fetched balance set is kept after the last listener goes away.
  static const Duration balanceCacheTtl = Duration(minutes: 5);
}
