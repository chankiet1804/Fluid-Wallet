import 'dart:io';

import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/balance_repository.dart';
import 'package:fluid_wallet/data/repositories/chain_registry_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives a captured Alchemy response through the exact parsing the app uses.
/// No network, no Flutter binding.
void main() {
  late ChainRegistry registry;
  late Map<String, ChainInfo> bySlug;

  setUpAll(() {
    registry = const ChainRegistryRepository().parse(
      File(ChainRegistryRepository.assetPath).readAsStringSync(),
    );
    bySlug = {
      for (final c in registry.chains)
        if (c.alchemyNetwork != null) c.alchemyNetwork!: c,
    };
  });

  Map<AssetRef, BigInt> parse(Map<String, dynamic> data) {
    final into = <AssetRef, BigInt>{};
    BalanceRepository.parsePage(data, bySlug, into);
    return into;
  }

  test('a null tokenAddress becomes the native asset', () {
    final out = parse({
      'tokens': [
        {
          'network': 'base-mainnet',
          'address': '0xabc',
          'tokenAddress': null,
          'tokenBalance': '0x0de0b6b3a7640000', // 1e18
        },
      ],
    });

    expect(out[AssetRef.native(8453)], BigInt.parse('1000000000000000000'));
  });

  test('an ERC-20 lands under its lower-cased address', () {
    const usdc = '0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913';
    final out = parse({
      'tokens': [
        {
          'network': 'base-mainnet',
          'address': '0xabc',
          'tokenAddress': usdc,
          'tokenBalance': '0x0f4240', // 1_000_000 = 1 USDC at 6 decimals
        },
      ],
    });

    final ref = AssetRef(8453, usdc);
    expect(out[ref], BigInt.from(1000000));
    expect(ref.address, usdc.toLowerCase());
    // And the registry types it at 6 decimals, not 18.
    expect(registry.token(ref)!.decimals, 6);
  });

  test('a balance beyond 2^63 parses exactly', () {
    final out = parse({
      'tokens': [
        {
          'network': 'eth-mainnet',
          'address': '0xabc',
          'tokenAddress': null,
          'tokenBalance': '0xFFFFFFFFFFFFFFFFFF',
        },
      ],
    });

    expect(
      out[AssetRef.native(1)],
      BigInt.parse('FFFFFFFFFFFFFFFFFF', radix: 16),
    );
  });

  test('an unknown network slug is skipped, not guessed at', () {
    final out = parse({
      'tokens': [
        {
          'network': 'solana-mainnet',
          'address': '0xabc',
          'tokenAddress': null,
          'tokenBalance': '0x64',
        },
      ],
    });

    expect(out, isEmpty);
  });

  test('zero balances are dropped', () {
    final out = parse({
      'tokens': [
        {
          'network': 'base-mainnet',
          'address': '0xabc',
          'tokenAddress': null,
          'tokenBalance': '0x0',
        },
      ],
    });

    expect(out, isEmpty);
  });

  test('malformed entries do not take the page down with them', () {
    final out = parse({
      'tokens': [
        'not an object',
        {'network': 'base-mainnet'},
        {'network': 'base-mainnet', 'tokenBalance': 42},
        {
          'network': 'base-mainnet',
          'tokenAddress': null,
          'tokenBalance': '0x64',
        },
      ],
    });

    expect(out, hasLength(1));
    expect(out[AssetRef.native(8453)], BigInt.from(100));
  });

  test('pageKey is returned so the caller can continue, or stop', () {
    expect(
      BalanceRepository.parsePage(
        {'tokens': const [], 'pageKey': 'next'},
        bySlug,
        {},
      ),
      'next',
    );
    expect(
      BalanceRepository.parsePage({'tokens': const []}, bySlug, {}),
      isNull,
    );
  });

  test('parseHexBalance tolerates the shapes the API actually sends', () {
    expect(BalanceRepository.parseHexBalance('0x'), BigInt.zero);
    expect(BalanceRepository.parseHexBalance(''), BigInt.zero);
    expect(BalanceRepository.parseHexBalance('0X1f'), BigInt.from(31));
    expect(BalanceRepository.parseHexBalance('1f'), BigInt.from(31));
    expect(BalanceRepository.parseHexBalance('zz'), BigInt.zero);
  });
}
