import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Standardized Button Metrics
const double _buttonHeight = 48.0;
const double _buttonHeightCompact = 32.0;
const double _iconSize = 20.0;

enum _SbButtonType { primary, secondary, outline, ghost, icon, compact }

@Deprecated('Use named constructors like SbButton.primary instead')
enum SbButtonVariant { primary, secondary, outline }

/// WIDGET: SbButton
/// PURPOSE: Standardized, universal button factory.
///
/// Features:
/// - Exact design tokens for sizes, colors, and margins.
/// - Integrated loading spinner states with proper contrast.
/// - Built-in light haptic feedback on every press.
class SbButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final String? tooltip;
  final _SbButtonType _type;

  const SbButton._({
    super.key,
    this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.tooltip,
    required _SbButtonType type,
  }) : _type = type;

  /// High elevation/contrast for main actions.
  const SbButton.primary({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
         type: _SbButtonType.primary,
       );

  /// Tonal/Surface-based for supporting actions.
  const SbButton.secondary({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
         type: _SbButtonType.secondary,
       );

  /// Bordered for neutral or secondary actions.
  const SbButton.outline({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
         type: _SbButtonType.outline,
       );

  /// Text-only button, replacing old TextButton.
  const SbButton.ghost({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
         type: _SbButtonType.ghost,
       );

  /// Square/Circular variant. Replaces raw IconButton. High hit-box uniformity (48px).
  const SbButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    String? tooltip,
    bool compact = false,
  }) : this._(
         key: key,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         tooltip: tooltip,
         width: compact ? 32.0 : null,
         type: _SbButtonType.icon,
       );

  /// Dense table rows or log entries (32px).
  const SbButton.compact({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         type: _SbButtonType.compact,
       );

  // Deprecated backward-compat constructors during migration.
  @Deprecated('Use SbButton.primary instead')
  const SbButton({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    // Add variant for simple migration back-compat initially before script replaces
    dynamic variant,
  }) : this._(
         key: key,
         label: label,
         icon: icon,
         onPressed: onPressed,
         isLoading: isLoading,
         width: width,
         type: _SbButtonType.primary,
       );

  void _handlePress() {
    if (isLoading || onPressed == null) return;
    HapticFeedback.lightImpact();
    onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the expected foreground color so the loading spinner matches
    Color loadingColor;
    switch (_type) {
      case _SbButtonType.primary:
        loadingColor = colorScheme.onPrimary;
        break;
      case _SbButtonType.secondary:
        loadingColor = colorScheme.onSecondaryContainer;
        break;
      case _SbButtonType.outline:
      case _SbButtonType.ghost:
      case _SbButtonType.icon:
      case _SbButtonType.compact:
        loadingColor = colorScheme.primary;
        break;
    }

    final spinner = SizedBox(
      height: _iconSize,
      width: _iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
      ),
    );

    switch (_type) {
      case _SbButtonType.primary:
        return SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, _buttonHeight)),
            child: isLoading ? spinner : _buildLabelRow(context),
          ),
        );
      case _SbButtonType.secondary:
        return SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              minimumSize: const Size(0, _buttonHeight),
            ),
            child: isLoading ? spinner : _buildLabelRow(context),
          ),
        );
      case _SbButtonType.outline:
        return SizedBox(
          width: width,
          child: OutlinedButton(
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, _buttonHeight)),
            child: isLoading ? spinner : _buildLabelRow(context),
          ),
        );
      case _SbButtonType.ghost:
        return SizedBox(
          width: width,
          child: TextButton(
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            style: TextButton.styleFrom(minimumSize: const Size(0, _buttonHeight)),
            child: isLoading ? spinner : _buildLabelRow(context),
          ),
        );
      case _SbButtonType.icon:
        // IconButton replacement ensuring 48x48 hit box minimum
        return SizedBox(
          height: _buttonHeight,
          width: _buttonHeight,
          child: IconButton(
            tooltip: tooltip,
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            iconSize: _iconSize,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: _buttonHeight,
              minHeight: _buttonHeight,
            ),
            icon: isLoading
                ? spinner
                : Icon(icon, color: colorScheme.primary),
          ),
        );
      case _SbButtonType.compact:
        return SizedBox(
          height: _buttonHeightCompact,
          child: TextButton(
            onPressed: (isLoading || onPressed == null) ? null : _handlePress,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
            ),
            child: isLoading ? spinner : _buildLabelRow(context),
          ),
        );
    }
  }

  Widget _buildLabelRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          if (label != null) const SizedBox(width: 8),
        ],
        if (label != null)
          Text(
            label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge!,
          ),
      ],
    );
  }
}







