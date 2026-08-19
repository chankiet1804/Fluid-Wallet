import 'dart:isolate';

import 'package:blockchain_utils/blockchain_utils.dart';

/// BIP44 derivation for Base (an EVM chain, so coin type 60).
///
/// Path convention is MetaMask's: account n is `m/44'/60'/0'/0/n`, incrementing
/// the address index. Ledger Live increments the account level instead
/// (`m/44'/60'/n'/0/0`) — switching convention later would move every derived
/// address, stranding funds at addresses whose key we no longer produce.
class KeyDerivation {
  const KeyDerivation();

  static const int coinType = 60;

  /// The path this service derives, for display and for asserting in tests.
  static String pathFor(int accountIndex) =>
      "m/44'/$coinType'/0'/0/$accountIndex";

  /// EIP-55 checksummed address. `toAddress` runs the keccak checksum encoder,
  /// so the result is safe to compare against MetaMask verbatim.
  String deriveAddress(String mnemonic, {int accountIndex = 0}) {
    return _derive(mnemonic, accountIndex).publicKey.toAddress;
  }

  /// [deriveAddress] run on a background isolate.
  ///
  /// BIP39 seed generation is PBKDF2-HMAC-SHA512 over 2048 rounds of pure Dart.
  /// On the UI isolate it freezes the very frame that is supposed to show the
  /// progress spinner, so wallet creation and import must use this variant.
  ///
  /// The phrase does not leave the process — a spawned isolate is still this
  /// app's memory, not storage, a log, or a channel.
  Future<String> deriveAddressAsync(String mnemonic, {int accountIndex = 0}) {
    return Isolate.run(() => _deriveAddressOffThread(mnemonic, accountIndex));
  }

  /// Hex private key, `0x`-prefixed, for a single signing call.
  ///
  /// Callers must use the result immediately and let it go out of scope — it
  /// must never reach provider state, storage, a log, or the clipboard. Only
  /// the mnemonic is persisted; every key is re-derived on demand.
  String derivePrivateKeyHex(String mnemonic, {int accountIndex = 0}) {
    final raw = _derive(mnemonic, accountIndex).privateKey.raw;
    return '0x${BytesUtils.toHexString(raw)}';
  }

  Bip44 _derive(String mnemonic, int accountIndex) {
    final seed = Bip39SeedGenerator(Mnemonic.fromString(mnemonic)).generate();
    return Bip44.fromSeed(seed, Bip44Coins.ethereum).purpose.coin
        .account(0)
        .change(Bip44Changes.chainExt)
        .addressIndex(accountIndex);
  }
}

/// Top-level so the isolate closure captures only the two arguments.
String _deriveAddressOffThread(String mnemonic, int accountIndex) {
  return const KeyDerivation().deriveAddress(
    mnemonic,
    accountIndex: accountIndex,
  );
}
