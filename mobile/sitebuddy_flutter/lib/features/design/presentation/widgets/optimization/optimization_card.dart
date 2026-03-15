import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/optimization/optimization_option.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WIDGET: OptimizationCard
/// Displays a single structural optimization suggestion from the OptimizationEngine.
class OptimizationCard extends StatelessWidget {
  final OptimizationOption option;
  final VoidCallback? onSelected;

  const OptimizationCard({super.key, required this.option, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

    // Utilization color logic
    final utilColor = option.utilization > 0.9
        ? Colors.orange
        : (option.utilization > 0.95 ? Colors.red : Colors.green);

    return SbCard(
      
      padding: const EdgeInsets.all(AppLayout.pLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Title & Visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title.toUpperCase(),
                      style: SbTextStyles.caption(context).copyWith(
                        color: theme.primaryColor,
                        
                        letterSpacing: 1.1,
                      ),
                    ),
                    AppLayout.vGap4,
                    Text(
                      _getSectionDimensions(),
                      style: SbTextStyles.title(context),
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

          const SizedBox(height: AppLayout.pMedium),
          const Divider(height: 1),
          const SizedBox(height: AppLayout.pMedium),

          // Details Grid
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

          const SizedBox(height: AppLayout.pLarge),

          // Action Button
          SbButton.primary(
            label: 'Use This Section',
            onPressed:
                onSelected ??
                () {
                  debugPrint("Optimization option selected: ${option.title}");
                },
          ),
        ],
      ),
    );
  }

  String _getSectionDimensions() {
    if (option.parameters.containsKey('b') &&
        option.parameters.containsKey('d')) {
      return '${option.parameters['b'].toInt()} × ${option.parameters['d'].toInt()} mm';
    }
    if (option.parameters.containsKey('width') &&
        option.parameters.containsKey('depth')) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      
      child: Column(
        children: [
          Text(
            '${(utilization * 100).toInt()}%',
            style: TextStyle(
              color: color,
              
              
            ),
          ),
          Text(
            'UTIL.',
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              
              
            ),
          ),
        ],
      ),
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
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        AppLayout.hGap8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: SbTextStyles.caption(context).copyWith(color: Colors.grey),
              ),
              Text(
                value,
                style: SbTextStyles.body(context),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
