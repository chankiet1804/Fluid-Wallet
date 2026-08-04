import 'package:blockchain_utils/blockchain_utils.dart' show EthAddrUtils;

import '../../core/crypto/key_derivation.dart';
import 'asset_ref.dart';
import 'chain_capabilities.dart';
import 'chain_config_dto.dart';
import 'chain_info.dart';
import 'native_asset.dart';
import 'token_info.dart';

/// `assets/config/chains-default.json` is malformed or internally inconsistent.
///
/// Thrown at startup, on purpose. This file gets hand-edited to add chains and
/// tokens, and a single wrong character in an address sends funds nowhere. A
/// loud failure at launch is recoverable; a silently skipped token is not.
class RegistryFormatException implements Exception {
  const RegistryFormatException(this.message);

  final String message;

  @override
  String toString() => 'RegistryFormatException: $message';
}

final _addressPattern = RegExp(r'^0x[0-9a-fA-F]{40}$');

/// Decimals beyond this are not a real token, they are a typo. ERC-20 stores
/// decimals as a uint8, but 36 is already far past anything in circulation.
const int _maxDecimals = 36;

const String _enabledStatus = 'enabled';

/// The single boundary between `chains-default.json` and the rest of the app.
///
/// Everything that turns the file's shape into app types happens in
/// [ChainRegistry.fromDtos] — string ids to ints, address casing to a canonical
/// key, status strings to booleans, vendor slugs joined in. That is also the
/// only place the file can be validated, which is why nothing else is allowed
/// to read a [ChainConfigDto].
class ChainRegistry {
  const ChainRegistry._(this._chains, this._chainById, this._tokensByChain);

  /// Builds and validates. Throws [RegistryFormatException] on bad data.
  factory ChainRegistry.fromDtos(
    List<ChainConfigDto> dtos, {
    Map<int, ChainCapabilities> capabilities = kChainCapabilities,
  }) {
    final chains = <ChainInfo>[];
    final chainById = <int, ChainInfo>{};
    final tokensByChain = <int, List<TokenInfo>>{};

    for (var i = 0; i < dtos.length; i++) {
      final dto = dtos[i];

      final chainId = int.tryParse(dto.chainId);
      if (chainId == null) {
        throw RegistryFormatException(
          'chainId "${dto.chainId}" (${dto.chainName}) is not an integer',
        );
      }
      if (chainById.containsKey(chainId)) {
        throw RegistryFormatException('duplicate chainId $chainId');
      }
      _validateDerivationPath(dto, chainId);
      _validateDecimals(dto.decimals, 'chain $chainId native');

      final chain = ChainInfo(
        chainId: chainId,
        name: dto.chainName,
        slug: dto.chain,
        groupChain: dto.groupChain,
        nativeSymbol: dto.symbol,
        nativeDecimals: dto.decimals,
        rpcUrl: dto.rpcUrl,
        rpcOptions: [
          for (final o in dto.rpcOptions) (name: o.name, url: o.url),
        ],
        explorerUrl: _stripTrailingSlash(dto.explorerUrl),
        isEnabled: dto.status == _enabledStatus,
        sortOrder: i,
        iconUrl: dto.icon,
        capabilities: capabilities[chainId],
      );

      chains.add(chain);
      chainById[chainId] = chain;
      tokensByChain[chainId] = _buildTokens(dto, chain);
    }

    return ChainRegistry._(
      List.unmodifiable(chains),
      Map.unmodifiable(chainById),
      Map.unmodifiable(tokensByChain),
    );
  }

  final List<ChainInfo> _chains;
  final Map<int, ChainInfo> _chainById;
  final Map<int, List<TokenInfo>> _tokensByChain;

  /// Chains the file marks enabled, in file order.
  List<ChainInfo> get chains =>
      _chains.where((c) => c.isEnabled).toList(growable: false);

  /// Including the ones the file disabled. Only diagnostics should need this.
  List<ChainInfo> get allChains => _chains;

  ChainInfo? chain(int chainId) => _chainById[chainId];

  /// Enabled tokens on a chain, native first, then file order.
  List<TokenInfo> tokensOf(int chainId) =>
      _tokensByChain[chainId]?.where((t) => t.isEnabled).toList(
        growable: false,
      ) ??
      const [];

  /// Every enabled token on every enabled chain.
  List<TokenInfo> get allTokens => [
    for (final c in chains) ...tokensOf(c.chainId),
  ];

  /// Null means "not in the registry". It never means "assume 18 decimals" —
  /// the caller must either resolve real metadata or leave the balance
  /// unresolved.
  TokenInfo? token(AssetRef ref) {
    for (final t in _tokensByChain[ref.chainId] ?? const <TokenInfo>[]) {
      if (t.ref == ref) return t;
    }
    return null;
  }

  ChainInfo? byAlchemyNetwork(String slug) {
    for (final c in _chains) {
      if (c.alchemyNetwork == slug) return c;
    }
    return null;
  }

  // ---------------------------------------------------------------- helpers

  static List<TokenInfo> _buildTokens(ChainConfigDto dto, ChainInfo chain) {
    final tokens = <TokenInfo>[];
    final seen = <AssetRef>{};
    var sawNative = false;

    for (var i = 0; i < dto.tokens.length; i++) {
      final t = dto.tokens[i];
      final where = '${chain.name} token "${t.symbol}"';

      if (!_addressPattern.hasMatch(t.address)) {
        throw RegistryFormatException('$where has a malformed address '
            '"${t.address}" — expected 0x + 40 hex characters');
      }
      _validateDecimals(t.decimals, where);

      final lower = t.address.toLowerCase();
      final isNative = lower == kNativeAddress;

      // A mixed-case address is claiming to be EIP-55. Verify the claim: this
      // is what catches a single mistyped character, which an all-lower-case
      // address cannot reveal.
      String? checksum;
      if (!isNative) {
        checksum = EthAddrUtils.toChecksumAddress(t.address);
        final hasMixedCase = t.address != t.address.toLowerCase() &&
            t.address != t.address.toUpperCase();
        if (hasMixedCase && t.address != checksum) {
          throw RegistryFormatException(
            '$where fails its EIP-55 checksum — file has "${t.address}", '
            'correct is "$checksum". One wrong character here sends funds to '
            'an address nobody holds the key for.',
          );
        }
      }

      final ref = AssetRef.raw(chain.chainId, lower);
      if (!seen.add(ref)) {
        throw RegistryFormatException(
          '${chain.name} lists ${t.address} twice',
        );
      }

      if (isNative) {
        sawNative = true;
        if (t.decimals != chain.nativeDecimals) {
          throw RegistryFormatException(
            '${chain.name} native token declares ${t.decimals} decimals but '
            'the chain declares ${chain.nativeDecimals}',
          );
        }
      }

      tokens.add(
        TokenInfo(
          ref: ref,
          symbol: t.symbol,
          name: t.name,
          decimals: t.decimals,
          source: TokenSource.registry,
          isEnabled: t.status == _enabledStatus,
          checksumAddress: checksum,
          iconUrl: t.icon,
          coingeckoId: t.coingeckoId,
          tradingSymbol: t.tradingSymbol,
          sortOrder: i,
        ),
      );
    }

    // Every chain must be able to show its own gas token, even if the file
    // forgot to list it.
    if (!sawNative) {
      tokens.insert(
        0,
        TokenInfo(
          ref: AssetRef.native(chain.chainId),
          symbol: chain.nativeSymbol,
          name: chain.nativeSymbol,
          decimals: chain.nativeDecimals,
          source: TokenSource.registry,
          iconUrl: chain.iconUrl,
          sortOrder: -1,
        ),
      );
    }

    tokens.sort((a, b) {
      if (a.isNative != b.isNative) return a.isNative ? -1 : 1;
      return a.sortOrder.compareTo(b.sortOrder);
    });
    return List.unmodifiable(tokens);
  }

  /// The file's `derivationPath` is the path of account index 0 and must never
  /// be used to derive account n — that is what [KeyDerivation.pathFor] is for.
  /// All this checks is that the chain really is EVM-shaped.
  static void _validateDerivationPath(ChainConfigDto dto, int chainId) {
    final expected = "m/44'/${KeyDerivation.coinType}'/";
    if (!dto.derivationPath.startsWith(expected)) {
      throw RegistryFormatException(
        'chain $chainId (${dto.chainName}) has derivationPath '
        '"${dto.derivationPath}", which is not coin type '
        '${KeyDerivation.coinType}. This app derives EVM addresses only.',
      );
    }
  }

  static void _validateDecimals(int decimals, String where) {
    if (decimals < 0 || decimals > _maxDecimals) {
      throw RegistryFormatException(
        '$where declares $decimals decimals, outside 0..$_maxDecimals',
      );
    }
  }

  static String _stripTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
