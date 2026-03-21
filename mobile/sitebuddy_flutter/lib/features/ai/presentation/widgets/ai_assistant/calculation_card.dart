import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';

class CalculationCard extends ConsumerWidget {
  final MaterialResult result;
  final String dimensionsTitle;

  const CalculationCard({
    super.key,
    required this.result,
    required this.dimensionsTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final unitSystem = ref.watch(settingsProvider).unitSystem;
    final unitLabel = unitSystem == UnitSystem.metric ? 'm³' : 'yd³';

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(SbSpacing.lg),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Row(
              children: [
                Icon(SbIcons.architecture, color: colorScheme.onSurfaceVariant, size: 24),

                const SizedBox(width: SbSpacing.md),
                Text(
                  'Material Estimate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Input: $dimensionsTitle',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const SizedBox(height: SbSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Wet Volume',
                        value: '${result.volume.toStringAsFixed(2)} $unitLabel',
                        icon: SbIcons.layers,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.lg),
                    Expanded(
                      child: _StatBox(
                        label: 'Dry Materials',
                        value:
                            '${result.dryVolume.toStringAsFixed(2)} $unitLabel',
                        icon: SbIcons.grain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(SbSpacing.lg),
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cement Required',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      Text(
                        '${result.cementBags} Bags',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(SbSpacing.lg),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),

              const SizedBox(width: SbSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
        ],
      ),
    );
  }
}









