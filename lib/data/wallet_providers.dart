import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/security/secure_store.dart';
import 'models/wallet_meta.dart';
import 'repositories/wallet_repository.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return WalletRepository(
    secureStore: SecureStore(storage),
    storage: storage,
  );
});

/// The wallet list plus which account is selected.
///
/// Holds metadata only — no mnemonic, no private key. Anything that needs the
/// phrase calls [WalletController.readMnemonic] at the moment of use.
class WalletController extends AsyncNotifier<WalletState> {
  @override
  Future<WalletState> build() => _repo.load();

  WalletRepository get _repo => ref.read(walletRepositoryProvider);

  Future<void> createWallet({String? name}) async {
    // No interim `AsyncValue.loading()`: it would drop `value` to null, which
    // the router's guard reads as "keystore not read yet". The create screen
    // renders its own spinner, so nothing needs the loading flag here.
    state = await AsyncValue.guard(() => _repo.createWallet(name: name));
  }

  Future<void> importWallet(String mnemonic, {String? name}) async {
    // Deliberately not wrapped in AsyncValue.guard: the import screen needs to
    // show a specific message per failure, so the exception must propagate.
    final next = await _repo.importWallet(mnemonic, name: name);
    state = AsyncValue.data(next);
  }

  Future<void> markBackedUp(String walletId) async {
    state = AsyncValue.data(await _repo.markBackedUp(walletId));
  }

  Future<void> switchAccount({
    required String walletId,
    required String accountId,
  }) async {
    state = AsyncValue.data(
      await _repo.switchAccount(walletId: walletId, accountId: accountId),
    );
  }

  Future<void> deleteWallet(String walletId) async {
    state = AsyncValue.data(await _repo.deleteWallet(walletId));
  }

  Future<void> reset() async {
    state = AsyncValue.data(await _repo.reset());
  }

  /// For one immediate use — showing the backup screen or signing. The result
  /// must not be put back into any provider.
  Future<String?> readMnemonic(String walletId) => _repo.readMnemonic(walletId);
}

final walletControllerProvider =
    AsyncNotifierProvider<WalletController, WalletState>(WalletController.new);

/// The one place any feature may read the active address from.
///
/// Never hardcode an address and never pass one down a constructor: switching
/// accounts must be a single state change that rebuilds everything below it.
/// Derived data (balances, history) belongs in `.family` providers keyed by
/// this address, not in singletons.
final currentAccountProvider = Provider<AccountMeta?>((ref) {
  return ref.watch(walletControllerProvider).value?.currentAccount;
});

final currentWalletProvider = Provider<WalletMeta?>((ref) {
  return ref.watch(walletControllerProvider).value?.currentWallet;
});
