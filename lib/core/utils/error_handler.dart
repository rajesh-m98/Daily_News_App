import 'dart:io';

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Error handler utility
class ErrorHandler {
  /// Get user-friendly error message from exception
  static String getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error is HttpException) {
      return 'Server error. Please try again later.';
    } else if (error is FormatException) {
      return 'Invalid data format received.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Handle HTTP status codes
  static void handleStatusCode(int statusCode, String responseBody) {
    switch (statusCode) {
      case 200:
      case 201:
        // Success - do nothing
        break;
      case 400:
        throw ApiException('Bad request. Please check your input.', 400);
      case 401:
        throw ApiException('Unauthorized. Please check your API key.', 401);
      case 403:
        throw ApiException('Access forbidden. API key may be invalid.', 403);
      case 429:
        throw ApiException('API limit reached. Please try again later.', 429);
      case 500:
      case 502:
      case 503:
        throw ApiException('Server error. Please try again later.', statusCode);
      default:
        throw ApiException('Error: $responseBody', statusCode);
    }
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    return error is SocketException ||
        error.toString().contains('SocketException') ||
        error.toString().contains('network');
  }

  /// Check if error is API limit error
  static bool isApiLimitError(dynamic error) {
    return error is ApiException && error.statusCode == 429;
  }
}
