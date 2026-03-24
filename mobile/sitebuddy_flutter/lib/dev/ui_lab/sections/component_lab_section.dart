import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';

class ComponentLabSection extends StatefulWidget {
  const ComponentLabSection({super.key});

  @override
  State<ComponentLabSection> createState() => _ComponentLabSectionState();
}

class _ComponentLabSectionState extends State<ComponentLabSection> {
  bool _isLoading = false;
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Components Lab',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            Row(
              children: [
                Text('Loading', style: SbTypography.caption),
                Switch.adaptive(
                  value: _isLoading,
                  onChanged: (v) => setState(() => _isLoading = v),
                ),
                const SizedBox(width: SbSpacing.sm),
                Text('Enabled', style: SbTypography.caption),
                Switch.adaptive(
                  value: _isEnabled,
                  onChanged: (v) => setState(() => _isEnabled = v),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: SbSpacing.lg),

        // --- BUTTONS ---
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        Wrap(
          spacing: SbSpacing.lg,
          runSpacing: SbSpacing.lg,
          children: [
            PrimaryCTA(
              label: 'Primary Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            SecondaryButton(
              label: 'Secondary Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            GhostButton(
              label: 'Ghost Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            AppIconButton(
              icon: SbIcons.add,
              onPressed: _isEnabled ? () {} : null,
            ),
          ],
        ),
        const SizedBox(height: SbSpacing.xxl),

        // --- CARDS ---
        Text('Containers', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        Row(
          children: [
            Expanded(
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SbCard',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    const SizedBox(height: SbSpacing.sm),
                    const Text(
                      'This is the standard SiteBuddy card component.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: SbSpacing.lg),
            Expanded(
              child: SbCard(
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Decoration',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    const SizedBox(height: SbSpacing.sm),
                    const Text('Standard card usage from SbCard.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SbSpacing.xxl),

        // --- FORMS ---
        Text('Form Inputs', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        SbInput(
          label: 'Standard Input',
          hint: 'Type something...',
          enabled: _isEnabled,
        ),
        const SizedBox(height: SbSpacing.lg),
        const SbInput(label: 'Input with Helper', hint: 'Example helper text'),
      ],
    );
  }
}










