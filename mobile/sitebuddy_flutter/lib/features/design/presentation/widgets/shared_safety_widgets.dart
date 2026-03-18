import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class StatusBadge extends StatelessWidget {
  final bool isSafe;
  const StatusBadge({super.key, required this.isSafe});

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSafe ? SbIcons.checkFilled : SbIcons.error,
            color: color,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            isSafe ? 'SAFE' : 'UNSAFE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ResultDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const ResultDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const PlaceholderCard({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
