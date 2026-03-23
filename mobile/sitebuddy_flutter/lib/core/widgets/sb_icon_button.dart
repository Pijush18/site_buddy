import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// WIDGET: SBIconButton
/// PURPOSE: Standardized icon-only button component.
///
/// SIZES:
/// - compact: 36x36px (for toolbars, inline actions)
/// - default: 44x44px (standard icon button)
/// - large: 56x56px (prominent actions)
///
/// RULES:
/// - Fixed size (no flexible width/height)
/// - Ripple/inkwell feedback included
/// - Uses theme colors for icon
/// - Optional tooltip for accessibility
enum SBIconButtonSize {
  compact,
  defaultSize,
  large,
}

/// WIDGET: SBIconButton
class SBIconButton extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button size
  final SBIconButtonSize size;

  /// Optional tooltip text
  final String? tooltip;

  /// Whether to show loading state
  final bool isLoading;

  /// Optional icon color override
  final Color? iconColor;

  /// Optional background color
  final Color? backgroundColor;

  const SBIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = SBIconButtonSize.defaultSize,
    this.tooltip,
    this.isLoading = false,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    // Calculate dimensions
    final double buttonSize = _getSize();
    final double iconSize = _getIconSize();

    Widget buttonContent;

    if (isLoading) {
      buttonContent = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            iconColor ?? colorScheme.primary,
          ),
        ),
      );
    } else {
      buttonContent = Icon(
        icon,
        size: iconSize,
        color: isEnabled
            ? (iconColor ?? colorScheme.primary)
            : colorScheme.onSurface.withValues(alpha: 0.38),
      );
    }

    Widget button = SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: IconButton(
        icon: buttonContent,
        onPressed: isEnabled ? _handlePressed : null,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: buttonSize,
          minHeight: buttonSize,
        ),
        splashRadius: buttonSize / 2,
      ),
    );

    // Apply background if provided
    if (backgroundColor != null) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(buttonSize / 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: button,
      );
    }

    return button;
  }

  double _getSize() {
    switch (size) {
      case SBIconButtonSize.compact:
        return 36.0;
      case SBIconButtonSize.defaultSize:
        return 44.0;
      case SBIconButtonSize.large:
        return 56.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case SBIconButtonSize.compact:
        return 18.0;
      case SBIconButtonSize.defaultSize:
        return 22.0;
      case SBIconButtonSize.large:
        return 28.0;
    }
  }

  void _handlePressed() {
    HapticFeedback.lightImpact();
    onPressed?.call();
  }

  // Convenience constructors

  /// Creates a compact icon button
  factory SBIconButton.compact({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return SBIconButton(
      icon: icon,
      onPressed: onPressed,
      size: SBIconButtonSize.compact,
      tooltip: tooltip,
    );
  }

  /// Creates a large icon button
  factory SBIconButton.large({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    Color? iconColor,
  }) {
    return SBIconButton(
      icon: icon,
      onPressed: onPressed,
      size: SBIconButtonSize.large,
      tooltip: tooltip,
      iconColor: iconColor,
    );
  }
}