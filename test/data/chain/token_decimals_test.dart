import 'dart:io';

import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/chain_registry_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the decimals that are easiest to get wrong.
///
/// **If this test fails because someone "made the stablecoins consistent", the
/// fix is to revert that change, not this test.** USDT and USDC really are 18
/// decimals on BNB Smart Chain and 6 everywhere else in this registry. Treating
/// the BSC pair as 6 understates a balance by a factor of 10^12; treating the
/// others as 18 overstates it by the same amount.
void main() {
  late ChainRegistry registry;

  setUpAll(() {
    registry = const ChainRegistryRepository().parse(
      File(ChainRegistryRepository.assetPath).readAsStringSync(),
    );
  });

  /// (chainId, address, symbol, expected decimals)
  const cases = <(int, String, String, int)>[
    // The trap: BNB Smart Chain's bridged stablecoins are 18.
    (56, '0x55d398326f99059ff775485246999027b3197955', 'USDT', 18),
    (56, '0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d', 'USDC', 18),
    (56, '0xe9e7cea3dedca5984780bafc599bd69add087d56', 'BUSD', 18),

    // Everywhere else, 6.
    (1, '0xdac17f958d2ee523a2206206994597c13d831ec7', 'USDT', 6),
    (1, '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48', 'USDC', 6),
    (1, '0x68749665ff8d2d112fa859aa293f07a622782f38', 'XAUT', 6),
    (8453, '0x833589fcd6edb6e08f4c7c32d4f71b54bda02913', 'USDC', 6),
    (8453, '0xfde4c96c8593536e31f229ea8f37b2ada2699bb2', 'USDT', 6),
    (42161, '0xaf88d065e77c8cc2239327c5edb3a432268e5831', 'USDC', 6),
    (42161, '0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9', 'USDT', 6),
    (10, '0x0b2c639c533813f4aa9d7837caf62653d097ff85', 'USDC', 6),
    (137, '0xc2132d05d31c914a87c6611c10748aeb04b58e8f', 'USDT', 6),
    (43114, '0xb97ef9ef8734c71904d8002f8b6bc66dd9c48a6e', 'USDC', 6),
    (59144, '0x176211869ca2b568f2a7d4ee941e073a821ee1ff', 'USDC', 6),
  ];

  for (final (chainId, address, symbol, decimals) in cases) {
    test('$symbol on chain $chainId is $decimals decimals', () {
      final token = registry.token(AssetRef(chainId, address));
      expect(token, isNotNull, reason: '$symbol missing from chain $chainId');
      expect(token!.symbol, symbol);
      expect(token.decimals, decimals);
    });
  }

  test('the same symbol really does differ by chain', () {
    // Stated as its own assertion so the intent survives a future edit to the
    // table above.
    final onBsc = registry.token(
      AssetRef(56, '0x55d398326f99059ff775485246999027b3197955'),
    )!;
    final onEthereum = registry.token(
      AssetRef(1, '0xdac17f958d2ee523a2206206994597c13d831ec7'),
    )!;

    expect(onBsc.symbol, onEthereum.symbol);
    expect(onBsc.decimals, isNot(onEthereum.decimals));
  });

  test('a stablecoin is never priced by symbol', () {
    // Eight USDT contracts, several distinct CoinGecko ids. Matching on the
    // symbol would hand one chain's price to another chain's asset.
    final usdtIds = <String>{
      for (final chain in registry.chains)
        for (final token in registry.tokensOf(chain.chainId))
          if (token.symbol == 'USDT' && token.coingeckoId != null)
            token.coingeckoId!,
    };
    expect(usdtIds.length, greaterThan(1));
  });
}
