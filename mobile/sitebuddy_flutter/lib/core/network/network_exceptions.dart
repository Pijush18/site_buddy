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

/// Thrown when the server returns a 5xx error.
class ServerException extends NetworkException {
  const ServerException({
    String message = 'Internal server error. Please try again later.',
    super.statusCode,
  }) : super(message);
}

/// Thrown when the server returns a 401 error.
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    String message = 'Session expired or unauthorized. Please sign in again.',
    super.statusCode = 401,
  }) : super(message);
}

/// Thrown when an API request times out.
class TimeoutException extends NetworkException {
  const TimeoutException([
    super.message = 'Request timed out. Please check your internet and try again.',
  ]);
}

/// Thrown when no internet connection is detected.
class ConnectionException extends NetworkException {
  const ConnectionException([
    super.message = 'No internet connection detected.',
  ]);
}

/// Generic client-side exception (4xx excluding 401).
class ClientException extends NetworkException {
  const ClientException({required String message, super.statusCode})
      : super(message);
}



