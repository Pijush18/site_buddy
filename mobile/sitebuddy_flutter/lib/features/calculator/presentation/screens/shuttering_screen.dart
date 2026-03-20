import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/shuttering_controller.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/domain/models/shuttering_result.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';

class ShutteringScreen extends ConsumerWidget {
  const ShutteringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shutteringProvider);
    final controller = ref.read(shutteringProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is ShutteringPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final wError = state.failure?.message.contains('Width') == true ? state.failure?.message : null;
    final dError = state.failure?.message.contains('Depth') == true ? state.failure?.message : null;

    final isValid = state.lengthInput.isNotEmpty && state.widthInput.isNotEmpty && state.depthInput.isNotEmpty;

    return AppScreenWrapper(
      title: EngineeringTerms.shutteringAreaEstimator,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(label: EngineeringTerms.elementDimensions),
          const SizedBox(height: SbSpacing.sm),
          AppNumberField(
            label: EngineeringTerms.length,
            hint: EngineeringTerms.lengthHint,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          const SizedBox(height: SbSpacing.sm),
          AppNumberField(
            label: EngineeringTerms.width,
            hint: EngineeringTerms.widthHint,
            onChanged: controller.updateWidth,
            errorText: wError,
          ),
          const SizedBox(height: SbSpacing.sm),
          AppNumberField(
            label: EngineeringTerms.depth,
            hint: EngineeringTerms.depthHint,
            onChanged: controller.updateDepth,
            errorText: dError,
          ),
          const SizedBox(height: SbSpacing.sm),
          SbListItemTile(
            title: EngineeringTerms.includeBottomArea,
            onTap: () => controller.updateIncludeBottom(!state.includeBottom),
            trailing: Switch(
              value: state.includeBottom,
              onChanged: controller.updateIncludeBottom,
              activeThumbColor: colorScheme.primary,
            ),
          ),
          const SizedBox(height: SbSpacing.xxl),
          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? AppStrings.calculating : AppStrings.calculate,
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.xxl),
          if (state.failure != null)
             _ErrorBanner(message: state.failure!.message),
          if (state.result != null) ...[
            _ResultCard(result: state.result!),
            const SizedBox(height: SbSpacing.xxl),
          ],
          Text(
            EngineeringTerms.shutteringNote,
            style: Theme.of(context).textTheme.labelMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xxl),
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
  final ShutteringResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.resultSummary,
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.lg),
          const Divider(),
          SbListItemTile(
            title: EngineeringTerms.totalShutteringArea,
            onTap: () {},
            trailing: Text(
              '${result.areaM2.toStringAsFixed(2)} m²',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.perimeter,
            onTap: () {},
            trailing: Text(
              '${(2 * (result.length + result.width)).toStringAsFixed(2)} m',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.depth,
            onTap: () {},
            trailing: Text(
              '${result.depth} m',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
        ],
      ),
    );
  }
}
