import 'dart:convert';
import 'dart:math';

import 'package:blockchain_utils/blockchain_utils.dart' show Bip39WordsNum;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/crypto/key_derivation.dart';
import '../../core/crypto/mnemonic.dart';
import '../../core/security/secure_store.dart';
import '../models/wallet_meta.dart';

/// Owns wallet creation, import, and the metadata around it.
///
/// The single rule this class exists to enforce: the mnemonic goes into the OS
/// keystore and nowhere else. It is never returned into long-lived state, only
/// handed out by [readMnemonic] for an immediate use (showing the backup
/// screen, deriving a key to sign with).
class WalletRepository {
  WalletRepository({
    required SecureStore secureStore,
    required FlutterSecureStorage storage,
    MnemonicService mnemonicService = const MnemonicService(),
    KeyDerivation derivation = const KeyDerivation(),
  }) : _secureStore = secureStore,
       _storage = storage,
       _mnemonic = mnemonicService,
       _derivation = derivation;

  final SecureStore _secureStore;
  final FlutterSecureStorage _storage;
  final MnemonicService _mnemonic;
  final KeyDerivation _derivation;

  /// Wallet metadata holds no secrets, but it rides in the same store to avoid
  /// pulling in a second persistence package for one key.
  static const String _stateKey = 'wallets_meta_v1';

  Future<WalletState> load() async {
    final raw = await _storage.read(key: _stateKey);
    if (raw == null || raw.isEmpty) return const WalletState();
    try {
      return WalletState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      // Corrupt metadata must not brick the app: the mnemonic is the wallet and
      // it still sits in the keystore untouched.
      return const WalletState();
    }
  }

  Future<void> _save(WalletState state) {
    return _storage.write(key: _stateKey, value: jsonEncode(state.toJson()));
  }

  /// Generates a new mnemonic, derives account 0, and persists both.
  ///
  /// Returns the state only. The caller reads the phrase back through
  /// [readMnemonic] when it is time to show the backup screen, so the seed does
  /// not travel through a return value that might get held onto.
  Future<WalletState> createWallet({
    String? name,
    Bip39WordsNum wordsNum = MnemonicService.defaultWordsNum,
  }) async {
    final mnemonic = _mnemonic.generate(wordsNum: wordsNum);
    return _persistNewWallet(
      mnemonic: mnemonic,
      source: WalletSource.created,
      name: name,
    );
  }

  /// Imports an existing phrase. Throws [InvalidMnemonicException] on a bad
  /// checksum and [DuplicateWalletException] if the same wallet is already
  /// here — two entries for one address would desync balances and history.
  Future<WalletState> importWallet(String mnemonic, {String? name}) async {
    final normalized = _mnemonic.normalize(mnemonic);
    if (!_mnemonic.isValid(normalized)) {
      throw const InvalidMnemonicException();
    }

    final address = await _derivation.deriveAddressAsync(normalized);
    final existing = await load();
    final alreadyHere = existing.wallets.any(
      (wallet) => wallet.accounts.any(
        (account) =>
            account.address.toLowerCase() == address.toLowerCase(),
      ),
    );
    if (alreadyHere) throw const DuplicateWalletException();

    return _persistNewWallet(
      mnemonic: normalized,
      source: WalletSource.imported,
      name: name,
    );
  }

  Future<WalletState> _persistNewWallet({
    required String mnemonic,
    required WalletSource source,
    String? name,
  }) async {
    final walletId = _newId();
    final accountId = _newId();
    final account = AccountMeta(
      id: accountId,
      index: 0,
      address: await _derivation.deriveAddressAsync(mnemonic, accountIndex: 0),
    );

    // Secret first: if metadata were written first and this failed, the app
    // would show an address whose key does not exist.
    await _secureStore.writeMnemonic(walletId, mnemonic);

    final previous = await load();
    final next = previous.copyWith(
      wallets: [
        ...previous.wallets,
        WalletMeta(
          id: walletId,
          source: source,
          accounts: [account],
          name: name ?? _defaultWalletName(previous.wallets),
          // An imported wallet's phrase is already in the user's hands.
          isBackedUp: source == WalletSource.imported,
        ),
      ],
      currentWalletId: walletId,
      currentAccountId: accountId,
    );
    await _save(next);
    return next;
  }

  /// Marks the backup flow as completed. Only meaningful for created wallets.
  Future<WalletState> markBackedUp(String walletId) async {
    final state = await load();
    final next = state.copyWith(
      wallets: [
        for (final wallet in state.wallets)
          if (wallet.id == walletId)
            wallet.copyWith(isBackedUp: true)
          else
            wallet,
      ],
    );
    await _save(next);
    return next;
  }

  /// Switches the selected account. Phase 1 has nothing to switch to, but every
  /// downstream feature reads its address from the selection rather than from a
  /// hardcoded index — so multi-account is a UI addition, not a rewrite.
  Future<WalletState> switchAccount({
    required String walletId,
    required String accountId,
  }) async {
    final state = await load();
    final wallet = state.wallets.where((w) => w.id == walletId).firstOrNull;
    if (wallet == null) throw const WalletNotFoundException();
    if (!wallet.accounts.any((a) => a.id == accountId)) {
      throw const AccountNotFoundException();
    }

    final next = state.copyWith(
      currentWalletId: walletId,
      currentAccountId: accountId,
    );
    await _save(next);
    return next;
  }

  /// Hands out the phrase for one immediate use. Do not store the result.
  Future<String?> readMnemonic(String walletId) {
    return _secureStore.readMnemonic(walletId);
  }

  /// Removes a wallet along with its secret.
  Future<WalletState> deleteWallet(String walletId) async {
    await _secureStore.deleteMnemonic(walletId);
    final state = await load();
    final remaining =
        state.wallets.where((wallet) => wallet.id != walletId).toList();
    final fallback = remaining.firstOrNull;
    final next = WalletState(
      wallets: remaining,
      currentWalletId: state.currentWalletId == walletId
          ? fallback?.id
          : state.currentWalletId,
      currentAccountId: state.currentWalletId == walletId
          ? fallback?.accounts.firstOrNull?.id
          : state.currentAccountId,
    );
    await _save(next);
    return next;
  }

  /// Wipes everything — secrets and metadata.
  Future<WalletState> reset() async {
    await _secureStore.deleteAll();
    await _storage.delete(key: _stateKey);
    return const WalletState();
  }

  /// Default label for a wallet the user did not name.
  ///
  /// Numbered past the highest existing `Wallet n` rather than from the list
  /// length: deleting a wallet in the middle would otherwise mint a name that
  /// is already taken. The length is only a floor, so wallets stored before
  /// naming existed — they display as `Wallet ${index + 1}` — are not collided
  /// with either.
  static String _defaultWalletName(List<WalletMeta> wallets) {
    var highest = wallets.length;
    for (final wallet in wallets) {
      final match = _defaultNamePattern.firstMatch(wallet.name ?? '');
      final number = int.tryParse(match?.group(1) ?? '') ?? 0;
      if (number > highest) highest = number;
    }
    return 'Wallet ${highest + 1}';
  }

  static final RegExp _defaultNamePattern = RegExp(r'^Wallet (\d+)$');

  /// Random rather than time-based: two ids minted in the same microsecond
  /// would collide, and a wallet id is what addresses its stored secret.
  String _newId() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
  }
}

class InvalidMnemonicException implements Exception {
  const InvalidMnemonicException();
}

class DuplicateWalletException implements Exception {
  const DuplicateWalletException();
}

class WalletNotFoundException implements Exception {
  const WalletNotFoundException();
}

class AccountNotFoundException implements Exception {
  const AccountNotFoundException();
}
