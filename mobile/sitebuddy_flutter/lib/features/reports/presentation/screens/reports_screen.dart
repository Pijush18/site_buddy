import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: ReportsScreen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppScreenWrapper(
      title: 'Reports',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SbCard(
              padding: const EdgeInsets.all(SbSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SbIcons.report,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Text(
                    "No Reports Yet",
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SbSpacing.md),
                  Text(
                    "Reports generated from calculations and design tools will appear here.",
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(SbSpacing.md),
                    child: Text(
                      "Use the Export PDF option in any calculator or design module to create your first report.",
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: SbButton.outline(
                          label: "Calculators",
                          onPressed: () => context.go('/calculator'),
                        ),
                      ),
                      const SizedBox(width: SbSpacing.md),
                      Expanded(
                        child: SbButton.primary(
                          label: "Design Tools",
                          onPressed: () => context.go('/design'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



