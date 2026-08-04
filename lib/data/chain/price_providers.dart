import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money/money.dart';
import '../../core/network/api_config.dart';
import '../../core/network/network_providers.dart';
import '../repositories/price_repository.dart';
import 'asset_ref.dart';
import 'chain_providers.dart';
import 'price_query.dart';

final priceRepositoryProvider = Provider<PriceRepository>(
  (ref) => PriceRepository(
    ref.watch(coingeckoDioProvider),
    ref.watch(chainRegistryProvider),
  ),
);

/// Prices for one exact set of assets.
///
/// Held past the last listener for [ApiConfig.priceTtl]. Without that, Riverpod
/// 3's auto-dispose drops the cache on every tab switch and the CoinGecko free
/// tier is gone in minutes.
///
/// An asset with no price is an absent key, never a zero — see
/// [PriceRepository].
final pricesProvider =
    FutureProvider.family<Map<AssetRef, FiatPrice>, PriceQuery>((
      ref,
      query,
    ) async {
      final link = ref.keepAlive();
      final timer = Timer(ApiConfig.priceTtl, link.close);
      ref.onDispose(timer.cancel);

      return ref.watch(priceRepositoryProvider).fetch(query);
    });
