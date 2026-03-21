
import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
        : (option.utilization > 0.8 ? colorScheme.tertiary : colorScheme.primary);

    return SbCard(
      padding: SbSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  option.title,
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
              ),
              if (option.utilization <= 1.0)
                Icon(Icons.check_circle, color: colorScheme.primary, size: 16)
              else
                Icon(Icons.warning, color: colorScheme.error, size: 16),
            ],
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            option.description,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.lg),
          Row(
            children: [
              _StatItem(
                label: 'Steel Area',
                value: '${option.steelArea.toInt()} mm²',
                color: colorScheme.primary,
              ),
              const SizedBox(width: SbSpacing.xxl),
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
          style: Theme.of(context).textTheme.labelMedium!,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ],
    );
  }
}








