import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_text_styles.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
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
                const SizedBox(height: AppSpacing.md),
                AppNumberField(
                  label: EngineeringTerms.wallHeight,
                  hint: EngineeringTerms.heightHint,
                  suffixIcon: SbIcons.height,
                  onChanged: controller.updateHeight,
                  errorText: hError,
                ),
                const SizedBox(height: AppSpacing.md),
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
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EngineeringTerms.brickSize,
                              style: AppTextStyles.caption(context).copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              EngineeringTerms.standardBrickSize,
                                style: AppTextStyles.body(context),
                            ),
                            Text(
                              EngineeringTerms.brickWithJoint,
                                style: AppTextStyles.caption(context).copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
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
                const SizedBox(height: AppSpacing.md),
                Text(
                  EngineeringTerms.mortarRatio,
                  style: AppTextStyles.sectionTitle(context).copyWith(
                    color: colorScheme.primary,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
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
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  state.failure!.message,
                    style: AppTextStyles.body(context).copyWith(
                      color: colorScheme.error,
                    ),
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
            style: AppTextStyles.caption(context).copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            EngineeringTerms.resultSummary,
            style: AppTextStyles.sectionTitle(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          const Divider(),

          // Bricks
          SbListItemTile(
            title: EngineeringTerms.numberOfBricks,
            onTap: () {}, // Detail view entry
            trailing: Text(
              result.numberOfBricks.toString(),
              style: AppTextStyles.cardTitle(context).copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.brickVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.brickVolume.toStringAsFixed(3)} m³',
              style: AppTextStyles.body(context),
            ),
          ),

          const Divider(),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.lg

          // Cement & Sand
          SbListItemTile(
            title: EngineeringTerms.cementBags,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} ${AppStrings.bags}',
              style: AppTextStyles.cardTitle(context).copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          SbListItemTile(
            title: EngineeringTerms.sandVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: AppTextStyles.body(context),
            ),
          ),

          const Divider(),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.lg

          // Totals
          SbListItemTile(
            title: EngineeringTerms.wallVolume,
            onTap: () {}, // Detail view entry
            trailing: Text(
              '${result.wallVolume.toStringAsFixed(3)} m³',
              style: AppTextStyles.body(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(EngineeringTerms.mortarRatioLabel, style: AppTextStyles.caption(context)),
              Text(
                result.mortarRatio,
                style: AppTextStyles.caption(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
