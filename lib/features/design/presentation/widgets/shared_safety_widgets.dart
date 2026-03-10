import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/app_card.dart';

class StatusBadge extends StatelessWidget {
  final bool isSafe;
  const StatusBadge({super.key, required this.isSafe});

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppLayout.md,
        vertical: AppLayout.sm,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSafe ? SbIcons.checkFilled : SbIcons.error,
            color: color,
            size: 14,
          ),
          AppLayout.hGap8,
          Text(
            isSafe ? 'SAFE' : 'UNSAFE',
            style: SbTextStyles.body(context).copyWith(color: color),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppLayout.spaceXS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: SbTextStyles.bodySecondary(context).copyWith(color: const Color(0xFF94A3B8)),
          ),
          Text(
            value,
            style: SbTextStyles.body(context).copyWith(color: Colors.white),
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
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Colors.white.withValues(alpha: 0.1)),
              AppLayout.vGap16,
              Text(message, style: SbTextStyles.body(context)),
            ],
          ),
        ),
      ),
    );
  }
}
