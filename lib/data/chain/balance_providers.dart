import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money/money.dart';
import '../../core/network/api_config.dart';
import '../../core/network/network_providers.dart';
import '../repositories/balance_repository.dart';
import '../repositories/token_metadata_repository.dart';
import '../wallet_providers.dart';
import 'asset_ref.dart';
import 'chain_providers.dart';
import 'chain_registry.dart';
import 'portfolio_snapshot.dart';
import 'price_providers.dart';
import 'price_query.dart';
import 'raw_balance_result.dart';
import 'resolved_tokens.dart';
import 'token_balance.dart';
import 'token_info.dart';

final balanceRepositoryProvider = Provider<BalanceRepository>(
  (ref) => BalanceRepository(ref.watch(alchemyDioProvider)),
);

final tokenMetadataRepositoryProvider = Provider<TokenMetadataRepository>(
  (ref) => TokenMetadataRepository(ref.watch(alchemyDioProvider)),
);

/// Untyped balances for one wallet address, across every active chain.
///
/// Keyed by address, not by `(address, chainId)`. Alchemy takes up to twenty
/// networks for one address in a single request, so per-chain keying would turn
/// one round trip into eight, with eight retry timelines and eight times the
/// rate-limit pressure. Per-chain granularity lives in the *result*
/// ([RawBalanceResult.failures]), not in the key — which still satisfies the
/// overview §4.4 rule that nothing derived may be a singleton.
final rawBalancesProvider = FutureProvider.family<RawBalanceResult, String>((
  ref,
  address,
) async {
  final chains = ref.watch(activeChainsProvider);
  final repo = ref.watch(balanceRepositoryProvider);

  // Survive a tab switch, but not indefinitely: a backgrounded app must not
  // show yesterday's balance on resume.
  final link = ref.keepAlive();
  final timer = Timer(ApiConfig.balanceCacheTtl, link.close);
  ref.onDispose(timer.cancel);

  return repo.fetchBalances(address: address, chains: chains);
});

/// Joins raw balances to token identities.
///
/// The registry — `assets/config/chains-default.json` — is the token universe
/// (overview §4.7). The balance endpoint is a discovery API: it returns every
/// contract the address holds, spam included. Anything it returns that the file
/// does not list is dropped right here, so no metadata lookup and no
/// contract-address price call is ever made for it. Adding a token is a JSON
/// entry, never a code change.
///
/// Dropping those does NOT make the snapshot incomplete: the registry defines
/// what exists for this app, so an unlisted contract is not a missing fetch.
final resolvedTokensProvider = FutureProvider.family<ResolvedTokens, String>((
  ref,
  address,
) async {
  final raw = await ref.watch(rawBalancesProvider(address).future);
  final registry = ref.watch(chainRegistryProvider);

  final balances = <TokenBalance>[];

  for (final entry in raw.balances.entries) {
    final token = registry.token(entry.key);
    if (token == null) continue;
    balances.add(
      TokenBalance(
        token: token,
        amount: TokenAmount(raw: entry.value, decimals: token.decimals),
      ),
    );
  }

  return ResolvedTokens(balances: balances);
});

/// The composed portfolio — the only balance provider the UI should watch.
final portfolioProvider = FutureProvider.family<PortfolioSnapshot, String>((
  ref,
  address,
) async {
  final raw = await ref.watch(rawBalancesProvider(address).future);
  final resolved = await ref.watch(resolvedTokensProvider(address).future);
  final registry = ref.watch(chainRegistryProvider);

  final prices = resolved.balances.isEmpty
      ? const <AssetRef, FiatPrice>{}
      : await ref.watch(
          pricesProvider(
            PriceQuery(resolved.balances.map((b) => b.ref)),
          ).future,
        );

  var unpriced = 0;
  final priced = <TokenBalance>[];
  for (final balance in resolved.balances) {
    final price = prices[balance.ref];
    if (price == null) {
      unpriced++;
      priced.add(balance);
      continue;
    }
    priced.add(
      balance.copyWith(
        fiat: FiatValue(
          currency: price.currency,
          value: balance.amount.fiatValue(price.value),
        ),
      ),
    );
  }

  sortPortfolioBalances(priced, registry);

  return PortfolioSnapshot(
    address: address,
    balances: List.unmodifiable(priced),
    currency: 'USD',
    fetchedAt: raw.fetchedAt,
    unresolved: resolved.unresolved,
    failures: raw.failures,
    unpricedCount: unpriced,
  );
});

/// Address-free convenience for widgets.
///
/// Still a family underneath: this only reads [currentAccountProvider] and
/// forwards, so switching account rebuilds everything below it rather than
/// showing the previous account's balances (overview §4.4).
final currentPortfolioProvider = Provider<AsyncValue<PortfolioSnapshot>>((ref) {
  final account = ref.watch(currentAccountProvider);
  if (account == null) return const AsyncValue.loading();
  return ref.watch(portfolioProvider(account.address));
});

/// The snapshot narrowed to the selected chain, then filled out with the tokens
/// the registry lists but the address does not hold. Pure derivation — changing
/// the filter is a rebuild, not a fetch.
///
/// How much gets filled in depends on the view:
///
/// - **One chain:** every token the registry lists for it, so the filtered view
///   is the chain's full token set rather than only what happens to be funded.
/// - **All networks:** the native coin of each active chain and nothing else.
///   Every chain stays visible with its gas token even at zero, while the list
///   does not turn into a catalogue of every token on eight chains.
final visiblePortfolioProvider = Provider<AsyncValue<PortfolioSnapshot>>((ref) {
  final filter = ref.watch(chainFilterProvider);
  final registry = ref.watch(chainRegistryProvider);
  final active = ref.watch(activeChainsProvider);

  return ref.watch(currentPortfolioProvider).whenData((snapshot) {
    final filtered = snapshot.filteredTo(filter);
    if (filter != null) {
      return _padded(
        filtered,
        registry.tokensOf(filter),
        registry,
        sorted: false,
      );
    }
    return _padded(
      filtered,
      [
        for (final chain in active)
          ...registry.tokensOf(chain.chainId).where((t) => t.isNative),
      ],
      registry,
      sorted: true,
    );
  });
});

/// Appends [candidates] that [snapshot] has no balance for, at zero.
///
/// [sorted] re-runs the display order afterwards, which is what puts a
/// zero-balance native coin at the head of its own chain block instead of at the
/// end of the list. The single-chain view passes false on purpose: there the
/// empty tokens belong below the funded ones.
///
/// Two things this must not do:
///
/// - **Pad a chain that failed.** A token shown at `$0.00` for a chain the app
///   could not read is a balance it never saw, and §4.7 is explicit that a
///   failed fetch shows `—`, not zero. Failed chains are skipped here and the
///   screen keeps its error branch for them.
/// - **Price the padding as unknown.** Zero of anything is worth zero at every
///   possible unit price, so these carry an exact `Decimal.zero` rather than a
///   null. A null would raise `unpricedCount` and flip `isComplete`, making the
///   screen call a complete total a lower bound.
PortfolioSnapshot _padded(
  PortfolioSnapshot snapshot,
  List<TokenInfo> candidates,
  ChainRegistry registry, {
  required bool sorted,
}) {
  final failed = {for (final f in snapshot.failures) f.chainId};
  final held = {for (final b in snapshot.balances) b.ref};

  final missing = [
    for (final token in candidates)
      if (!failed.contains(token.chainId) && !held.contains(token.ref))
        TokenBalance(
          token: token,
          // The token's own decimals, never a default (§4.1).
          amount: TokenAmount.zero(token.decimals),
          fiat: FiatValue(currency: snapshot.currency, value: Decimal.zero),
        ),
  ];
  if (missing.isEmpty) return snapshot;

  final balances = [...snapshot.balances, ...missing];
  if (sorted) sortPortfolioBalances(balances, registry);

  return snapshot.copyWith(balances: List.unmodifiable(balances));
}

/// Pull-to-refresh.
///
/// Invalidates the fetch roots and lets metadata stay cached — a token's
/// `decimals` does not change. Returns a future the `RefreshIndicator` awaits.
Future<void> refreshPortfolio(WidgetRef ref) async {
  final address = ref.read(currentAccountProvider)?.address;
  if (address == null) return;

  ref.invalidate(rawBalancesProvider(address));
  // The whole price family: quotes are time-sensitive in a way balances are not.
  ref.invalidate(pricesProvider);

  await ref.read(portfolioProvider(address).future);
}

/// Orders a portfolio for display, in place.
void sortPortfolioBalances(
  List<TokenBalance> balances,
  ChainRegistry registry,
) => balances.sort((a, b) => _compareBalances(a, b, registry));

/// Chain block first, then verified, native, fiat value, symbol.
///
/// Chain leads so the list reads as one chain at a time instead of interleaving
/// eight of them by value — the chain order is the registry's own file order.
///
/// Sorting a discovered token below a registry one is a safety affordance, not
/// cosmetics: a contract calling itself `USDC` must never sit above the real
/// one, not even inside its own chain block.
int _compareBalances(TokenBalance a, TokenBalance b, ChainRegistry registry) {
  final chainOrder = (registry.chain(a.chainId)?.sortOrder ?? _lastChain)
      .compareTo(registry.chain(b.chainId)?.sortOrder ?? _lastChain);
  if (chainOrder != 0) return chainOrder;

  if (a.token.isVerified != b.token.isVerified) {
    return a.token.isVerified ? -1 : 1;
  }
  if (a.token.isNative != b.token.isNative) return a.token.isNative ? -1 : 1;

  final af = a.fiat?.value;
  final bf = b.fiat?.value;
  if (af != null && bf != null && af != bf) return bf.compareTo(af);
  if (af != null && bf == null) return -1;
  if (af == null && bf != null) return 1;

  return a.token.symbol.compareTo(b.token.symbol);
}

/// Sort position for a chain the registry does not know: last, never first.
const int _lastChain = 1 << 30;
