import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_feedback.dart';
import 'package:site_buddy/core/errors/app_error.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// CLASS: AppErrorHandler
/// PURPOSE: Centralized utility for mapping backend/logic failures to user-friendly UI feedback.
class AppErrorHandler {
  AppErrorHandler._();

  /// METHOD: handle
  /// PURPOSE: Logs the error and displays a modal dialog to the user if context is available.
  /// RETURNS: The mapped AppError for further state updates.
  static AppError handle(
    BuildContext? context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final AppError appError = _mapToAppError(error);

    // Log the error for internal debugging
    AppLogger.error('Handled Error: ${appError.message}', tag: 'ErrorHandler', error: appError.originalError);

    // Trigger UI feedback if context is present
    if (context != null) {
      SbFeedback.showDialog(
        context: context,
        title: 'Error',
        content: Text(appError.message),
        confirmLabel: onRetry != null ? 'Retry' : 'Close',
        onConfirm: onRetry,
      );
    }

    return appError;
  }

  /// Internal mapper logic separating technical jargon from engineering context.
  static AppError _mapToAppError(dynamic error) {
    if (error is AppError) return error;

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('socket') || errorStr.contains('http')) {
      return NetworkError(message: error.toString());
    }

    if (errorStr.contains('hive') ||
        errorStr.contains('database') ||
        errorStr.contains('shared_preferences')) {
      return DatabaseError(message: error.toString());
    }

    if (errorStr.contains('unit') || errorStr.contains('conversion')) {
      return ConversionError(message: error.toString());
    }

    if (errorStr.contains('ai') ||
        errorStr.contains('parse') ||
        errorStr.contains('assistant')) {
      return AiProcessingError(message: error.toString());
    }

    return UnknownError(message: error.toString());
  }
}



