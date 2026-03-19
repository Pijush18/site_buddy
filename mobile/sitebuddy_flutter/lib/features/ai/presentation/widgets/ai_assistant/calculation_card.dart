import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
            padding: const EdgeInsets.all(AppLayout.md),
            color: colorScheme.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(SbIcons.architecture, color: colorScheme.primary, size: 24),
                AppLayout.hGap12,
                Text(
                  'Material Estimate',
                  style: SbTextStyles.title(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppLayout.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Input: $dimensionsTitle',
                  style: SbTextStyles.bodySecondary(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppLayout.vGap16,
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Wet Volume',
                        value: '${result.volume.toStringAsFixed(2)} $unitLabel',
                        icon: SbIcons.layers,
                      ),
                    ),
                    AppLayout.hGap16,
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
                AppLayout.vGap16,
                Container(
                  padding: const EdgeInsets.all(AppLayout.md),
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cement Required',
                        style: SbTextStyles.title(context),
                      ),
                      Text(
                        '${result.cementBags} Bags',
                        style: SbTextStyles.title(context).copyWith(
                          color: colorScheme.primary,
                        ),
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
      padding: AppLayout.paddingMedium,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              AppLayout.hGap8,
              Flexible(
                child: Text(
                  label,
                  style: SbTextStyles.bodySecondary(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppLayout.vGap8,
          Text(
            value,
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
