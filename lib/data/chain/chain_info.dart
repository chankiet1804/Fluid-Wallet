import 'package:freezed_annotation/freezed_annotation.dart';

import 'chain_capabilities.dart';

/// Bundled network marks, keyed by the `chain` slug in
/// `assets/config/chains-default.json`.
///
/// The remote `icon` URL from the file is what renders; these stand in while it
/// loads and if it fails. A slug with no entry simply has no stand-in — which is
/// why a chain can be added without shipping an asset.
const Map<String, String> kBundledNetworkIcons = <String, String>{
  'ethereum': 'assets/icons/networks/ethereum.svg',
  'binancesmartchain': 'assets/icons/networks/binance-smart-chain.svg',
  'arbitrumone': 'assets/icons/networks/arbitrum-one.svg',
  'avalanche': 'assets/icons/networks/avalanche.svg',
  'polygon': 'assets/icons/networks/polygon.svg',
  'base': 'assets/icons/networks/base.svg',
  'optimism': 'assets/icons/networks/optimism.svg',
};

/// One EVM network, normalised out of a [ChainConfigDto].
///
/// Identity is [chainId] alone. It is the EVM's own primary key — the value
/// EIP-155 mixes into a signature, what Etherscan V2 `chainid=` takes, what 0x
/// takes. Two entries with the same id are the same chain however their display
/// fields differ, which is why `==` reads nothing else. (Structural equality,
/// freezed-style, would call a re-ordered entry a different chain.)
@immutable
class ChainInfo {
  const ChainInfo({
    required this.chainId,
    required this.name,
    required this.slug,
    required this.groupChain,
    required this.nativeSymbol,
    required this.nativeDecimals,
    required this.rpcUrl,
    required this.rpcOptions,
    required this.explorerUrl,
    required this.isEnabled,
    required this.sortOrder,
    this.iconUrl,
    this.capabilities,
  });

  /// EIP-155 chain id, parsed from the file's string.
  final int chainId;

  /// `chainName` — "Arbitrum One".
  final String name;

  /// `chain` — "arbitrumone". Only used to find a bundled icon.
  final String slug;

  /// Chains sharing a `groupChain` share a derivation and therefore an address.
  /// Every entry today is `ethereum`, which is what makes one address usable
  /// across all of them.
  final String groupChain;

  final String nativeSymbol;

  /// Read from the file, never assumed. Every EVM native is 18 today; the point
  /// of this layer is that no scale is a guess.
  final int nativeDecimals;

  /// Public RPC from the file. Fine for `eth_call` and gas estimation; balances
  /// go through Alchemy instead (overview §3 — public RPC rate limits are
  /// unpredictable).
  final String rpcUrl;

  final List<({String name, String url})> rpcOptions;

  /// No trailing slash.
  final String explorerUrl;

  /// `status == 'enabled'` in the file.
  final bool isEnabled;

  /// Order of appearance in the file.
  final int sortOrder;

  /// Remote PNG from the file, and what the UI renders first —
  /// `chains-default.json` is the single source, so its `icon` wins.
  final String? iconUrl;

  /// Null means this chain has no vendor integration yet.
  final ChainCapabilities? capabilities;

  /// Present so a non-EVM namespace is a later addition, not a rewrite.
  String get caip2 => 'eip155:$chainId';

  bool get supportsBalanceFetch => capabilities?.alchemyNetwork != null;
  String? get alchemyNetwork => capabilities?.alchemyNetwork;
  String? get coingeckoPlatform => capabilities?.coingeckoPlatform;

  /// Fallback for [iconUrl], and the placeholder while it loads: no network
  /// round-trip and it stays sharp at any size.
  String? get bundledIconAsset => kBundledNetworkIcons[slug];

  String txUrl(String hash) => '$explorerUrl/tx/$hash';
  String addressUrl(String address) => '$explorerUrl/address/$address';
  String tokenUrl(String address) => '$explorerUrl/token/$address';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChainInfo && other.chainId == chainId);

  @override
  int get hashCode => chainId.hashCode;

  @override
  String toString() => 'ChainInfo($chainId, $name)';
}
