import 'package:dio/dio.dart';

/// Why a request failed, in terms the UI can act on.
enum ApiFailureKind {
  network,
  timeout,
  rateLimited,
  unauthorized,
  server,
  parse,
  notConfigured,
  unknown,
}

/// A transport failure, classified.
///
/// Deliberately carries no response body: an Alchemy error echoes the request
/// URL, and that URL contains the API key.
class ApiException implements Exception {
  const ApiException(this.kind, {this.statusCode, this.detail});

  final ApiFailureKind kind;
  final int? statusCode;
  final String? detail;

  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is! DioException) {
      return ApiException(ApiFailureKind.unknown, detail: error.toString());
    }

    final status = error.response?.statusCode;
    final kind = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ApiFailureKind.timeout,
      DioExceptionType.connectionError => ApiFailureKind.network,
      DioExceptionType.badResponse => switch (status) {
        401 || 403 => ApiFailureKind.unauthorized,
        429 => ApiFailureKind.rateLimited,
        final s? when s >= 500 => ApiFailureKind.server,
        _ => ApiFailureKind.unknown,
      },
      _ => ApiFailureKind.unknown,
    };

    return ApiException(kind, statusCode: status, detail: error.message);
  }

  bool get isRetryable =>
      kind == ApiFailureKind.timeout ||
      kind == ApiFailureKind.network ||
      kind == ApiFailureKind.rateLimited ||
      kind == ApiFailureKind.server;

  @override
  String toString() =>
      'ApiException(${kind.name}${statusCode == null ? '' : ' $statusCode'})';
}
