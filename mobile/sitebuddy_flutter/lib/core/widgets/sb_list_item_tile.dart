import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/widgets/sb_interactive_card.dart';

/// ENUM: SbListItemVariant
/// Defines the visual style variants for list items.
enum SbListItemVariant {
  /// Standard list row with border and background.
  standard,

  /// Reduced padding for dense lists.
  compact,

  /// Wrapped in SbCard for emphasis.
  card,

  /// For future multi-select support.
  selectable,
}

/// ENUM: SbListItemStatus
/// Defines the status indicator type.
enum SbListItemStatus {
  /// No status indicator.
  none,

  /// Success status (green).
  success,

  /// Warning status (amber).
  warning,

  /// Error status (red).
  error,

  /// Info status (blue).
  info,
}

/// WIDGET: SbListItemTile
/// PURPOSE: Standardized list item UI enforcing global typography and spacing.
///
/// FEATURES:
/// - Leading section: icon, avatar, or custom widget
/// - Content section: title, subtitle, supporting text
/// - Trailing section: text, icon, chip, or custom widget
/// - Status indicator: colored dot/badge
/// - Multiple variants: standard, compact, card, selectable
///
/// USAGE:
/// ```dart
/// // Basic usage
/// SbListItemTile(
///   title: 'Project Name',
///   subtitle: 'Last updated: Jan 15',
///   onTap: () {},
/// )
///
/// // With icon and trailing
/// SbListItemTile(
///   icon: Icons.folder_outlined,
///   title: 'Documents',
///   trailing: '5 items',
///   onTap: () {},
/// )
///
/// // With status and chip
/// SbListItemTile(
///   icon: Icons.check_circle_outline,
///   title: 'Completed',
///   status: SbListItemStatus.success,
///   trailingChip: 'Done',
///   onTap: () {},
/// )
/// ```
class SbListItemTile extends StatelessWidget {
  /// Icon for the leading section.
  final IconData? icon;

  /// Avatar data (initials or image URL).
  final String? avatarText;
  final String? avatarImageUrl;

  /// Custom leading widget (overrides icon and avatar).
  final Widget? leading;

  /// Primary text (required).
  final String title;

  /// Secondary text below title.
  final String? subtitle;

  /// Third line of text (metadata, timestamps, etc.).
  final String? supportingText;

  /// Trailing content: string, widget, or chip.
  final dynamic trailing;
  final String? trailingChip;
  final Widget? trailingWidget;

  /// Status indicator type.
  final SbListItemStatus status;

  /// Interaction callbacks.
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Visual variants.
  final SbListItemVariant variant;

  /// Styling overrides.
  final Color? color;
  final Color? iconColor;
  final bool isSubtle;
  final bool isPrimary;

  /// Disable interaction.
  final bool isDisabled;

  /// Show chevron/arrow icon for navigation.
  final bool showChevron;

  /// Number of title lines.
  final int titleLines;

  /// Number of subtitle lines.
  final int subtitleLines;

  const SbListItemTile({
    super.key,
    this.icon,
    this.avatarText,
    this.avatarImageUrl,
    this.leading,
    required this.title,
    this.subtitle,
    this.supportingText,
    this.trailing,
    this.trailingChip,
    this.trailingWidget,
    this.status = SbListItemStatus.none,
    this.onTap,
    this.onLongPress,
    this.variant = SbListItemVariant.standard,
    this.color,
    this.iconColor,
    this.isSubtle = false,
    this.isPrimary = false,
    this.isDisabled = false,
    this.showChevron = false,
    this.titleLines = 2,
    this.subtitleLines = 2,
  });

  /// Creates a standard variant (most common).
  factory SbListItemTile.standard({
    Key? key,
    IconData? icon,
    String? avatarText,
    String? avatarImageUrl,
    Widget? leading,
    required String title,
    String? subtitle,
    String? supportingText,
    dynamic trailing,
    String? trailingChip,
    Widget? trailingWidget,
    SbListItemStatus status = SbListItemStatus.none,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Color? color,
    Color? iconColor,
    bool isPrimary = false,
    bool isDisabled = false,
    bool showChevron = false,
    int titleLines = 2,
    int subtitleLines = 2,
  }) {
    return SbListItemTile(
      key: key,
      icon: icon,
      avatarText: avatarText,
      avatarImageUrl: avatarImageUrl,
      leading: leading,
      title: title,
      subtitle: subtitle,
      supportingText: supportingText,
      trailing: trailing,
      trailingChip: trailingChip,
      trailingWidget: trailingWidget,
      status: status,
      onTap: onTap,
      onLongPress: onLongPress,
      variant: SbListItemVariant.standard,
      color: color,
      iconColor: iconColor,
      isPrimary: isPrimary,
      isDisabled: isDisabled,
      showChevron: showChevron,
      titleLines: titleLines,
      subtitleLines: subtitleLines,
    );
  }

  /// Creates a compact variant for dense lists.
  factory SbListItemTile.compact({
    Key? key,
    IconData? icon,
    String? avatarText,
    String? avatarImageUrl,
    Widget? leading,
    required String title,
    String? subtitle,
    String? supportingText,
    dynamic trailing,
    String? trailingChip,
    Widget? trailingWidget,
    SbListItemStatus status = SbListItemStatus.none,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Color? iconColor,
    bool isPrimary = false,
    bool isDisabled = false,
    bool showChevron = false,
  }) {
    return SbListItemTile(
      key: key,
      icon: icon,
      avatarText: avatarText,
      avatarImageUrl: avatarImageUrl,
      leading: leading,
      title: title,
      subtitle: subtitle,
      supportingText: supportingText,
      trailing: trailing,
      trailingChip: trailingChip,
      trailingWidget: trailingWidget,
      status: status,
      onTap: onTap,
      onLongPress: onLongPress,
      variant: SbListItemVariant.compact,
      iconColor: iconColor,
      isPrimary: isPrimary,
      isDisabled: isDisabled,
      showChevron: showChevron,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Build trailing widget
    Widget? trailingContent;
    if (trailingWidget != null) {
      trailingContent = trailingWidget;
    } else if (trailingChip != null) {
      trailingContent = _buildChip(context, trailingChip!);
    } else if (trailing is String) {
      trailingContent = Text(
        trailing as String,
        style: SbTypography.caption.copyWith(
          color: isSubtle
              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
              : colorScheme.onSurfaceVariant,
        ),
      );
    } else if (trailing is Widget) {
      trailingContent = trailing as Widget;
    }

    // Add chevron if requested
    if (showChevron && trailingContent == null) {
      trailingContent = Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
        size: 20,
      );
    }

    // Build leading widget
    Widget? leadingContent;
    if (leading != null) {
      leadingContent = leading;
    } else if (avatarText != null || avatarImageUrl != null) {
      leadingContent = _buildAvatar(context);
    } else if (icon != null) {
      leadingContent = _buildIconLeading(context, colorScheme);
    }

    // Build status indicator
    Widget? statusIndicator;
    if (status != SbListItemStatus.none) {
      statusIndicator = _buildStatusIndicator(context);
    }

    return _buildContainer(
      context,
      colorScheme,
      leadingContent,
      trailingContent,
      statusIndicator,
    );
  }

  Widget _buildContainer(
    BuildContext context,
    ColorScheme colorScheme,
    Widget? leading,
    Widget? trailing,
    Widget? statusIndicator,
  ) {
    final effectiveOnTap = isDisabled ? null : (onTap ?? () {});
    final isCompact = variant == SbListItemVariant.compact;
    final padding = isCompact
        ? const EdgeInsets.symmetric(
            horizontal: SbSpacing.md,
            vertical: SbSpacing.sm,
          )
        : const EdgeInsets.symmetric(
            horizontal: SbSpacing.md,
            vertical: SbSpacing.md,
          );

    return SbInteractiveCard(
      onTap: effectiveOnTap,
      borderRadius: BorderRadius.circular(
        isSubtle ? 0 : SbRadius.standard,
      ),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: _buildDecoration(colorScheme),
        child: Row(
          children: [
            // Status indicator on far left
            if (statusIndicator != null) ...[
              statusIndicator,
              const SizedBox(width: SbSpacing.sm),
            ],

            // Leading widget
            if (leading != null) ...[
              leading,
              const SizedBox(width: SbSpacing.md),
            ],

            // Content
            Expanded(
              child: _buildContent(context, colorScheme),
            ),

            // Trailing
            if (trailing != null) ...[
              const SizedBox(width: SbSpacing.md),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration? _buildDecoration(ColorScheme colorScheme) {
    if (isSubtle) return null;

    return BoxDecoration(
      color: color ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(SbRadius.standard),
      border: Border.all(
        color: colorScheme.outlineVariant,
        width: 1.0,
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: SbTypography.body.copyWith(
            fontWeight: FontWeight.w500,
            color: isDisabled
                ? colorScheme.onSurface.withValues(alpha: 0.38)
                : colorScheme.onSurface,
          ),
          maxLines: titleLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: SbSpacing.xs),
          Text(
            subtitle!,
            style: SbTypography.bodySmall.copyWith(
              color: isSubtle
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
                  : colorScheme.onSurfaceVariant,
            ),
            maxLines: subtitleLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (supportingText != null && supportingText!.isNotEmpty) ...[
          const SizedBox(height: SbSpacing.xs),
          Text(
            supportingText!,
            style: SbTypography.caption.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildIconLeading(BuildContext context, ColorScheme colorScheme) {
    final isCompact = variant == SbListItemVariant.compact;
    return Container(
      width: isCompact ? 32 : 36,
      height: isCompact ? 32 : 36,
      decoration: BoxDecoration(
        color: isPrimary
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: SbRadius.borderSmall,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor ??
              (isPrimary ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant),
          size: isCompact ? 18 : 20,
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompact = variant == SbListItemVariant.compact;
    final size = isCompact ? 32.0 : 36.0;

    if (avatarImageUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(avatarImageUrl!),
        backgroundColor: colorScheme.primaryContainer,
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        avatarText!.substring(0, avatarText!.length.clamp(0, 2)).toUpperCase(),
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: size / 2.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color indicatorColor;

    switch (status) {
      case SbListItemStatus.none:
        return const SizedBox.shrink();
      case SbListItemStatus.success:
        indicatorColor = AppColors.success;
        break;
      case SbListItemStatus.warning:
        indicatorColor = AppColors.warning;
        break;
      case SbListItemStatus.error:
        indicatorColor = colorScheme.error;
        break;
      case SbListItemStatus.info:
        indicatorColor = colorScheme.primary;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: indicatorColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    Color chipColor;
    Color textColor;

    switch (status) {
      case SbListItemStatus.none:
        chipColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        break;
      case SbListItemStatus.success:
        chipColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case SbListItemStatus.warning:
        chipColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case SbListItemStatus.error:
        chipColor = colorScheme.error.withValues(alpha: 0.1);
        textColor = colorScheme.error;
        break;
      case SbListItemStatus.info:
        chipColor = colorScheme.primary.withValues(alpha: 0.1);
        textColor = colorScheme.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.sm,
        vertical: SbSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: SbRadius.borderSmall,
      ),
      child: Text(
        label,
        style: SbTypography.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
