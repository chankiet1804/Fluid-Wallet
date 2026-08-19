import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_meta.freezed.dart';
part 'wallet_meta.g.dart';

/// How a wallet entered the app. Kept as metadata because later flows branch on
/// it — an imported wallet, for instance, should not nag about backing up a
/// phrase the user already holds.
enum WalletSource { created, imported }

/// One derived account. Phase 1 always has exactly one (index 0), but the list
/// shape is here from the start: adding accounts later must not require a
/// storage migration on a device holding real funds.
@freezed
abstract class AccountMeta with _$AccountMeta {
  const factory AccountMeta({
    required String id,
    required int index,

    /// EIP-55 checksummed.
    required String address,
    String? name,
  }) = _AccountMeta;

  factory AccountMeta.fromJson(Map<String, dynamic> json) =>
      _$AccountMetaFromJson(json);
}

/// Everything about a wallet that is safe to store unencrypted. The mnemonic
/// itself lives in [SecureStore] under `wallet_mnemonic_<id>` and never appears
/// in this model.
@freezed
abstract class WalletMeta with _$WalletMeta {
  const factory WalletMeta({
    required String id,
    required WalletSource source,
    required List<AccountMeta> accounts,
    String? name,
    @Default(false) bool isBackedUp,
  }) = _WalletMeta;

  factory WalletMeta.fromJson(Map<String, dynamic> json) =>
      _$WalletMetaFromJson(json);
}

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default([]) List<WalletMeta> wallets,
    String? currentWalletId,
    String? currentAccountId,
  }) = _WalletState;

  const WalletState._();

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  bool get hasWallet => wallets.isNotEmpty;

  WalletMeta? get currentWallet {
    for (final wallet in wallets) {
      if (wallet.id == currentWalletId) return wallet;
    }
    return wallets.isEmpty ? null : wallets.first;
  }

  /// The account every feature must read its address from. Never hardcode an
  /// address or pass one down a constructor — switching accounts has to be a
  /// single state change that rebuilds everything downstream.
  AccountMeta? get currentAccount {
    final wallet = currentWallet;
    if (wallet == null || wallet.accounts.isEmpty) return null;
    for (final account in wallet.accounts) {
      if (account.id == currentAccountId) return account;
    }
    return wallet.accounts.first;
  }
}
