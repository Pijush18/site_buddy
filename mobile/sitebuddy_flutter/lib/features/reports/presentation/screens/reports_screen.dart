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

    final textTheme = theme.textTheme;

    return SbPage.list(
      title: 'Reports',
      body: SbSectionList(
        sections: [
          SbSection(
            child: SbEmptyState(
              icon: SbIcons.report,
              title: 'No Reports Yet',
              subtitle:
                  'Reports appear here automatically.',
              actionLabel: 'Go to Calculators',
              onAction: () => context.go('/calculator'),
            ),
          ),

          SbSection(
            title: 'How it works',
            child: SbCard(
              padding: const EdgeInsets.all(SbSpacing.lg),
              child: Text(
                'Use Export PDF in any module.',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



