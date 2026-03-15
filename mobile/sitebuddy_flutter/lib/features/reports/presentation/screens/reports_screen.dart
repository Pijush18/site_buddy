import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: ReportsScreen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SbPage.detail(
      title: 'Reports',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SbCard(
              padding: const EdgeInsets.all(AppLayout.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SbIcons.report,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  AppLayout.vGap24,
                  Text(
                    "No Reports Yet",
                    style: SbTextStyles.headline(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppLayout.vGap16,
                  Text(
                    "Reports generated from calculations and design tools will appear here.",
                    style: SbTextStyles.body(context),
                    textAlign: TextAlign.center,
                  ),
                  AppLayout.vGap24,
                  Container(
                    padding: const EdgeInsets.all(AppLayout.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: AppLayout.borderRadiusCard,
                      border: Border.all(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      "Use the Export PDF option in any calculator or design module to create your first report.",
                      style: SbTextStyles.bodySecondary(context).copyWith(
                        color: colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppLayout.vGap32,
                  Row(
                    children: [
                      Expanded(
                        child: SbButton.outline(
                          label: "Calculators",
                          onPressed: () => context.go('/calculator'),
                        ),
                      ),
                      const SizedBox(width: AppLayout.md),
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
