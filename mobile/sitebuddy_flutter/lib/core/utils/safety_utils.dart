import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/enums/safety_status.dart';

/// Helper class for mapping SafetyStatus to visual elements.
class SafetyUtils {
  SafetyUtils._();

  /// Returns the label associated with the safety status.
  static String getLabel(SafetyStatus status) {
    switch (status) {
      case SafetyStatus.safe:
        return 'SAFE';
      case SafetyStatus.warning:
        return 'WARNING';
      case SafetyStatus.fail:
        return 'CRITICAL FAIL';
    }
  }

  /// Returns the primary color associated with the safety status.
  static Color getColor(SafetyStatus status) {
    switch (status) {
      case SafetyStatus.safe:
        return Colors.green;
      case SafetyStatus.warning:
        return Colors.orange;
      case SafetyStatus.fail:
        return Colors.red;
    }
  }

  /// Returns a light background color associated with the safety status.
  static Color getBackgroundColor(SafetyStatus status) {
    return getColor(status).withValues(alpha: 0.1);
  }

  /// Returns an icon associated with the safety status.
  static IconData getIcon(SafetyStatus status) {
    switch (status) {
      case SafetyStatus.safe:
        return SbIcons.check;
      case SafetyStatus.warning:
        return SbIcons.warning;
      case SafetyStatus.fail:
        return SbIcons.error;
    }
  }
}
