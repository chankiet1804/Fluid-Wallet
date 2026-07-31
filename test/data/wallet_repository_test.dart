import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/core/crypto/key_derivation.dart';
import 'package:fluid_wallet/core/security/secure_store.dart';
import 'package:fluid_wallet/data/models/wallet_meta.dart';
import 'package:fluid_wallet/data/repositories/wallet_repository.dart';

import '../support/fake_secure_storage.dart';

void main() {
  const zero12 =
      'abandon abandon abandon abandon abandon abandon abandon abandon '
      'abandon abandon abandon about';
  const zero12Address = '0x9858EfFD232B4033E47d90003D41EC34EcaEda94';

  late FakeSecureStorage storage;
  late WalletRepository repo;

  setUp(() {
    storage = FakeSecureStorage();
    repo = WalletRepository(
      secureStore: SecureStore(storage),
      storage: storage,
    );
  });

  group('createWallet', () {
    test('persists a wallet with one account and selects it', () async {
      final state = await repo.createWallet(name: 'Main');

      expect(state.wallets, hasLength(1));
      expect(state.wallets.single.accounts, hasLength(1));
      expect(state.wallets.single.source, WalletSource.created);
      expect(state.currentAccount, isNotNull);
      expect(state.currentAccount!.index, 0);
      expect(state.currentAccount!.address, startsWith('0x'));
    });

    test('a created wallet is not marked backed up yet', () async {
      final state = await repo.createWallet();
      expect(state.wallets.single.isBackedUp, isFalse);
    });

    test('the address matches the stored mnemonic', () async {
      final state = await repo.createWallet();
      final walletId = state.wallets.single.id;
      final mnemonic = await repo.readMnemonic(walletId);

      expect(mnemonic, isNotNull);
      const derivation = KeyDerivation();
      expect(
        derivation.deriveAddress(mnemonic!),
        state.currentAccount!.address,
      );
    });

    test('state survives a reload', () async {
      final created = await repo.createWallet();
      final reloaded = await repo.load();
      expect(reloaded.currentAccount!.address,
          created.currentAccount!.address);
    });
  });

  group('importWallet', () {
    test('derives the known address for the test mnemonic', () async {
      final state = await repo.importWallet(zero12);
      expect(state.currentAccount!.address, zero12Address);
      expect(state.wallets.single.source, WalletSource.imported);
    });

    test('an imported wallet counts as already backed up', () async {
      final state = await repo.importWallet(zero12);
      expect(state.wallets.single.isBackedUp, isTrue);
    });

    test('accepts a messy phrase (casing, extra whitespace)', () async {
      final state = await repo.importWallet('  ${zero12.toUpperCase()}  ');
      expect(state.currentAccount!.address, zero12Address);
    });

    test('rejects a bad checksum without writing anything', () async {
      const broken =
          'abandon abandon abandon abandon abandon abandon abandon abandon '
          'abandon abandon abandon abandon';
      await expectLater(
        repo.importWallet(broken),
        throwsA(isA<InvalidMnemonicException>()),
      );
      expect(await repo.load(), const WalletState());
      expect(storage.values, isEmpty);
    });

    test('rejects importing the same wallet twice', () async {
      await repo.importWallet(zero12);
      await expectLater(
        repo.importWallet(zero12),
        throwsA(isA<DuplicateWalletException>()),
      );
      final state = await repo.load();
      expect(state.wallets, hasLength(1));
    });
  });

  group('markBackedUp', () {
    test('flips the flag and persists it', () async {
      final created = await repo.createWallet();
      final walletId = created.wallets.single.id;

      await repo.markBackedUp(walletId);

      final reloaded = await repo.load();
      expect(reloaded.wallets.single.isBackedUp, isTrue);
    });
  });

  group('switchAccount', () {
    // Phase 1 ships one account, but the selection must already be data rather
    // than a hardcoded index — otherwise adding accounts later means rewriting
    // every feature that reads an address.
    test('changes the selected account and the address it exposes', () async {
      final created = await repo.createWallet();
      final walletId = created.wallets.single.id;
      final firstAccount = created.currentAccount!;

      // Simulate a second derived account without needing the UI for it.
      final mnemonic = (await repo.readMnemonic(walletId))!;
      const derivation = KeyDerivation();
      final secondAccount = AccountMeta(
        id: 'account-1',
        index: 1,
        address: derivation.deriveAddress(mnemonic, accountIndex: 1),
      );
      await _injectAccount(repo, storage, walletId, secondAccount);

      final switched = await repo.switchAccount(
        walletId: walletId,
        accountId: secondAccount.id,
      );

      expect(switched.currentAccount!.id, secondAccount.id);
      expect(switched.currentAccount!.address, secondAccount.address);
      expect(switched.currentAccount!.address, isNot(firstAccount.address));
    });

    test('survives a reload', () async {
      final created = await repo.createWallet();
      final walletId = created.wallets.single.id;
      final mnemonic = (await repo.readMnemonic(walletId))!;
      const derivation = KeyDerivation();
      final second = AccountMeta(
        id: 'account-1',
        index: 1,
        address: derivation.deriveAddress(mnemonic, accountIndex: 1),
      );
      await _injectAccount(repo, storage, walletId, second);
      await repo.switchAccount(walletId: walletId, accountId: second.id);

      final reloaded = await repo.load();
      expect(reloaded.currentAccount!.id, second.id);
    });

    test('rejects an unknown account', () async {
      final created = await repo.createWallet();
      await expectLater(
        repo.switchAccount(
          walletId: created.wallets.single.id,
          accountId: 'nope',
        ),
        throwsA(isA<AccountNotFoundException>()),
      );
    });

    test('rejects an unknown wallet', () async {
      await repo.createWallet();
      await expectLater(
        repo.switchAccount(walletId: 'nope', accountId: 'nope'),
        throwsA(isA<WalletNotFoundException>()),
      );
    });
  });

  group('deleteWallet', () {
    test('removes the secret along with the metadata', () async {
      final created = await repo.createWallet();
      final walletId = created.wallets.single.id;

      await repo.deleteWallet(walletId);

      expect(await repo.readMnemonic(walletId), isNull);
      expect((await repo.load()).wallets, isEmpty);
    });

    test('leaves other wallets untouched', () async {
      final first = await repo.createWallet(name: 'A');
      final firstId = first.wallets.single.id;
      final second = await repo.importWallet(zero12, name: 'B');
      final secondId = second.wallets.last.id;

      await repo.deleteWallet(firstId);

      final state = await repo.load();
      expect(state.wallets.map((w) => w.id), [secondId]);
      expect(await repo.readMnemonic(secondId), isNotNull);
    });
  });

  group('storage layout', () {
    test('mnemonic is keyed per wallet, not under a fixed key', () async {
      final state = await repo.createWallet();
      final walletId = state.wallets.single.id;

      expect(storage.values.keys, contains('wallet_mnemonic_$walletId'));
      expect(storage.values.keys, isNot(contains('mnemonic')));
    });

    test('metadata blob carries no mnemonic', () async {
      await repo.importWallet(zero12);
      final metadata = storage.values['wallets_meta_v1']!;

      expect(metadata, isNot(contains('abandon')));
      expect(metadata, contains(zero12Address));
    });

    test('corrupt metadata degrades to empty instead of throwing', () async {
      await repo.createWallet();
      storage.values['wallets_meta_v1'] = 'not json';
      expect(await repo.load(), const WalletState());
    });
  });
}

/// Writes an extra account straight into the persisted metadata. Stands in for
/// the "add account" flow, which has no UI in Phase 1.
Future<void> _injectAccount(
  WalletRepository repo,
  FakeSecureStorage storage,
  String walletId,
  AccountMeta account,
) async {
  final state = await repo.load();
  final updated = state.copyWith(
    wallets: [
      for (final wallet in state.wallets)
        if (wallet.id == walletId)
          wallet.copyWith(accounts: [...wallet.accounts, account])
        else
          wallet,
    ],
  );
  await storage.write(
    key: 'wallets_meta_v1',
    value: _encode(updated),
  );
}

String _encode(WalletState state) => jsonEncode(state.toJson());
