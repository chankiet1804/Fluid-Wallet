import 'package:freezed_annotation/freezed_annotation.dart';

/// What our chosen vendors call a chain.
///
/// Deliberately NOT in `chains-default.json`. That file describes the chain
/// itself and can be replaced wholesale from an external source; these slugs
/// describe *our* integration choices. Merging the two means hand-reconciling
/// our fields every time the file is refreshed.
@immutable
class ChainCapabilities {
  const ChainCapabilities({this.alchemyNetwork, this.coingeckoPlatform});

  /// Alchemy network slug, e.g. `base-mainnet`. Null means the balance fan-out
  /// skips this chain — it stays listed and honest about having no data.
  final String? alchemyNetwork;

  /// CoinGecko `asset_platforms` id, for pricing an ERC-20 by contract address
  /// when the registry has no `coingeckoId` for it.
  final String? coingeckoPlatform;
}

/// Keyed by EIP-155 chain id.
///
/// A chain present in `chains-default.json` but absent here is surfaced as
/// "balances not supported yet" rather than dropped. Never derive a slug from
/// the file's `chain` field: guessing wrong means either a 400 or, worse, data
/// for a different chain.
///
/// Verify any new entry against the vendor's own list before adding it:
/// https://www.alchemy.com/docs/reference/api-overview  ·
/// https://api.coingecko.com/api/v3/asset_platforms
const Map<int, ChainCapabilities> kChainCapabilities = <int, ChainCapabilities>{
  // Ethereum
  1: ChainCapabilities(
    alchemyNetwork: 'eth-mainnet',
    coingeckoPlatform: 'ethereum',
  ),
  // OP Mainnet
  10: ChainCapabilities(
    alchemyNetwork: 'opt-mainnet',
    coingeckoPlatform: 'optimistic-ethereum',
  ),
  // BNB Smart Chain
  56: ChainCapabilities(
    alchemyNetwork: 'bnb-mainnet',
    coingeckoPlatform: 'binance-smart-chain',
  ),
  // Polygon
  137: ChainCapabilities(
    alchemyNetwork: 'polygon-mainnet',
    coingeckoPlatform: 'polygon-pos',
  ),
  // Base
  8453: ChainCapabilities(
    alchemyNetwork: 'base-mainnet',
    coingeckoPlatform: 'base',
  ),
  // Arbitrum One
  42161: ChainCapabilities(
    alchemyNetwork: 'arb-mainnet',
    coingeckoPlatform: 'arbitrum-one',
  ),
  // Avalanche C-Chain
  43114: ChainCapabilities(
    alchemyNetwork: 'avax-mainnet',
    coingeckoPlatform: 'avalanche',
  ),
  // Linea
  59144: ChainCapabilities(
    alchemyNetwork: 'linea-mainnet',
    coingeckoPlatform: 'linea',
  ),
  // Base Sepolia — the dev loop chain (overview §1.3). No CoinGecko platform:
  // a testnet must never show a fiat value.
  84532: ChainCapabilities(alchemyNetwork: 'base-sepolia'),
};
