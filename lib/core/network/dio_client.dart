import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';
import 'rate_limiter.dart';
import 'retry_interceptor.dart';

/// Serialises requests through a [RateLimiter] before Dio sends them.
class RateLimitInterceptor extends Interceptor {
  RateLimitInterceptor(this._limiter);

  final RateLimiter _limiter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _limiter.run(() async {});
    handler.next(options);
  }
}

/// Debug-only request logging with the API key stripped out.
///
/// Dio's own `LogInterceptor` would print the full URL, and the Alchemy
/// Portfolio path embeds the key. Printing it to the console — and therefore
/// into any captured log or crash report — is the same class of mistake as
/// logging a mnemonic.
class RedactingLogInterceptor extends Interceptor {
  const RedactingLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '${options.method} ${_redact(options.uri.toString())}',
      name: 'net',
    );
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '${err.type.name} ${err.response?.statusCode ?? ''} '
      '${_redact(err.requestOptions.uri.toString())}',
      name: 'net',
    );
    handler.next(err);
  }

  static String _redact(String url) {
    var out = url;
    if (ApiConfig.alchemyKey.isNotEmpty) {
      out = out.replaceAll(ApiConfig.alchemyKey, '***');
    }
    if (ApiConfig.coingeckoKey.isNotEmpty) {
      out = out.replaceAll(ApiConfig.coingeckoKey, '***');
    }
    return out;
  }
}

/// Two clients, because the two upstreams have different limits and different
/// retry semantics. Sharing one would mean pacing Alchemy at CoinGecko's rate,
/// or hammering CoinGecko at Alchemy's.
abstract final class DioClients {
  static Dio alchemy() => _build(
    baseUrl: ApiConfig.alchemyDataBase,
    limiter: RateLimiter(maxConcurrent: ApiConfig.maxAddressNetworkPairs),
    maxRetries: 3,
    receiveTimeout: const Duration(seconds: 25),
  );

  static Dio coingecko() => _build(
    baseUrl: ApiConfig.coingeckoBase,
    limiter: RateLimiter(
      maxConcurrent: 1,
      minInterval: const Duration(milliseconds: 1500),
    ),
    maxRetries: 2,
    receiveTimeout: const Duration(seconds: 15),
    headers: ApiConfig.hasCoingeckoKey
        ? {'x-cg-demo-api-key': ApiConfig.coingeckoKey}
        : const {},
  );

  static Dio _build({
    required String baseUrl,
    required RateLimiter limiter,
    required int maxRetries,
    required Duration receiveTimeout,
    Map<String, String> headers = const {},
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: receiveTimeout,
        headers: {'accept': 'application/json', ...headers},
      ),
    );

    dio.interceptors.addAll([
      RateLimitInterceptor(limiter),
      RetryInterceptor(dio: dio, maxRetries: maxRetries),
      if (kDebugMode) const RedactingLogInterceptor(),
    ]);

    return dio;
  }
}
