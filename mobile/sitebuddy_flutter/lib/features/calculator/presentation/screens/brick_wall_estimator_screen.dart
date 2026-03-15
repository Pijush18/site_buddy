import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
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

    return SbPage.detail(
      title: 'Brick Wall Estimator',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Dimensions section ─────────────────────────────────────────
          const _SectionLabel(label: 'Wall Dimensions'),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Wall Length (m)',
            hint: 'e.g. 10.0',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
            errorText: lError,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Wall Height (m)',
            hint: 'e.g. 3.0',
            suffixIcon: SbIcons.height,
            onChanged: controller.updateHeight,
            errorText: hError,
          ),
          AppLayout.vGap8,

          AppNumberField(
            label: 'Wall Thickness (m)',
            hint: 'e.g. 0.23 for 9-inch',
            suffixIcon: SbIcons.layers,
            onChanged: controller.updateThickness,
            errorText: tError,
          ),

          AppLayout.vGap24,

          // ── Brick & mortar section ─────────────────────────────────────
          const _SectionLabel(label: 'Brick & Mortar'),
          AppLayout.vGap8,

          SbCard(
            child: Row(
              children: [
                Icon(SbIcons.crop, size: 20, color: colorScheme.onSurfaceVariant),
                AppLayout.hGap8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brick Size',
                        style: SbTextStyles.caption(context).copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      AppLayout.vGap4,
                      Text(
                        '190 × 90 × 90 mm  (IS modular standard)',
                        style: SbTextStyles.body(context),
                      ),
                      Text(
                        'With 10 mm mortar joint: 200 × 100 × 100 mm',
                        style: SbTextStyles.caption(context).copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SbButton.icon(
                  icon: SbIcons.info,
                  tooltip: 'IS 2212:1991 standard brick dimensions',
                  onPressed: () {
                    SbFeedback.showToast(
                      context: context,
                      message:
                          'IS modular brick: 190×90×90 mm (without joint).\n'
                          'Custom brick sizes coming soon.',
                    );
                  },
                ),
              ],
            ),
          ),

          AppLayout.vGap8,

          Text(
            'MORTAR RATIO',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap8,

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

          AppLayout.vGap24,

          AppLayout.vGap24,
          ActionButtonsGroup(
            children: [
              SbButton.outline(
                label: 'Clear All',
                icon: SbIcons.refresh,
                onPressed: controller.reset,
              ),
              SbButton.primary(
                label: state.isLoading ? 'Calculating...' : 'Calculate',
                icon: SbIcons.calculator,
                isLoading: state.isLoading,
                onPressed: isValid ? controller.calculate : null,
              ),
            ],
          ),
          AppLayout.vGap24,

          // ── Error banner ───────────────────────────────────────────────
          if (state.failure != null) ...[
            SbCard(
              child: Padding(
                padding: AppLayout.paddingMd,
                child: Text(
                  state.failure!.message,
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AppLayout.vGap24,
          ],

          // ── Result cards ───────────────────────────────────────────────
          if (state.result != null) ...[
            _ResultSection(result: state.result!),
            AppLayout.vGap24,
          ],

          // ── IS code reference note ─────────────────────────────────────
          Text(
            'Calculations per IS 2212:1991 (Brick masonry code of practice).\n'
            'IS modular brick: 190 × 90 × 90 mm · Joint: 10 mm · Wastage: 5%.\n'
            'Mortar dry volume factor: 1.30 · Cement density: 1440 kg/m³.',
            style: SbTextStyles.caption(context).copyWith(
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      style: SbTextStyles.title(context).copyWith(
        color: theme.colorScheme.primary,
        letterSpacing: 1.1,
      ),
      textAlign: TextAlign.center,
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
            'RESULT SUMMARY',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          AppLayout.vGap16,
          const Divider(),

          // Bricks
          SbListItem(
            title: 'Number of Bricks',
            trailing: Text(
              result.numberOfBricks.toString(),
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SbListItem(
            title: 'Brick Volume',
            trailing: Text(
              '${result.brickVolume.toStringAsFixed(3)} m³',
              style: SbTextStyles.body(context),
            ),
          ),

          const Divider(height: AppLayout.lg),

          // Cement & Sand
          SbListItem(
            title: 'Cement Bags (50 kg)',
            trailing: Text(
              '${result.cementBags.toStringAsFixed(0)} bags',
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SbListItem(
            title: 'Sand Volume',
            trailing: Text(
              '${result.sandVolume.toStringAsFixed(3)} m³',
              style: SbTextStyles.body(context),
            ),
          ),

          const Divider(height: AppLayout.lg),

          // Totals
          SbListItem(
            title: 'Wall Volume',
            trailing: Text(
              '${result.wallVolume.toStringAsFixed(3)} m³',
              style: SbTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mortar Ratio:', style: SbTextStyles.caption(context)),
              Text(result.mortarRatio, style: SbTextStyles.bodySecondary(context)),
            ],
          ),
        ],
      ),
    );
  }
}

