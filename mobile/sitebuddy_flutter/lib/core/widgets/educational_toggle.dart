import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';

/// WIDGET: EducationalToggle
/// PURPOSE: A reusable IconButton/Switch to toggle the global Educational Mode.
class EducationalToggle extends ConsumerWidget {
  const EducationalToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(educationalModeProvider);

    return IconButton(
      icon: Icon(
        isEnabled ? SbIcons.education : SbIcons.educationOutlined,
        color: isEnabled
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: isEnabled
          ? 'Disable Educational Mode'
          : 'Enable Educational Mode',
      onPressed: () => ref.read(educationalModeProvider.notifier).toggle(),
    );
  }
}



