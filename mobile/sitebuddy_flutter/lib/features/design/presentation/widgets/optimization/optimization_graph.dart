import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/theme/app_colors.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class OptimizationGraph extends StatelessWidget {
  final List<OptimizationOption> options;

  const OptimizationGraph({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    double maxSteelArea = 1.0;
    for (var opt in options) {
      if (opt.steelArea > maxSteelArea) maxSteelArea = opt.steelArea;
    }

    return SbSection(
      title: 'Efficiency Comparison',
      trailing: Icon(
        SbIcons.analytics,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      child: SbCard(
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final option = options[index];
                return _OptimizationRow(
                  option: option,
                  maxSteelArea: maxSteelArea,
                  rankLabel: _getRankLabel(index),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  String _getRankLabel(int index) {
    if (index == 0) return 'ECONOMICAL';
    if (index == 1) return 'BALANCED';
    return 'SAFE';
  }

  Widget _buildLegend(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _LegendItem(color: colorScheme.primary, label: 'Utilization'),
        const SizedBox(width: AppSpacing.md),
        _LegendItem(color: AppColors.warning(context), label: 'Steel Area'),
      ],
    );
  }
}

class _OptimizationRow extends StatelessWidget {
  final OptimizationOption option;
  final double maxSteelArea;
  final String rankLabel;

  const _OptimizationRow({
    required this.option,
    required this.maxSteelArea,
    required this.rankLabel,
  });

  @override
  Widget build(BuildContext context) {
    final steelPercentage = (option.steelArea / maxSteelArea).clamp(0.1, 1.0);
    final utilPercentage = option.utilization.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(option.title, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600)),
            Text(
              rankLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getRankColor(context, rankLabel),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Bar(
          label: 'Util: ${(utilPercentage * 100).toInt()}%',
          percentage: utilPercentage,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.xs),
        _Bar(
          label: 'Steel: ${option.steelArea.toInt()} mm²',
          percentage: steelPercentage,
          color: AppColors.warning(context),
        ),
      ],
    );
  }

  Color _getRankColor(BuildContext context, String label) {
    if (label == 'ECONOMICAL') return AppColors.success(context);
    if (label == 'BALANCED') return Theme.of(context).colorScheme.primary;
    return Colors.purple; // Semantic for "Safe" rank
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _Bar({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: AppTextStyles.caption(context).copyWith(
                  color: label.toLowerCase().contains('safe') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
