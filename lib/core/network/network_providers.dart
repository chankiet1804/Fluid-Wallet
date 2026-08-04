import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_client.dart';

/// Alchemy client — balances and token metadata.
final alchemyDioProvider = Provider<Dio>((ref) {
  final dio = DioClients.alchemy();
  ref.onDispose(dio.close);
  return dio;
});

/// CoinGecko client — prices. Separate instance because its rate limit is an
/// order of magnitude tighter than Alchemy's.
final coingeckoDioProvider = Provider<Dio>((ref) {
  final dio = DioClients.coingecko();
  ref.onDispose(dio.close);
  return dio;
});
