import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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
              style: SbTextStyles.title(context),
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
        AppLayout.vGap24,

        // --- BUTTONS ---
        Text('Buttons', style: SbTextStyles.title(context)),
        AppLayout.vGap16,
        Wrap(
          spacing: AppLayout.pMedium,
          runSpacing: AppLayout.pMedium,
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
        Text('Containers', style: SbTextStyles.title(context)),
        AppLayout.vGap16,
        Row(
          children: [
            Expanded(
              child: SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SbCard',
                      style: SbTextStyles.body(context),
                    ),
                    AppLayout.vGap8,
                    const Text(
                      'This is the standard SiteBuddy card component.',
                    ),
                  ],
                ),
              ),
            ),
            AppLayout.hGap16,
            Expanded(
              child: Container(
                decoration: AppLayout.sbCommonDecoration(context),
                padding: const EdgeInsets.all(AppLayout.pMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Decoration',
                      style: SbTextStyles.body(context),
                    ),
                    AppLayout.vGap8,
                    const Text('Direct use of AppLayout.sbCommonDecoration.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppLayout.vGap32,

        // --- FORMS ---
        Text('Form Inputs', style: SbTextStyles.title(context)),
        AppLayout.vGap16,
        SbInput(
          label: 'Standard Input',
          hint: 'Type something...',
          enabled: _isEnabled,
        ),
        AppLayout.vGap16,
        const SbInput(label: 'Input with Helper', hint: 'Example helper text'),
      ],
    );
  }
}
