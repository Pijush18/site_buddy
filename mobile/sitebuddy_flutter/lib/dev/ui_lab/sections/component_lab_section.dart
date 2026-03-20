import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
                const SizedBox(width: SbSpacing.sm),
                const Text('Enabled', style: TextStyle(fontSize: 10)),
                Switch.adaptive(
                  value: _isEnabled,
                  onChanged: (v) => setState(() => _isEnabled = v),
                ),
              ],
            ),
          ],
        ),
        AppLayout.vGap24,

        // --- BUTTONS ---
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium!),
        const SizedBox(height: SbSpacing.lg),
        Wrap(
          spacing: SbSpacing.lg,
          runSpacing: SbSpacing.lg,
          children: [
            SbButton.primary(
              label: 'Primary Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            SbButton.secondary(
              label: 'Secondary Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            SbButton.ghost(
              label: 'Ghost Button',
              onPressed: _isEnabled ? () {} : null,
              isLoading: _isLoading,
            ),
            SbButton.icon(
              icon: SbIcons.add,
              onPressed: _isEnabled ? () {} : null,
            ),
          ],
        ),
        AppLayout.vGap32,

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
              child: Container(
                decoration: AppLayout.sbCommonDecoration(context),
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Decoration',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    const SizedBox(height: SbSpacing.sm),
                    const Text('Direct use of AppLayout.sbCommonDecoration.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppLayout.vGap32,

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










