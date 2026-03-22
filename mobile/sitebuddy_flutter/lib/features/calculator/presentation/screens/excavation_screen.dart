import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
// import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/calculator/application/controllers/excavation_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/domain/models/excavation_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class ExcavationScreen extends ConsumerWidget {
  const ExcavationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excavationProvider);
    final controller = ref.read(excavationProvider.notifier);

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ExcavationPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final isValid = state.lengthInput.isNotEmpty && state.widthInput.isNotEmpty && state.depthInput.isNotEmpty;

    return SbPage.scaffold(
      title: 'Excavation',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: 'Dimensions'),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: 'Length (m)',
            hint: EngineeringTerms.pitLengthHint,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: 'Width (m)',
            hint: EngineeringTerms.pitLengthHint,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: 'Depth (m)',
            hint: EngineeringTerms.pitDepthHint,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: SbSpacing.xl),
          const _SectionLabel(label: EngineeringTerms.parameters),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: 'Clearance (m)',
            hint: EngineeringTerms.widthHint,
            initialValue: '0.3',
            onChanged: controller.updateClearance,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: EngineeringTerms.clearanceInfo,
            ),
          ),
          const SizedBox(height: SbSpacing.sm),
          SbInput(
            label: 'Swell Factor',
            hint: EngineeringTerms.swellFactorHint,
            initialValue: '1.25',
            onChanged: controller.updateSwellFactor,
            onInfoPressed: () => SbFeedback.showToast(
              context: context,
              message: EngineeringTerms.swellFactorInfo,
            ),
          ),
          const SizedBox(height: SbSpacing.xl),
          ActionButtonsGroup(
            children: [
              SecondaryButton(isOutlined: true, 
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              PrimaryCTA(
                label: 'Calculate',
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xl),
          if (state.failure != null)
            _ErrorBanner(message: state.failure!.message),
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: SbSpacing.md),
            PrimaryCTA(
              label: 'Export PDF',
              icon: Icons.picture_as_pdf,
              onPressed: () {
                debugPrint("Export PDF clicked - TODO: implement");
              },
            ),
            const SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.titleMedium!,
      textAlign: TextAlign.center,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      color: colorScheme.errorContainer.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(SbSpacing.lg),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge!,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ExcavationResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.lg), // Replaced SizedBox(height: SbSpacing.lg)
          const Divider(),
          SbListItemTile(
            title: 'Total Volume',
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.volumeM3.toStringAsFixed(2)} m³',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          SbListItemTile(
            title: 'Bank Volume',
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${(result.volumeM3 / result.swellFactor).toStringAsFixed(2)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          const Divider(),
          const SizedBox(height: SbSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                EngineeringTerms.clearanceLabel,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              Text(
                '${result.clearance} m',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                EngineeringTerms.swellFactorLabel,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              Text(
                '${result.swellFactor}',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}











