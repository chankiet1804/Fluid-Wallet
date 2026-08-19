import 'dart:convert';
import 'dart:io';

import 'package:blockchain_utils/blockchain_utils.dart' show EthAddrUtils;
import 'package:fluid_wallet/core/crypto/key_derivation.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/chain_registry_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parses the REAL `assets/config/chains-default.json`, not a fixture.
///
/// That file is hand-edited to add chains and tokens, and a single wrong
/// character in an address sends funds to somewhere nobody holds a key for.
/// This test is the only thing standing between a typo and that outcome, so it
/// has to read the shipped file.
///
/// Uses `dart:io` rather than `rootBundle` so it stays a plain Dart test with no
/// Flutter binding to boot.
void main() {
  late String source;
  late ChainRegistry registry;

  setUpAll(() {
    source = File(ChainRegistryRepository.assetPath).readAsStringSync();
    registry = const ChainRegistryRepository().parse(source);
  });

  test('the shipped registry parses and validates', () {
    expect(registry.chains, isNotEmpty);
  });

  test('chain ids are unique and parse as integers', () {
    final ids = registry.allChains.map((c) => c.chainId).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate chainId');
    expect(ids, everyElement(greaterThan(0)));
  });

  test('every bundled network icon path exists on disk', () {
    for (final asset in kBundledNetworkIcons.values) {
      expect(File(asset).existsSync(), isTrue, reason: '$asset is missing');
    }
  });

  test('every chain resolves an icon — bundled or remote', () {
    for (final chain in registry.chains) {
      expect(
        chain.bundledIconAsset ?? chain.iconUrl,
        isNotNull,
        reason: '${chain.name} would render with no mark at all',
      );
    }
  });

  test('no API key is committed in the registry file', () {
    // A 32+ character hex or base58-ish run in an rpcUrl is almost certainly a
    // key that was pasted in and never taken back out.
    final suspicious = RegExp(r'/v2/[A-Za-z0-9_-]{20,}');
    expect(
      suspicious.hasMatch(source),
      isFalse,
      reason: 'chains-default.json looks like it contains an embedded API key',
    );
  });

  group('tokens', () {
    test('addresses are canonical and pass EIP-55', () {
      for (final chain in registry.chains) {
        for (final token in registry.tokensOf(chain.chainId)) {
          expect(token.ref.address, token.ref.address.toLowerCase());
          expect(token.ref.address, hasLength(42));
          expect(token.ref.address.startsWith('0x'), isTrue);

          final checksum = token.checksumAddress;
          if (checksum == null) {
            expect(token.isNative, isTrue);
            continue;
          }
          expect(checksum.toLowerCase(), token.ref.address);
          expect(checksum, EthAddrUtils.toChecksumAddress(checksum));
        }
      }
    });

    test('no chain lists the same address twice', () {
      for (final chain in registry.chains) {
        final refs = registry
            .tokensOf(chain.chainId)
            .map((t) => t.ref)
            .toList();
        expect(refs.toSet().length, refs.length, reason: chain.name);
      }
    });

    test('every chain has exactly one native token, matching the chain', () {
      for (final chain in registry.chains) {
        final natives = registry
            .tokensOf(chain.chainId)
            .where((t) => t.isNative)
            .toList();
        expect(natives, hasLength(1), reason: chain.name);
        expect(natives.single.decimals, chain.nativeDecimals);
        expect(natives.single.symbol, chain.nativeSymbol);
      }
    });

    test('native is always first in the list', () {
      for (final chain in registry.chains) {
        expect(registry.tokensOf(chain.chainId).first.isNative, isTrue);
      }
    });

    test('lookup is case-insensitive on the address', () {
      final token = registry
          .tokensOf(registry.chains.first.chainId)
          .firstWhere((t) => !t.isNative);
      final upper = AssetRef(
        token.chainId,
        token.checksumAddress!.toUpperCase(),
      );
      expect(registry.token(upper), token);
    });
  });

  group('capabilities', () {
    test('every enabled chain has a vendor mapping', () {
      for (final chain in registry.chains) {
        expect(
          chain.capabilities,
          isNotNull,
          reason:
              '${chain.name} (${chain.chainId}) has no entry in '
              'kChainCapabilities, so it can never show a balance. Add one or '
              'disable the chain in chains-default.json.',
        );
      }
    });

    test('alchemy network slugs are unique', () {
      final slugs = [
        for (final c in registry.chains)
          if (c.alchemyNetwork != null) c.alchemyNetwork!,
      ];
      expect(slugs.toSet().length, slugs.length);
    });
  });

  group('validation rejects bad data', () {
    List<Map<String, dynamic>> decode() =>
        (jsonDecode(source) as List).cast<Map<String, dynamic>>();

    String encodeWith(void Function(List<Map<String, dynamic>>) mutate) {
      final chains = decode();
      mutate(chains);
      return jsonEncode(chains);
    }

    test('a mistyped character in a checksummed address', () {
      final broken = encodeWith((chains) {
        final tokens = chains[0]['tokens'] as List;
        final token = tokens.firstWhere(
          (t) =>
              (t as Map)['address'] != AssetRef.native(1).address &&
              t['address'] != (t['address'] as String).toLowerCase(),
        );
        final address = (token as Map)['address'] as String;
        // Flip one hex digit while keeping the mixed casing that claims EIP-55.
        token['address'] =
            '${address.substring(0, address.length - 1)}'
            '${address.endsWith('0') ? '1' : '0'}';
      });

      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
    });

    test('a duplicate chain id', () {
      final broken = encodeWith((chains) => chains.add({...chains[0]}));
      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
    });

    test('a non-integer chain id', () {
      final broken = encodeWith((chains) => chains[0]['chainId'] = 'base');
      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
    });

    test('a non-EVM derivation path', () {
      // Coin type 60 is what makes an address an EVM address. Anything else
      // means the file describes a chain this app cannot derive keys for.
      final broken = encodeWith(
        (chains) => chains[0]['derivationPath'] = "m/44'/501'/0'/0/0",
      );
      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
      expect(KeyDerivation.coinType, 60);
    });

    test('decimals outside a sane range', () {
      final broken = encodeWith(
        (chains) => (chains[0]['tokens'] as List)[1]['decimals'] = 99,
      );
      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
    });

    test('a native token whose decimals disagree with its chain', () {
      final broken = encodeWith((chains) {
        final native = (chains[0]['tokens'] as List).firstWhere(
          (t) => (t as Map)['address'] == AssetRef.native(1).address,
        );
        (native as Map)['decimals'] = 6;
      });
      expect(
        () => const ChainRegistryRepository().parse(broken),
        throwsA(isA<RegistryFormatException>()),
      );
    });
  });
}
