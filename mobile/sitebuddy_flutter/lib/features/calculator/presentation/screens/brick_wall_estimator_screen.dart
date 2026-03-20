import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/shared/widgets/action_buttons_group.dart';
import 'package:site_buddy/features/calculator/application/controllers/brick_wall_controller.dart';
import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';
import 'package:site_buddy/shared/domain/models/mortar_ratio.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:go_router/go_router.dart';

class BrickWallEstimatorScreen extends ConsumerWidget {
  const BrickWallEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brickWallProvider);
    final controller = ref.read(brickWallProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Prefill logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is BrickPrefillData) {
        controller.initializeWithPrefill(extra);
      }
    });

    final lError = state.failure?.message.contains('Length') == true ? state.failure?.message : null;
    final hError = state.failure?.message.contains('Height') == true ? state.failure?.message : null;
    final tError = state.failure?.message.contains('Thickness') == true ? state.failure?.message : null;

    final isValid = state.lengthInput.isNotEmpty && state.heightInput.isNotEmpty && state.thicknessInput.isNotEmpty;

    return AppScreenWrapper(
      title: ScreenTitles.brickWallEstimator,
      child: SbSectionList(
        sections: [
          // ── SECTION 1: DIMENSIONS ─────────────────────────────────────────
          SbSection(
            title: EngineeringTerms.wallDimensions,
            child: Column(
              children: [
                AppNumberField(
                  label: EngineeringTerms.wallLength,
                  hint: EngineeringTerms.lengthHint,
                  suffixIcon: SbIcons.ruler,
                  onChanged: controller.updateLength,
                  errorText: lError,
                ),
                const SizedBox(height: SbSpacing.lg),
                AppNumberField(
                  label: EngineeringTerms.wallHeight,
                  hint: EngineeringTerms.heightHint,
                  suffixIcon: SbIcons.height,
                  onChanged: controller.updateHeight,
                  errorText: hError,
                ),
                const SizedBox(height: SbSpacing.lg),
                AppNumberField(
                  label: EngineeringTerms.wallThickness,
                  hint: EngineeringTerms.brickThicknessHint,
                  suffixIcon: SbIcons.layers,
                  onChanged: controller.updateThickness,
                  errorText: tError,
                ),
              ],
            ),
          ),

          // ── SECTION 2: BRICK & MORTAR ─────────────────────────────────────
          SbSection(
            title: EngineeringTerms.brickAndMortar,
            child: Column(
              children: [
                SbCard(
                  child: Row(
                    children: [
                      Icon(SbIcons.crop, size: 20, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: SbSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EngineeringTerms.brickSize,
                              style: Theme.of(context).textTheme.labelMedium!,
                            ),
                            const SizedBox(height: SbSpacing.xs),
                            Text(
                              EngineeringTerms.standardBrickSize,
                                style: Theme.of(context).textTheme.bodyLarge!,
                            ),
                            Text(
                              EngineeringTerms.brickWithJoint,
                                style: Theme.of(context).textTheme.labelMedium!,
                            ),
                          ],
                        ),
                      ),
                      SbButton.icon(
                        icon: SbIcons.info,
                        tooltip: EngineeringTerms.brickStandardRef,
                        onPressed: () {
                          SbFeedback.showToast(
                            context: context,
                            message: EngineeringTerms.brickInfo,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SbSpacing.lg),
                Text(
                  EngineeringTerms.mortarRatio,
                  style: Theme.of(context).textTheme.titleMedium!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SbSpacing.sm),
                SbDropdown<MortarRatio>(
                  value: state.selectedRatio,
                  items: MortarRatio.values,
                  itemLabelBuilder: (r) => r.label,
                  onChanged: (val) {
                    if (val != null) {
                      controller.updateRatio(val);
                    }
                  },
                ),
              ],
            ),
          ),

          // ── SECTION 3: ACTIONS ─────────────────────────────────────────
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

          // ── SECTION 4: ERRORS ──────────────────────────────────────────
          if (state.failure != null)
            SbCard(
              child: Padding(
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Text(
                  state.failure!.message,
                    style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // ── SECTION 5: RESULTS ─────────────────────────────────────────
          if (state.result != null)
            _ResultSection(result: state.result!),

          // ── SECTION 6: COMPLIANCE FOOTNOTE ──────────────────────────────
          Text(
            EngineeringTerms.brickMasonryRef,
            style: Theme.of(context).textTheme.labelMedium!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



class _ResultSection extends StatelessWidget {
  final BrickWallResult result;
  const _ResultSection({required this.result});

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
          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
          const Divider(),

          // Bricks
          SbListItemTile(
            title: EngineeringTerms.numberOfBricks,
            onTap: () {}, // Detail view entry
            trailing: Text(
              result.numberOfBricks.toString(),
              style: Theme.of(context).textTheme.labelLarge!,
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.brickVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.brickVolume.toStringAsFixed(3)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),

          const Divider(),
          const SizedBox(height: SbSpacing.xxl), // Replaced SbSpacing.xxl

          // Cement & Sand
          SbListItemTile(
            title: EngineeringTerms.cementBags,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${AppStrings.bags}',
              style: Theme.of(context).textTheme.labelLarge!,
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.sandVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),

          const Divider(),
          const SizedBox(height: SbSpacing.xxl), // Replaced SbSpacing.xxl

          // Totals
          SbListItemTile(
            title: EngineeringTerms.wallVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.wallVolume.toStringAsFixed(3)} m³',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(EngineeringTerms.mortarRatioLabel, style: Theme.of(context).textTheme.labelMedium!),
              Text(
                result.mortarRatio,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}









