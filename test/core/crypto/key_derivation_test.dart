import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/core/crypto/key_derivation.dart';
import 'package:fluid_wallet/core/crypto/mnemonic.dart';

/// Official BIP39 vectors from trezor/python-mnemonic (`vectors.json`), which
/// use the passphrase "TREZOR". If these drift, every address the wallet has
/// ever shown is wrong and any funds sent to them are unrecoverable.
void main() {
  const mnemonicService = MnemonicService();
  const derivation = KeyDerivation();

  const zero12 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon about';
  const zero24 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon abandon abandon abandon abandon art';

  group('BIP39 test vectors (trezor/python-mnemonic)', () {
    const entropyVectors = [
      (entropy: '00000000000000000000000000000000', mnemonic: zero12),
      (
        entropy: '7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f',
        mnemonic:
            'legal winner thank year wave sausage worth useful legal winner '
            'thank yellow',
      ),
      (
        entropy:
            '0000000000000000000000000000000000000000000000000000000000000000',
        mnemonic: zero24,
      ),
    ];

    const seedVectors = [
      (
        mnemonic: zero12,
        seed:
            'c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f'
            '09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04',
      ),
      (
        mnemonic: zero24,
        seed:
            'bda85446c68413707090a52022edd26a1c9462295029f2e60cd7c4f2bbd3097170'
            'af7a4d73245cafa9c3cca8d561a7c3de6f5d4a10be8ed2a5e608d68f92fcc8',
      ),
    ];

    test('mnemonic derives from entropy exactly', () {
      for (final v in entropyVectors) {
        final generated = Bip39MnemonicGenerator()
            .fromEntropy(BytesUtils.fromHexString(v.entropy))
            .toStr();
        expect(generated, v.mnemonic, reason: 'entropy ${v.entropy}');
      }
    });

    test('seed derives from mnemonic exactly (passphrase "TREZOR")', () {
      for (final v in seedVectors) {
        final seed = Bip39SeedGenerator(
          Mnemonic.fromString(v.mnemonic),
        ).generate('TREZOR');
        expect(BytesUtils.toHexString(seed), v.seed, reason: v.mnemonic);
      }
    });

    test('every vector mnemonic passes checksum validation', () {
      for (final v in entropyVectors) {
        expect(mnemonicService.isValid(v.mnemonic), isTrue, reason: v.mnemonic);
      }
    });
  });

  group('BIP44 derivation', () {
    test('account 0 matches the known address for the test mnemonic', () {
      expect(
        derivation.deriveAddress(zero12),
        '0x9858EfFD232B4033E47d90003D41EC34EcaEda94',
      );
    });

    test('address is EIP-55 checksummed, not all lowercase', () {
      final address = derivation.deriveAddress(zero12);
      expect(address, isNot(address.toLowerCase()));
    });

    test('path follows the MetaMask convention', () {
      expect(KeyDerivation.pathFor(0), "m/44'/60'/0'/0/0");
      expect(KeyDerivation.pathFor(3), "m/44'/60'/0'/0/3");
    });

    test('account index changes the address', () {
      expect(
        derivation.deriveAddress(zero12),
        isNot(derivation.deriveAddress(zero12, accountIndex: 1)),
      );
    });

    test('derivation is deterministic across calls', () {
      expect(
        derivation.deriveAddress(zero12),
        derivation.deriveAddress(zero12),
      );
    });

    test('a 24-word mnemonic derives too', () {
      final address = derivation.deriveAddress(zero24);
      expect(address, startsWith('0x'));
      expect(address.length, 42);
    });

    test('private key is 32 bytes of hex', () {
      final key = derivation.derivePrivateKeyHex(zero12);
      expect(key, startsWith('0x'));
      expect(key.length, 66);
    });
  });

  group('mnemonic validation', () {
    test('rejects a phrase with a broken checksum', () {
      // Valid words, valid count, wrong checksum — the classic typo case.
      const broken =
          'abandon abandon abandon abandon abandon abandon abandon abandon '
          'abandon abandon abandon abandon';
      expect(mnemonicService.isValid(broken), isFalse);
    });

    test('rejects a word that is not in the wordlist', () {
      expect(
        mnemonicService.isValid(zero12.replaceFirst('about', 'zzzz')),
        isFalse,
      );
    });

    test('rejects empty and whitespace-only input', () {
      expect(mnemonicService.isValid(''), isFalse);
      expect(mnemonicService.isValid('   '), isFalse);
    });

    test('normalizes casing and runs of whitespace', () {
      final messy =
          '  ABANDON\n abandon   abandon abandon abandon abandon '
          'abandon abandon abandon abandon abandon\tABOUT  ';
      expect(mnemonicService.normalize(messy), zero12);
      expect(mnemonicService.isValid(messy), isTrue);
    });

    test('generate() produces a valid 12-word mnemonic', () {
      final generated = mnemonicService.generate();
      expect(mnemonicService.words(generated).length, 12);
      expect(mnemonicService.isValid(generated), isTrue);
    });

    test('generate() produces a different mnemonic each time', () {
      expect(mnemonicService.generate(), isNot(mnemonicService.generate()));
    });
  });
}
