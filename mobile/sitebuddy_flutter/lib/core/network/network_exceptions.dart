import 'package:equatable/equatable.dart';

/// Base exception for all network-related issues.
abstract class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => '$runtimeType: $message (Status: $statusCode)';
}

/// Thrown when no internet connection is detected.
class NetworkUnavailableException extends NetworkException {
  const NetworkUnavailableException([super.message = 'No internet connection available.']);
}

/// Thrown when an API request times out.
class ApiTimeoutException extends NetworkException {
  const ApiTimeoutException([super.message = 'Request timed out. Please try again.']);
}

/// Thrown when the server returns a 5xx error.
class ApiServerException extends NetworkException {
  const ApiServerException({String message = 'Internal server error.', int? statusCode})
      : super(message, statusCode: statusCode);
}

/// Thrown when the response format is unexpected or cannot be parsed.
class InvalidResponseException extends NetworkException {
  const InvalidResponseException([super.message = 'Invalid response received from server.']);
}

/// Thrown when the server returns 4xx error (Unauthorized, Forbidden, etc).
class ApiClientException extends NetworkException {
  const ApiClientException({required String message, int? statusCode})
      : super(message, statusCode: statusCode);
}
