import 'package:equatable/equatable.dart';

/// SEALED CLASS: AppError
/// PURPOSE: Defines a strictly typed hierarchy for all site engineering related failures.
sealed class AppError extends Equatable implements Exception {
  final String message;
  final String? originalError;

  const AppError({required this.message, this.originalError});

  @override
  List<Object?> get props => [message, originalError];

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  const NetworkError({
    super.message = 'Network connection failed. Please check your signal.',
  });
}

class DatabaseError extends AppError {
  const DatabaseError({super.message = 'Failed to access local site data.'});
}

class ConversionError extends AppError {
  const ConversionError({super.message = 'Invalid unit conversion requested.'});
}

class AiProcessingError extends AppError {
  const AiProcessingError({
    super.message = 'Smart Assistant failed to resolve that query.',
  });
}

class UnknownError extends AppError {
  const UnknownError({super.message = 'An unexpected error occurred.'});
}
