import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/money/money.dart';
import 'token_balance.dart';

part 'portfolio_snapshot.freezed.dart';

enum ChainFailureKind { network, rateLimited, unauthorized, unsupported, parse }

/// Why one chain's slice of the portfolio is missing.
///
/// Carried as data rather than collapsed into an exception: the UI has to be
/// able to name the chain and offer a retry, not just say "something failed".
@freezed
abstract class ChainFailure with _$ChainFailure {
  const factory ChainFailure({
    required int chainId,
    required ChainFailureKind kind,
    String? message,
  }) = _ChainFailure;
}

/// Everything the portfolio screen renders, in one value.
///
/// The invariant that makes this safe: [total] is only meaningful when
/// [isComplete] is true. When a chain failed or a token had no price, the total
/// is a LOWER BOUND and the UI is required to render it differently. A wrong
/// total shown confidently is the worst failure mode this layer has — a user
/// whose balance drops 40% because one chain timed out will read it as theft.
@freezed
abstract class PortfolioSnapshot with _$PortfolioSnapshot {
  const factory PortfolioSnapshot({
    required String address,
    required List<TokenBalance> balances,
    required String currency,
    required DateTime fetchedAt,
    @Default(<UnresolvedAsset>[]) List<UnresolvedAsset> unresolved,
    @Default(<ChainFailure>[]) List<ChainFailure> failures,

    /// Balances that priced to null and are therefore absent from [total].
    @Default(0) int unpricedCount,
  }) = _PortfolioSnapshot;

  const PortfolioSnapshot._();

  factory PortfolioSnapshot.empty(String address, {String currency = 'USD'}) =>
      PortfolioSnapshot(
        address: address,
        balances: const [],
        currency: currency,
        fetchedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  /// Sum of every priced holding, in exact [Decimal] arithmetic end to end.
  FiatValue get total => FiatValue(
    currency: currency,
    value: balances.fold(
      Decimal.zero,
      (sum, b) => b.fiat == null ? sum : sum + b.fiat!.value,
    ),
  );

  /// False when anything was missing. Gate every confident presentation of
  /// [total] on this — see `formatPortfolioTotal`.
  bool get isComplete =>
      failures.isEmpty && unpricedCount == 0 && unresolved.isEmpty;

  bool get hasFailures => failures.isNotEmpty;

  List<TokenBalance> forChain(int chainId) =>
      balances.where((b) => b.chainId == chainId).toList(growable: false);

  /// The snapshot narrowed to one chain. Failures and unresolved assets are
  /// narrowed too, so a filtered view reports its own completeness rather than
  /// inheriting a failure from a chain it is not showing.
  PortfolioSnapshot filteredTo(int? chainId) {
    if (chainId == null) return this;
    final kept = balances.where((b) => b.chainId == chainId).toList();
    return copyWith(
      balances: kept,
      unresolved: unresolved.where((u) => u.ref.chainId == chainId).toList(),
      failures: failures.where((f) => f.chainId == chainId).toList(),
      unpricedCount: kept.where((b) => b.fiat == null).length,
    );
  }
}
