import 'package:fluid_wallet/core/crypto/key_derivation.dart';
import 'package:fluid_wallet/core/security/secure_store.dart';
import 'package:fluid_wallet/data/repositories/wallet_repository.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Derivation on the calling isolate, for widget tests only.
///
/// The app derives on a spawned isolate so 2048 rounds of PBKDF2 never freeze
/// the frame that shows the progress spinner. A `testWidgets` body runs inside
/// a fake async zone that never pumps the real event loop, so the isolate's
/// reply never arrives and the await hangs until the ten-minute test timeout.
///
/// Same BIP39 seed, same BIP44 path, same addresses — only the thread differs.
/// Anything asserting derivation itself belongs in `test/core/crypto/`, which
/// runs the real async variant outside a widget binding.
class SyncKeyDerivation extends KeyDerivation {
  const SyncKeyDerivation();

  @override
  Future<String> deriveAddressAsync(String mnemonic, {int accountIndex = 0}) =>
      Future.value(deriveAddress(mnemonic, accountIndex: accountIndex));
}

/// A repository that seeds the keystore without hanging a widget test.
WalletRepository syncWalletRepository(FlutterSecureStorage storage) =>
    WalletRepository(
      secureStore: SecureStore(storage),
      storage: storage,
      derivation: const SyncKeyDerivation(),
    );

/// Same repository, for the app under test: create and import driven through
/// the UI derive on this isolate too.
Override syncDerivationOverride(FlutterSecureStorage storage) =>
    walletRepositoryProvider.overrideWithValue(syncWalletRepository(storage));
