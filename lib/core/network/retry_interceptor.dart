import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Retries transient failures with exponential backoff and jitter.
///
/// Safe here because every request this app sends through Dio is a read. The
/// Alchemy balance endpoint is a POST but is semantically a query, and nothing
/// that moves funds goes anywhere near this interceptor — signing and
/// broadcasting use their own path and must never be replayed.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    this.maxDelay = const Duration(seconds: 8),
  });

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;

  static const _attemptKey = 'retry_attempt';
  final _random = Random();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;
    final failure = ApiException.from(err);

    if (attempt >= maxRetries || !failure.isRetryable) {
      return handler.next(err);
    }

    await Future<void>.delayed(_delayFor(attempt, err.response));

    final options = err.requestOptions..extra[_attemptKey] = attempt + 1;

    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Duration _delayFor(int attempt, Response<dynamic>? response) {
    // A 429 that names its own cooldown wins: ignoring Retry-After turns a soft
    // throttle into a ban.
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter != null) {
      final seconds = int.tryParse(retryAfter.trim());
      if (seconds != null && seconds > 0) {
        return Duration(seconds: min(seconds, maxDelay.inSeconds));
      }
    }

    final backoff = baseDelay * pow(2, attempt).toDouble();
    final capped = backoff > maxDelay ? maxDelay : backoff;
    // Jitter so several chains failing together do not retry in lockstep.
    final jitter = (capped.inMilliseconds * 0.3 * _random.nextDouble()).round();
    return Duration(milliseconds: capped.inMilliseconds + jitter);
  }
}
