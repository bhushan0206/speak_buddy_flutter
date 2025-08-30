import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.info,
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  static void logApiRequest(
    String method,
    String url,
    Map<String, dynamic>? headers,
    dynamic body,
  ) {
    debug('API Request: $method $url', null, null);
    if (headers != null) debug('Headers: $headers', null, null);
    if (body != null) debug('Body: $body', null, null);
  }

  static void logApiResponse(
    String method,
    String url,
    int statusCode,
    dynamic response,
  ) {
    debug('API Response: $method $url - Status: $statusCode', null, null);
    debug('Response: $response', null, null);
  }

  static void logError(String context, dynamic error, StackTrace? stackTrace) {
    error('Error in $context: $error', error, stackTrace);
  }
}
