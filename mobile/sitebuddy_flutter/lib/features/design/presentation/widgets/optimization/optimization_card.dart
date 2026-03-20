import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class OptimizationCard extends StatelessWidget {
  final OptimizationOption option;

  const OptimizationCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final utilColor = option.utilization > 0.95
        ? colorScheme.error
        : (option.utilization > 0.8 ? Colors.orange : colorScheme.primary);

    return SbCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  option.title,
                  style: AppTextStyles.cardTitle(context),
                ),
              ),
              if (option.utilization <= 1.0)
                const Icon(Icons.check_circle, color: Colors.green, size: 16)
              else
                Icon(Icons.warning, color: colorScheme.error, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            option.description,
            style: AppTextStyles.caption(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatItem(
                label: 'Steel Area',
                value: '${option.steelArea.toInt()} mm²',
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.lg),
              _StatItem(
                label: 'Utilization',
                value: '${(option.utilization * 100).toInt()}%',
                color: utilColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(fontSize: 10),
        ),
        Text(
          value,
          style: AppTextStyles.body(context).copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
