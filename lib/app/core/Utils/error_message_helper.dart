// lib/app/core/utils/error_message_helper.dart

class ErrorMessageHelper {
  /// Converts technical error messages to user-friendly ones
  static String getUserFriendlyMessage(String technicalError) {

    final lowerError = technicalError;

    // Network errors
    if (lowerError.contains('no internet') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('network error')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (lowerError.contains('timeout') ||
        lowerError.contains('timed out')) {
      return 'Request took too long. Please try again.';
    }

    if (lowerError.contains('connection refused') ||
        lowerError.contains('failed to connect')) {
      return 'Unable to connect to server. Please try again later.';
    }

    // Authentication errors
    if (lowerError.contains('unauthorized') ||
        lowerError.contains('401')) {
      return 'Your session has expired. Please login again.';
    }

    if (lowerError.contains('forbidden') ||
        lowerError.contains('403')) {
      return 'You don\'t have permission to access this.';
    }

    // Resource errors
    if (lowerError.contains('not found') ||lowerError.contains('Not found') ||
        lowerError.contains('404')) {
      return 'The requested information was not found.';
    }

    // Server errors
    if (lowerError.contains('500') ||
        lowerError.contains('server error') ||
        lowerError.contains('internal server')) {
      return 'Something went wrong on our end. Please try again later.';
    }

    if (lowerError.contains('503') ||
        lowerError.contains('service unavailable')) {
      return 'Service is temporarily unavailable. Please try again later.';
    }

    // Validation errors
    if (lowerError.contains('validation') ||
        lowerError.contains('invalid')) {
      return 'Please check your input and try again.';
    }

    // Data errors
    if (lowerError.contains('parse') ||
        lowerError.contains('json') ||
        lowerError.contains('format')) {
      return 'Unable to process the response. Please try again.';
    }

    // Rate limiting
    if (lowerError.contains('too many requests') ||
        lowerError.contains('429')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    // Default message for unknown errors
    return 'Something went wrong. Please try again.';
  }

  /// Gets an actionable suggestion based on error type
  static String? getActionableSuggestion(String technicalError) {
    final lowerError = technicalError.toLowerCase();

    if (lowerError.contains('no internet') ||
        lowerError.contains('network')) {
      return '• Check your WiFi or mobile data\n• Try switching networks';
    }

    if (lowerError.contains('timeout')) {
      return '• Check your internet speed\n• Try again in a moment';
    }

    if (lowerError.contains('unauthorized')) {
      return '• You\'ll need to login again';
    }

    if (lowerError.contains('server') || lowerError.contains('500')) {
      return '• Our team has been notified\n• Please try again in a few minutes';
    }

    return null;
  }
}