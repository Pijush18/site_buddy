import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/widgets/app_card.dart';

/// WIDGET: OptimizationGraph
/// PURPOSE: Visually compares multiple optimization options using bar charts.
class OptimizationGraph extends StatelessWidget {
  final List<OptimizationOption> options;

  const OptimizationGraph({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    // Find max values for normalization
    double maxSteelArea = 1.0;
    for (var opt in options) {
      if (opt.steelArea > maxSteelArea) maxSteelArea = opt.steelArea;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                SbIcons.analytics,
                color: Color(0xFF2563EB),
                size: 20,
              ),
              AppLayout.hGap8,
              Text(
                'EFFICIENCY COMPARISON',
                style: AppTextStyles.labelMedium.copyWith(letterSpacing: 1.2),
              ),
            ],
          ),
          AppLayout.vGap16,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (context, index) => AppLayout.vGap24,
            itemBuilder: (context, index) {
              final option = options[index];
              return _OptimizationRow(
                option: option,
                maxSteelArea: maxSteelArea,
                rankLabel: _getRankLabel(index),
              );
            },
          ),
          AppLayout.vGap8,
          _buildLegend(),
        ],
      ),
    );
  }

  String _getRankLabel(int index) {
    if (index == 0) return 'ECONOMICAL';
    if (index == 1) return 'BALANCED';
    return 'SAFE';
  }

  Widget _buildLegend() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _LegendItem(color: Color(0xFF2563EB), label: 'Utilization'),
          AppLayout.hGap16,
          _LegendItem(color: Colors.orange, label: 'Steel Area'),
        ],
      ),
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
            Text(option.title, style: AppTextStyles.bodyMedium),
            Text(
              rankLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: _getRankColor(rankLabel),
              ),
            ),
          ],
        ),
        AppLayout.vGap8,
        // Utilization Bar
        _Bar(
          label: 'Util: ${(utilPercentage * 100).toInt()}%',
          percentage: utilPercentage,
          color: const Color(0xFF2563EB),
        ),
        AppLayout.vGap4,
        // Steel Area Bar
        _Bar(
          label: 'Steel: ${option.steelArea.toInt()} mm²',
          percentage: steelPercentage,
          color: Colors.orange,
        ),
      ],
    );
  }

  Color _getRankColor(String label) {
    if (label == 'ECONOMICAL') return Colors.green;
    if (label == 'BALANCED') return const Color(0xFF2563EB);
    return Colors.purple;
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
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        const SizedBox(height: 14, width: double.infinity),
        FractionallySizedBox(
          widthFactor: percentage,
          child: Container(height: 14),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,

              shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
            ),
          ),
        ),
      ],
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
        const SizedBox(width: 10, height: 10),
        AppLayout.hGap8,
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
