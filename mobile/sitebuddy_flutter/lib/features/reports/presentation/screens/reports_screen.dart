import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: ReportsScreen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenWrapper(
      title: 'Reports',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SbCard(
              padding: const EdgeInsets.all(AppSpacing.lg), // Replaced AppLayout.lg
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SbIcons.report,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
                  const Text(
                    "No Reports Yet",
                    style: TextStyle(
                      fontSize: AppFontSizes.title,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                  const Text(
                    "Reports generated from calculations and design tools will appear here.",
                    style: TextStyle(fontSize: AppFontSizes.subtitle),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      "Use the Export PDF option in any calculator or design module to create your first report.",
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        color: colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap32
                  Row(
                    children: [
                      Expanded(
                        child: SbButton.outline(
                          label: "Calculators",
                          onPressed: () => context.go('/calculator'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
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
