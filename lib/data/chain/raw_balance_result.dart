import 'package:freezed_annotation/freezed_annotation.dart';

import 'asset_ref.dart';
import 'portfolio_snapshot.dart';

part 'raw_balance_result.freezed.dart';

/// Untyped balances straight off the balance API.
///
/// Raw [BigInt] only — no `decimals` has been applied yet, because the token has
/// not been identified yet. Keeping the two steps apart is what stops a missing
/// scale from silently defaulting to 18.
///
/// [failures] carries per-chain outcomes so a partial fetch stays partial all
/// the way to the UI instead of collapsing into a smaller-looking total.
@freezed
abstract class RawBalanceResult with _$RawBalanceResult {
  const factory RawBalanceResult({
    required Map<AssetRef, BigInt> balances,
    required DateTime fetchedAt,
    @Default(<ChainFailure>[]) List<ChainFailure> failures,
  }) = _RawBalanceResult;

  const RawBalanceResult._();

  bool get isComplete => failures.isEmpty;
}
