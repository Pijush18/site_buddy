import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

/// WIDGET: SBButton
/// PURPOSE: Single unified button system replacing all button implementations.
///
/// VARIANTS:
/// - primary: Filled button with primary color (default)
/// - secondary: Filled button with surface color
/// - outlined: Button with outline border, transparent background
/// - danger: Red filled button for destructive actions
///
/// RULES:
/// - Fixed height (48px for primary/secondary/danger, 44px for outlined)
/// - Consistent padding (horizontal SbSpacing.lg = 16px)
/// - Uses SbSpacing for spacing values
/// - Uses Theme colors (no hardcoded colors)
/// - Every button must have onPressed (no dead buttons)
enum SBButtonVariant {
  primary,
  secondary,
  outlined,
  danger,
}

/// WIDGET: SBButton
/// USAGE: Replace all ElevatedButton, OutlinedButton, TextButton usage
class SBButton extends StatelessWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed (REQUIRED - no dead buttons)
  final VoidCallback? onPressed;

  /// Button variant (primary, secondary, outlined, danger)
  final SBButtonVariant variant;

  /// Optional leading icon
  final IconData? icon;

  /// Optional trailing icon
  final IconData? trailingIcon;

  /// Whether to show loading state
  final bool isLoading;

  /// Whether button is disabled (alternative to null onPressed)
  final bool isDisabled;

  /// Optional custom width
  final double? width;

  /// Whether button is compact (reduced height)
  final bool compact;

  const SBButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SBButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = !isDisabled && onPressed != null && !isLoading;

    // Calculate dimensions
    final height = compact
        ? (variant == SBButtonVariant.outlined ? 36.0 : 40.0)
        : (variant == SBButtonVariant.outlined ? 44.0 : 48.0);

    // Build content
    Widget content = _buildContent(colorScheme, isEnabled);

    // Build button based on variant
    return SizedBox(
      width: width,
      height: height,
      child: _buildButton(
        context,
        content,
        isEnabled,
        colorScheme,
        height,
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, bool isEnabled) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingColor(colorScheme),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: _getContentColor(colorScheme, isEnabled),
          ),
          const SizedBox(width: SbSpacing.sm),
        ],
        Text(
          label,
          style: SbTypography.label.copyWith(
            color: _getContentColor(colorScheme, isEnabled),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: SbSpacing.sm),
          Icon(
            trailingIcon,
            size: 20,
            color: _getContentColor(colorScheme, isEnabled),
          ),
        ],
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    Widget content,
    bool isEnabled,
    ColorScheme colorScheme,
    double height,
  ) {
    switch (variant) {
      case SBButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled ? _handlePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: Size(0, height),
            elevation: isEnabled ? 2 : 0,
            shadowColor: colorScheme.primary.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SbRadius.standard),
            ),
          ),
          child: content,
        );

      case SBButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? _handlePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.onSurface,
            minimumSize: Size(0, height),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SbRadius.standard),
            ),
          ),
          child: content,
        );

      case SBButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? _handlePressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            minimumSize: Size(0, height),
            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SbRadius.standard),
            ),
            side: BorderSide(color: colorScheme.outline),
          ),
          child: content,
        );

      case SBButtonVariant.danger:
        return ElevatedButton(
          onPressed: isEnabled ? _handlePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            minimumSize: Size(0, height),
            elevation: isEnabled ? 2 : 0,
            shadowColor: colorScheme.error.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SbRadius.standard),
            ),
          ),
          child: content,
        );
    }
  }

  void _handlePressed() {
    HapticFeedback.lightImpact();
    onPressed?.call();
  }

  Color _getContentColor(ColorScheme colorScheme, bool isEnabled) {
    if (!isEnabled) {
      return colorScheme.onSurface.withValues(alpha: 0.38);
    }

    switch (variant) {
      case SBButtonVariant.primary:
        return colorScheme.onPrimary;
      case SBButtonVariant.secondary:
        return colorScheme.onSurface;
      case SBButtonVariant.outlined:
        return colorScheme.primary;
      case SBButtonVariant.danger:
        return colorScheme.onError;
    }
  }

  Color _getLoadingColor(ColorScheme colorScheme) {
    switch (variant) {
      case SBButtonVariant.primary:
        return colorScheme.onPrimary;
      case SBButtonVariant.secondary:
        return colorScheme.onSurface;
      case SBButtonVariant.outlined:
        return colorScheme.primary;
      case SBButtonVariant.danger:
        return colorScheme.onError;
    }
  }

  // Convenience constructors

  /// Creates a primary button (filled, primary color)
  factory SBButton.primary({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return SBButton(
      label: label,
      onPressed: onPressed,
      variant: SBButtonVariant.primary,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  /// Creates an outlined button (transparent background)
  factory SBButton.outlined({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return SBButton(
      label: label,
      onPressed: onPressed,
      variant: SBButtonVariant.outlined,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  /// Creates a danger button (red, for destructive actions)
  factory SBButton.danger({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return SBButton(
      label: label,
      onPressed: onPressed,
      variant: SBButtonVariant.danger,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }
}