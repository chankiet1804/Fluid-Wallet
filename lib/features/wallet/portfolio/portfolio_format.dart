import '../../../core/money/money.dart';
import '../../../data/chain/chain.dart';

/// A portfolio total, plus whether it can be trusted as complete.
typedef PortfolioTotal = ({String text, bool isPartial});

/// Formats the headline balance.
///
/// Takes the whole [PortfolioSnapshot], not its `FiatValue`, on purpose: that is
/// what makes the incomplete case impossible to format away. A chain that timed
/// out drops its holdings from the sum, and a confident "$412.80" where the user
/// expects "$690" reads as theft, not as a network error.
PortfolioTotal formatPortfolioTotal(PortfolioSnapshot snapshot) {
  final text = FiatFormat.format(
    snapshot.total.value,
    currency: snapshot.currency,
  );
  if (snapshot.isComplete) return (text: text, isPartial: false);
  return (text: '≥ $text', isPartial: true);
}

/// One line naming what is missing, or null when nothing is.
String? portfolioIncompleteReason(
  PortfolioSnapshot snapshot,
  ChainRegistry registry,
) {
  final parts = <String>[];

  if (snapshot.failures.isNotEmpty) {
    final names = snapshot.failures
        .map((f) => registry.chain(f.chainId)?.name ?? 'chain ${f.chainId}')
        .toSet()
        .toList();
    parts.add(
      names.length == 1
          ? '${names.single} is unavailable'
          : '${names.length} networks are unavailable',
    );
  }

  if (snapshot.unpricedCount > 0) {
    parts.add(
      snapshot.unpricedCount == 1
          ? '1 token has no price'
          : '${snapshot.unpricedCount} tokens have no price',
    );
  }

  if (snapshot.unresolved.isNotEmpty) {
    parts.add(
      snapshot.unresolved.length == 1
          ? '1 token could not be identified'
          : '${snapshot.unresolved.length} tokens could not be identified',
    );
  }

  if (parts.isEmpty) return null;
  return '${parts.join(' · ')} — this total is a lower bound.';
}
