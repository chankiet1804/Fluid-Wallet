import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over the OS keystore (Keychain on iOS, RSA-OAEP + AES-GCM on
/// Android). The app never encrypts anything itself — hand-rolled KDF/cipher
/// code is exactly how wallets leak seeds.
///
/// Phase 1 stores mnemonics unguarded: no passcode, no biometric prompt.
/// Anyone who can unlock the device can read the seed, so this build must not
/// hold more than pocket change. The gate lands in Phase 6 and wraps
/// [readMnemonic] without changing the key layout, so no migration is needed.
class SecureStore {
  const SecureStore(this._storage);

  factory SecureStore.standard() => const SecureStore(FlutterSecureStorage());

  final FlutterSecureStorage _storage;

  /// Per-wallet key. Deliberately not a single constant: a fixed key would
  /// force a one-shot migration on devices already holding real funds the day
  /// a second wallet is supported.
  static String mnemonicKey(String walletId) => 'wallet_mnemonic_$walletId';

  Future<void> writeMnemonic(String walletId, String mnemonic) {
    return _storage.write(key: mnemonicKey(walletId), value: mnemonic);
  }

  /// Returns the mnemonic for a single immediate use. Callers must not put the
  /// result into provider state, a log, analytics, or the clipboard.
  Future<String?> readMnemonic(String walletId) {
    return _storage.read(key: mnemonicKey(walletId));
  }

  Future<bool> hasMnemonic(String walletId) {
    return _storage.containsKey(key: mnemonicKey(walletId));
  }

  Future<void> deleteMnemonic(String walletId) {
    return _storage.delete(key: mnemonicKey(walletId));
  }

  /// Wipes every secret this app owns — used when the user deletes the wallet.
  Future<void> deleteAll() => _storage.deleteAll();
}
