import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_radius.dart';

/// Standard button variants for the SiteBuddy Design System.
enum SBButtonVariant {
  primary,
  secondary,
  ghost,
}

/// A standardized button component for the SiteBuddy application.
/// 
/// Support primary and secondary variants, icons, and consistent styling
/// using [AppSpacing] and [AppRadius].
class SBButton extends StatelessWidget {
  /// The text label displayed on the button.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Callback function when the button is pressed.
  final VoidCallback? onPressed;

  /// The visual style variant of the button.
  final SBButtonVariant variant;

  /// Whether the button should take up the full width of its container.
  final bool fullWidth;

  /// Whether to show a loading indicator instead of the label/icon.
  final bool isLoading;

  const SBButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = SBButtonVariant.primary,
    this.fullWidth = false,
    this.isLoading = false,
  });

  /// Factory constructor for a primary button.
  const SBButton.primary({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.isLoading = false,
  }) : variant = SBButtonVariant.primary;

  /// Factory constructor for a secondary button.
  const SBButton.secondary({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.isLoading = false,
  }) : variant = SBButtonVariant.secondary;

  /// Factory constructor for a ghost/text button.
  const SBButton.ghost({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.isLoading = false,
  }) : variant = SBButtonVariant.ghost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isPrimary = variant == SBButtonVariant.primary;

    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
            disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            elevation: 0,
          )
        : variant == SBButtonVariant.secondary
            ? OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.outline),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                elevation: 0,
              )
            : TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? colorScheme.onPrimary : colorScheme.primary,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );

    if (fullWidth) {
      content = SizedBox(
        width: double.infinity,
        child: content,
      );
    }

    if (variant == SBButtonVariant.primary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      );
    } else if (variant == SBButtonVariant.secondary) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      );
    } else {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      );
    }
  }
}
