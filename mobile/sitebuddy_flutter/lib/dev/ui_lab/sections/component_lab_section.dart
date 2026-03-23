import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

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
                const Text('Loading', style: TextStyle(fontSize: 10)),
                Switch.adaptive(
                  value: _isLoading,
                  onChanged: (v) => setState(() => _isLoading = v),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text('Enabled', style: TextStyle(fontSize: 10)),
                Switch.adaptive(
                  value: _isEnabled,
                  onChanged: (v) => setState(() => _isEnabled = v),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // --- BUTTONS ---
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
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
        const SizedBox(height: AppSpacing.xxl),

        // --- CARDS ---
        Text('Containers', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: AppSpacing.lg),
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
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'This is the standard SiteBuddy card component.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: SbCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Decoration',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text('Standard card usage from SbCard.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // --- FORMS ---
        Text('Form Inputs', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: AppSpacing.lg),
        SbInput(
          label: 'Standard Input',
          hint: 'Type something...',
          enabled: _isEnabled,
        ),
        const SizedBox(height: AppSpacing.lg),
        const SbInput(label: 'Input with Helper', hint: 'Example helper text'),
      ],
    );
  }
}










