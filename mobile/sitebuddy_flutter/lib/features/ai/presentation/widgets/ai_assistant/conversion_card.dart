import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/conversion_result.dart';

class ConversionCard extends StatelessWidget {
  final ConversionResult result;
  final String inputTitle;
  final String outputUnit;

  const ConversionCard({
    super.key,
    required this.result,
    required this.inputTitle,
    required this.outputUnit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            color: colorScheme.primary.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(SbIcons.swap, color: colorScheme.primary, size: 24),
                AppLayout.hGap16,
                Text(
                  'Unit Conversion',
                  style: AppTextStyles.sectionTitle(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  inputTitle,
                  style: AppTextStyles.body(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppLayout.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '=',
                      style: AppTextStyles.screenTitle(context).copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    AppLayout.hGap16,
                    Expanded(
                      child: Text(
                        '${result.mainValue.toStringAsFixed(4)} $outputUnit',
                        style: AppTextStyles.screenTitle(context).copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (result.secondaryValues.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppLayout.md),
                    child: Divider(),
                  ),
                  Text(
                    'ALSO EQUIVALENT TO',
                    style: AppTextStyles.body(context, secondary: true).copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
                  ),
                  AppLayout.vGap8,
                  Wrap(
                    spacing: AppLayout.sm,
                    runSpacing: AppLayout.sm,
                    children: result.secondaryValues.entries
                        .map(
                          (entry) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppLayout.pSmall,
                              vertical: AppLayout.spaceXS,
                            ),
                            
                            child: Text(
                              '${entry.value.toStringAsFixed(3)} ${entry.key}',
                              style: AppTextStyles.body(context),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
