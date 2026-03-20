import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

class OnboardingMessage extends StatelessWidget {
  const OnboardingMessage({super.key});

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);

    return Column(
      children: [
        AppLayout.vGap32,
        Icon(SbIcons.engineering, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: AppLayout.sectionGap),
        Text(
          'How can I assist your site today?',
          style: AppTextStyles.screenTitle(context).copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppLayout.md),
        Text(
          'Try asking:\n\n'
          '• "What is a retaining wall?"\n'
          '• "Convert 100 sqft to sqm"\n'
          '• "12x6x0.5 slab M25"',
          style: AppTextStyles.body(context).copyWith(
            color: Colors.grey,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}