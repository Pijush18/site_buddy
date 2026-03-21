import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';

class OnboardingMessage extends StatelessWidget {
  const OnboardingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SbSpacing.xxxl),
        Icon(SbIcons.engineering, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
        const SizedBox(height: SbSpacing.lg),
        Text(
          'How can I assist your site today?',
          style: Theme.of(context).textTheme.titleLarge!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SbSpacing.lg),
        Text(
          'Try asking:\n\n'
          '• "What is a retaining wall?"\n'
          '• "Convert 100 sqft to sqm"\n'
          '• "12x6x0.5 slab M25"',
          style: Theme.of(context).textTheme.bodyLarge!,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
