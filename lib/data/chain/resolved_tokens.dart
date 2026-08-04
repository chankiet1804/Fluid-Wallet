import 'package:freezed_annotation/freezed_annotation.dart';

import 'token_balance.dart';

part 'resolved_tokens.freezed.dart';

/// Raw balances after every contract has been identified — or explicitly not.
///
/// The split is the safety property: [balances] are holdings whose `decimals`
/// came from the registry or a metadata lookup, and [unresolved] are the ones
/// where it did not. Nothing in between exists, so there is no path by which an
/// unknown token acquires a default scale.
@freezed
abstract class ResolvedTokens with _$ResolvedTokens {
  const factory ResolvedTokens({
    @Default(<TokenBalance>[]) List<TokenBalance> balances,
    @Default(<UnresolvedAsset>[]) List<UnresolvedAsset> unresolved,
  }) = _ResolvedTokens;
}
