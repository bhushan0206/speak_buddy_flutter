import 'package:flutter/material.dart';
import '../logging/app_logger.dart';

class AppErrorHandler {
  static void handleError(
    BuildContext context,
    dynamic error,
    StackTrace? stackTrace, {
    String? errorContext,
    bool showSnackBar = true,
  }) {
    // Log the error
    AppLogger.logError(errorContext ?? 'Unknown', error, stackTrace);

    // Show user-friendly error message
    if (showSnackBar && errorContext != null) {
      _showErrorSnackBar(context, _getUserFriendlyMessage(error));
    }
  }

  static String _getUserFriendlyMessage(dynamic error) {
    if (error is String) {
      return error;
    }

    // Handle common error types
    if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    } else if (error.toString().contains('auth')) {
      return 'Authentication error. Please try signing in again.';
    } else if (error.toString().contains('permission')) {
      return 'Permission denied. Please check your settings.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static Widget buildErrorWidget({
    required String message,
    required VoidCallback onRetry,
    String? retryText,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryText ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
