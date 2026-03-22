import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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

    return SbPage.scaffold(
      title: ScreenTitles.brickWallEstimator,
      body: SbSectionList(
        sections: [
          // ── SECTION 1: DIMENSIONS ─────────────────────────────────────────
          SbSection(
            title: EngineeringTerms.wallDimensions,
            child: SbCard(
              child: Column(
                children: [
                  SbInput(
                    label: EngineeringTerms.wallLength,
                    hint: EngineeringTerms.lengthHint,
                    suffixIcon: Icon(SbIcons.ruler, size: 20, color: colorScheme.onSurfaceVariant),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: controller.updateLength,
                    errorText: lError,
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: EngineeringTerms.wallHeight,
                    hint: EngineeringTerms.heightHint,
                    suffixIcon: Icon(SbIcons.height, size: 20, color: colorScheme.onSurfaceVariant),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: controller.updateHeight,
                    errorText: hError,
                  ),
                  const SizedBox(height: SbSpacing.md),
                  SbInput(
                    label: EngineeringTerms.wallThickness,
                    hint: EngineeringTerms.brickThicknessHint,
                    suffixIcon: Icon(SbIcons.layers, size: 20, color: colorScheme.onSurfaceVariant),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: controller.updateThickness,
                    errorText: tError,
                  ),
                ],
              ),
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
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: SbSpacing.xs),
                            Text(
                              EngineeringTerms.standardBrickSize,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              EngineeringTerms.brickWithJoint,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppIconButton(
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
                const SizedBox(height: SbSpacing.md),
                SbDropdown<MortarRatio>(
                  label: EngineeringTerms.mortarRatio,
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
              SecondaryButton(isOutlined: true, 
                label: AppStrings.clearAll,
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              PrimaryCTA(
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // ── SECTION 5: RESULTS ─────────────────────────────────────────
          if (state.result != null)
            _ResultSection(result: state.result!),
          if (state.result != null)
            SbSection(
              child: PrimaryCTA(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf,
                onPressed: () {
                  debugPrint("Export PDF clicked - TODO: implement");
                },
              ),
            ),

          // ── SECTION 6: COMPLIANCE FOOTNOTE ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SbSpacing.lg),
            child: Text(
              EngineeringTerms.brickMasonryRef,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
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

    return SbSection(
      title: EngineeringTerms.resultSummary,
      child: SbCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bricks
            SbListItemTile(
              title: EngineeringTerms.numberOfBricks,
              onTap: () {}, // Detail view entry
              trailing: Text(
                result.numberOfBricks.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.brickVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.brickVolume.toStringAsFixed(3)} m³',
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: SbSpacing.sm),
              child: Divider(height: 1),
            ),

            // Cement & Sand
            SbListItemTile(
              title: EngineeringTerms.cementBags,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.cementBags.toStringAsFixed(0)} ${AppStrings.bags}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SbListItemTile(
              title: EngineeringTerms.sandVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.sandVolume.toStringAsFixed(3)} m³',
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: SbSpacing.sm),
              child: Divider(height: 1),
            ),

            // Totals
            SbListItemTile(
              title: EngineeringTerms.wallVolume,
              onTap: () {}, // Detail view entry
              trailing: Text(
                '${result.wallVolume.toStringAsFixed(3)} m³',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(SbSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    EngineeringTerms.mortarRatioLabel, 
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SbSpacing.sm,
                      vertical: SbSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: SbRadius.borderSmall,
                    ),
                    child: Text(
                      result.mortarRatio,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}









