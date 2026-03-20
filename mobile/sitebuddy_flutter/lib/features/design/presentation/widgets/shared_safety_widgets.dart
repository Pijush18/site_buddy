
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

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
        horizontal: SbSpacing.sm,
        vertical: SbSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: SbRadius.borderMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: SbSpacing.xs),
          Text(
            label.isNotEmpty ? label : (isSafe ? 'SAFE' : 'UNSAFE'),
            style: Theme.of(context).textTheme.titleMedium!,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!,
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
        borderRadius: SbRadius.borderMd,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SbSpacing.xxl),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: SbSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ],
        ),
      ),
    );
  }
}











