import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';

/// A header widget that displays whether a check is safe or unsafe.
class SafetyStatusHeader extends StatelessWidget {
  final bool isSafe;
  final String label;

  const SafetyStatusHeader({
    super.key,
    required this.isSafe,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSafe ? colorScheme.primary : colorScheme.error;
    final icon = isSafe ? Icons.check_circle : Icons.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label.isNotEmpty ? label : (isSafe ? 'SAFE' : 'UNSAFE'),
            style: AppTextStyles.sectionTitle(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple row for displaying a label and its corresponding check result.
class SafetyInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const SafetyInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body(context).copyWith(
              fontWeight: isStrong ? FontWeight.bold : FontWeight.normal,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// A badge displaying safety status (SAFE/FAIL).
class StatusBadge extends StatelessWidget {
  final bool isSafe;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.isSafe,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SafetyStatusHeader(
      isSafe: isSafe,
      label: customLabel ?? (isSafe ? 'SAFE' : 'FAIL'),
    );
  }
}

/// A standard row for displaying a result label and value.
class ResultDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const ResultDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafetyInfoRow(
      label: label,
      value: value,
      isStrong: isStrong,
    );
  }
}

/// A card used as a placeholder when no results are available.
class PlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const PlaceholderCard({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(context).copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
