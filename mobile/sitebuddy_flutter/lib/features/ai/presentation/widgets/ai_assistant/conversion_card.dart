import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
            padding: const EdgeInsets.all(SbSpacing.lg),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: Row(
              children: [
                Icon(SbIcons.swap, color: colorScheme.onSurfaceVariant, size: 24),

                const SizedBox(width: SbSpacing.lg),
                Text(
                  'Unit Conversion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),

              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  inputTitle,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                const SizedBox(height: SbSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '=',
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    const SizedBox(width: SbSpacing.lg),
                    Expanded(
                      child: Text(
                        '${result.mainValue.toStringAsFixed(4)} $outputUnit',
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                    ),
                  ],
                ),
                if (result.secondaryValues.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: SbSpacing.lg),
                    child: const Divider(),
                  ),
                  Text(
                    'ALSO EQUIVALENT TO',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  const SizedBox(height: SbSpacing.sm),
                  Wrap(
                    spacing: SbSpacing.sm,
                    runSpacing: SbSpacing.sm,
                    children: result.secondaryValues.entries
                        .map(
                          (entry) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm, vertical: SbSpacing.xs),
                            
                            child: Text(
                              '${entry.value.toStringAsFixed(3)} ${entry.key}',
                              style: Theme.of(context).textTheme.bodyLarge!,
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










