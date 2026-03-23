import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_typography.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/project/domain/models/project_status.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:site_buddy/features/project/application/controllers/project_editor_controller.dart';

/// SCREEN: ProjectEditorScreen
/// 
/// [REFACTORED] - This screen is now purely declarative.
/// All business logic has been moved to ProjectEditorNotifier.
/// 
/// VIOLATIONS FIXED:
/// - ✅ Removed setState for saving state (now in Notifier)
/// - ✅ Removed setState for dropdown (now in Notifier)
/// - ✅ Removed business logic from UI (now in Notifier)
/// - ✅ UI converted from ConsumerStatefulWidget to ConsumerWidget
class ProjectEditorScreen extends ConsumerWidget {
  final String? projectId;
  const ProjectEditorScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectEditorControllerProvider);
    final notifier = ref.read(projectEditorControllerProvider.notifier);

    return SbPage.form(
      title: context.l10n.project,
      primaryAction: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state.isSaving || !state.isValid
              ? null
              : () async {
                  final success = await notifier.submit(ref);
                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                },
          child: state.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.actionSave),
        ),
      ),

      body: SbSectionList(
        sections: [
          // Error message
          if (state.error != null)
            SbSection(
              child: Container(
                padding: const EdgeInsets.all(SbSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.error!,
                  style: SbTypography.body.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),

          SbSection(
            title: context.l10n.labelPrimaryDetails,
            child: Column(
              children: [
                SbInput(
                  label: context.l10n.labelProjectName,
                  hint: 'e.g. Skyline Apartments',
                  onChanged: notifier.updateName,
                ),
                const SizedBox(height: SbSpacing.lg),
                SbInput(
                  label: context.l10n.labelLocation,
                  hint: 'City, Region or Site ID',
                  onChanged: notifier.updateLocation,
                ),
              ],
            ),
          ),
          SbSection(
            title: context.l10n.labelStakeholders,
            child: SbInput(
              label: context.l10n.labelClient,
              hint: 'Contracting Authority / Client',
              onChanged: notifier.updateClientName,
            ),
          ),
          SbSection(
            title: context.l10n.labelStatus,
            child: SbDropdown<ProjectStatus>(
              value: state.status,
              items: ProjectStatus.values,
              itemLabelBuilder: (status) => status.label,
              onChanged: (val) {
                if (val != null) notifier.updateStatus(val);
              },
            ),
          ),
          SbSection(
            title: context.l10n.labelDescription,
            child: SbInput(
              label: context.l10n.labelDescription,
              maxLines: 5,
              hint: 'Enter detailed project scope...',
              onChanged: notifier.updateDescription,
            ),
          ),
        ],
      ),
    );
  }
}
