import 'package:freezed_annotation/freezed_annotation.dart';

import 'asset_ref.dart';

part 'price_query.freezed.dart';

/// The set of assets to price.
///
/// A Riverpod `.family` argument, so it needs stable value equality — [refs] is
/// sorted and deduplicated by the constructor, which means the same portfolio
/// composition hits the cache instead of refetching just because the balance
/// list came back in a different order.
@freezed
abstract class PriceQuery with _$PriceQuery {
  const factory PriceQuery.sorted({
    required List<AssetRef> refs,
    required String currency,
  }) = _PriceQuery;

  const PriceQuery._();

  factory PriceQuery(Iterable<AssetRef> refs, {String currency = 'usd'}) {
    final unique = refs.toSet().toList()
      ..sort(
        (a, b) => a.chainId != b.chainId
            ? a.chainId.compareTo(b.chainId)
            : a.address.compareTo(b.address),
      );
    return PriceQuery.sorted(
      refs: List.unmodifiable(unique),
      currency: currency,
    );
  }

  bool get isEmpty => refs.isEmpty;
}
