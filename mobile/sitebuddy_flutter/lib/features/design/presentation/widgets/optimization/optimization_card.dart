import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class OptimizationCard extends StatelessWidget {
  final OptimizationOption option;
  final VoidCallback? onSelected;

  const OptimizationCard({super.key, required this.option, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final utilColor = option.utilization > 0.95
        ? Colors.red
        : (option.utilization > 0.9 ? Colors.orange : Colors.green);

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSectionDimensions(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _UtilizationBadge(
                utilization: option.utilization,
                color: utilColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Reinforcement',
                  value: option.description,
                  icon: Icons.reorder_rounded,
                ),
              ),
              Expanded(
                child: _DetailItem(
                  label: 'Steel Area',
                  value: '${option.steelArea.toInt()} mm²',
                  icon: Icons.square_foot_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SbButton.primary(
            label: 'Use This Section',
            onPressed: onSelected ??
                () {
                  debugPrint("Optimization option selected: ${option.title}");
                },
          ),
        ],
      ),
    );
  }

  String _getSectionDimensions() {
    if (option.parameters.containsKey('b') && option.parameters.containsKey('d')) {
      return '${option.parameters['b'].toInt()} × ${option.parameters['d'].toInt()} mm';
    }
    if (option.parameters.containsKey('width') && option.parameters.containsKey('depth')) {
      return '${option.parameters['width'].toInt()} × ${option.parameters['depth'].toInt()} mm';
    }
    if (option.parameters.containsKey('thickness')) {
      return '${option.parameters['thickness'].toInt()} mm Thick';
    }
    return option.title;
  }
}

class _UtilizationBadge extends StatelessWidget {
  final double utilization;
  final Color color;

  const _UtilizationBadge({required this.utilization, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${(utilization * 100).toInt()}%',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'UTIL.',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
