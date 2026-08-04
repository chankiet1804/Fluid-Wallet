import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chain_info.dart';
import 'chain_registry.dart';

/// The parsed registry.
///
/// Overridden in `main()` with a value parsed before `runApp`, which is what
/// keeps every provider below it synchronous. Making this a `FutureProvider`
/// would force each balance, price and UI provider to thread an `AsyncValue`
/// through something that cannot fail after the first load — and if it does
/// fail, the app must not start at all.
final chainRegistryProvider = Provider<ChainRegistry>(
  (ref) => throw UnimplementedError(
    'chainRegistryProvider must be overridden in main() — see '
    'ChainRegistryRepository.load()',
  ),
);

/// Every chain the registry enables, in file order.
final supportedChainsProvider = Provider<List<ChainInfo>>(
  (ref) => ref.watch(chainRegistryProvider).chains,
);

/// Which chains are actually fetched.
///
/// Changing this refetches — it changes what data exists. Contrast with
/// [chainFilterProvider], which only changes what is displayed.
class EnabledChains extends Notifier<Set<int>> {
  @override
  Set<int> build() => {
    for (final c in ref.watch(supportedChainsProvider)) c.chainId,
  };

  void toggle(int chainId) {
    final next = {...state};
    if (!next.remove(chainId)) next.add(chainId);
    // Turning everything off would render an empty portfolio that looks like a
    // drained wallet. Refuse it.
    if (next.isEmpty) return;
    state = next;
  }

  void setAll(Set<int> chainIds) {
    if (chainIds.isEmpty) return;
    state = {...chainIds};
  }
}

final enabledChainsProvider = NotifierProvider<EnabledChains, Set<int>>(
  EnabledChains.new,
);

/// The chains the balance fan-out will actually ask for: enabled, and served by
/// a configured provider.
final activeChainsProvider = Provider<List<ChainInfo>>((ref) {
  final enabled = ref.watch(enabledChainsProvider);
  return ref
      .watch(supportedChainsProvider)
      .where((c) => enabled.contains(c.chainId))
      .toList(growable: false);
});

/// Enabled chains with no vendor integration. Surfaced so the UI can say why a
/// chain shows nothing instead of leaving a silent gap.
final unsupportedChainsProvider = Provider<List<ChainInfo>>(
  (ref) => ref
      .watch(activeChainsProvider)
      .where((c) => !c.supportsBalanceFetch)
      .toList(growable: false),
);

/// Display filter: null means "all chains".
///
/// Deliberately downstream of the fetch, so flipping it is an instant rebuild
/// and costs no request.
class ChainFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? chainId) => state = chainId;
}

final chainFilterProvider = NotifierProvider<ChainFilter, int?>(
  ChainFilter.new,
);
