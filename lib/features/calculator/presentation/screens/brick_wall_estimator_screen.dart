import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/features/calculator/application/controllers/brick_wall_controller.dart';
import 'package:site_buddy/shared/domain/models/mortar_ratio.dart';
import 'package:site_buddy/shared/domain/models/brick_wall_result.dart';

class BrickWallEstimatorScreen extends ConsumerWidget {
  const BrickWallEstimatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brickWallProvider);
    final controller = ref.read(brickWallProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SbPage.form(
      title: 'Brick Wall Estimator',
      primaryAction: SbButton.primary(
        label: state.isLoading ? 'Calculating...' : 'Calculate Materials',
        icon: SbIcons.calculator,
        isLoading: state.isLoading,
        onPressed: controller.calculate,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Dimensions section ─────────────────────────────────────────
          const _SectionLabel(label: 'Wall Dimensions'),
          const SizedBox(height: AppLayout.sm),

          AppNumberField(
            label: 'Wall Length (m)',
            hint: 'e.g. 10.0',
            suffixIcon: SbIcons.ruler,
            onChanged: controller.updateLength,
          ),
          const SizedBox(height: AppLayout.sm),

          AppNumberField(
            label: 'Wall Height (m)',
            hint: 'e.g. 3.0',
            suffixIcon: SbIcons.height,
            onChanged: controller.updateHeight,
          ),
          const SizedBox(height: AppLayout.sm),

          AppNumberField(
            label: 'Wall Thickness (m)',
            hint: 'e.g. 0.23 for 9-inch',
            suffixIcon: SbIcons.layers,
            onChanged: controller.updateThickness,
          ),

          const SizedBox(height: AppLayout.lg),

          // ── Brick & mortar section ─────────────────────────────────────
          const _SectionLabel(label: 'Brick & Mortar'),
          const SizedBox(height: AppLayout.sm),

          SbCard(
            child: Row(
              children: [
                Icon(SbIcons.crop, size: 20, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: AppLayout.sm),
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
                      const SizedBox(height: AppLayout.xs),
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

          const SizedBox(height: AppLayout.sm),

          Text(
            'MORTAR RATIO',
            style: SbTextStyles.title(context).copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppLayout.sm),

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

          const SizedBox(height: AppLayout.lg),

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
            const SizedBox(height: AppLayout.lg),
          ],

          // ── Result cards ───────────────────────────────────────────────
          if (state.result != null) ...[
            _ResultSection(result: state.result!),
            const SizedBox(height: AppLayout.lg),
          ],

          // ── Reset button ─────────────────────────────────────────────
          SbButton.outline(
            label: 'Reset',
            icon: SbIcons.refresh,
            onPressed: controller.reset,
            width: double.infinity,
          ),

          const SizedBox(height: AppLayout.lg),

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ESTIMATION RESULTS  —  ${result.mortarRatio} Mortar',
          style: SbTextStyles.title(context).copyWith(
            color: colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppLayout.sm),

        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.gridView,
                title: 'Bricks Required',
                color: colorScheme.tertiary,
              ),
              Divider(height: AppLayout.lg, color: colorScheme.outline),
              SbListItem(
                title: 'Number of Bricks',
                trailing: Text(
                  result.numberOfBricks.toString(),
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SbListItem(
                title: '(incl. 5% wastage)',
                trailing: Text(
                  '${result.brickVolume.toStringAsFixed(3)} m³ brick vol.',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Wall Volume',
                trailing: Text(
                  '${result.wallVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppLayout.sm),

        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.inventory,
                title: 'Cement Bags',
                color: colorScheme.primary,
              ),
              Divider(height: AppLayout.lg, color: colorScheme.outline),
              SbListItem(
                title: 'Cement Bags (50 kg)',
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} bags',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SbListItem(
                title: 'Cement Weight',
                trailing: Text(
                  '${result.cementWeight.toStringAsFixed(1)} kg',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Mix Ratio',
                trailing: Text(
                  result.mortarRatio,
                  style: SbTextStyles.body(context),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppLayout.sm),

        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.terrain,
                title: 'Sand Volume',
                color: colorScheme.secondary,
              ),
              Divider(height: AppLayout.lg, color: colorScheme.outline),
              SbListItem(
                title: 'Sand Volume',
                trailing: Text(
                  '${result.sandVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppLayout.sm),

        SbCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(
                icon: SbIcons.waterDrop,
                title: 'Mortar Volume',
                color: colorScheme.primaryContainer,
              ),
              Divider(height: AppLayout.lg, color: colorScheme.outline),
              SbListItem(
                title: 'Wet Mortar Volume',
                trailing: Text(
                  '${result.mortarVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Dry Mortar Volume',
                trailing: Text(
                  '${result.dryMortarVolume.toStringAsFixed(3)} m³',
                  style: SbTextStyles.body(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _CardHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppLayout.sm),
        Text(
          title,
          style: SbTextStyles.title(context).copyWith(color: color),
        ),
      ],
    );
  }
}
