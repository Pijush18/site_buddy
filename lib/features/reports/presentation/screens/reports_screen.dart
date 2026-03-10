import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: ReportsScreen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SbPage.detail(
      title: 'Reports',
      body: Center(
        child: Text(
          'Reports feature coming soon.',
          style: SbTextStyles.bodySecondary(context).copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
