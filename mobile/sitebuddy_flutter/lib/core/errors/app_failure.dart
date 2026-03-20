/// FILE HEADER
/// ----------------------------------------------
/// File: app_failure.dart
/// Feature: core
/// Layer: domain
///
/// PURPOSE:
/// Strongly typed failure model for handling predictable application errors.
///
/// RESPONSIBILITIES:
/// - Replaces generic String error messages with structured objects.
/// - Allows error codes for future analytics or localization logic.
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Add subclasses for NetworkFailure, ValidationFailure, CacheFailure, etc.
/// ----------------------------------------------
library;


/// CLASS: AppFailure
/// PURPOSE: Standard error payload emitted by Domain or Application layers.
/// WHY: Facilitates uniform error UI rendering and easy debugging.
class AppFailure {
  final String message;
  final String? code;

  const AppFailure(this.message, {this.code});

  @override
  String toString() => 'AppFailure(message: $message, code: $code)';
}



