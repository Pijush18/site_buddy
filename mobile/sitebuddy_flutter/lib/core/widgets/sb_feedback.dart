import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_button.dart';

/// CLASS: SbFeedback
/// PURPOSE: Centralized utility for user notifications and interaction dialogs.
/// Ensures consistent presentation of feedback across all modules.
class SbFeedback {
  SbFeedback._();

  /// Displays a standardized snackbar with consistent styling.
  static void showToast({
    required BuildContext context,
    required String message,
    bool isError = false,
    Duration? duration,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.body(context).copyWith(
            color: isError ? colorScheme.onError : colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: isError
            ? colorScheme.error
            : colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppLayout.sm)),
        ),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Displays a standardized modal dialog using Sb design tokens.
  static Future<T?> showDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showAdaptiveDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title, style: AppTextStyles.sectionTitle(context)),
          content: content,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.sm),
          ),
          actions: [
            if (cancelLabel != null || onCancel != null)
              SbButton.ghost(
                label: cancelLabel ?? 'Cancel',
                onPressed: onCancel ?? () => context.pop(),
              ),
            if (confirmLabel != null || onConfirm != null)
              SbButton.primary(
                label: confirmLabel ?? 'Confirm',
                onPressed: onConfirm,
              ),
          ],
        );
      },
    );
  }

  /// Displays a standardized bottom sheet using Sb design tokens.
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppLayout.sm)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
