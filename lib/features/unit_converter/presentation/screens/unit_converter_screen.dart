import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/app_number_field.dart';
import 'package:site_buddy/core/widgets/segmented_toggle.dart';
import 'package:site_buddy/shared/domain/models/ai_query.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/unit_definition.dart';
import 'package:site_buddy/features/unit_converter/domain/entities/engineering_units.dart';
import 'package:site_buddy/features/unit_converter/domain/enums/unit_type.dart';
import 'package:site_buddy/shared/domain/models/material_result.dart';
import 'package:site_buddy/features/unit_converter/application/controllers/converter_controller.dart';
import 'package:site_buddy/features/unit_converter/application/controllers/converter_mode_provider.dart';
import 'package:site_buddy/features/unit_converter/application/controllers/converter_state.dart';

class UnitConverterScreen extends ConsumerWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
    return SbPage.detail(
      title: 'Smart Converter',
      body: Padding(
        padding: AppLayout.paddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Conversion Assistant',
              style: SbTextStyles.title(context),
              textAlign: TextAlign.center,
            ),
            AppLayout.vGap24,
            const _SegmentedToggleSection(),
            AppLayout.vGap24,
            const _ConverterBodySection(),
            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}

class _SegmentedToggleSection extends ConsumerWidget {
  const _SegmentedToggleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(converterModeProvider);
    return SegmentedToggle<ConverterMode>(
      items: const [ConverterMode.ai, ConverterMode.manual],
      value: mode,
      labelBuilder: (m) =>
          m == ConverterMode.ai ? 'AI Assistant' : 'Manual Mode',
      onChanged: (newMode) {
        ref.read(converterModeProvider.notifier).setMode(newMode);
      },
    );
  }
}

class _ConverterBodySection extends ConsumerWidget {
  const _ConverterBodySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(converterModeProvider);
    final state = ref.watch(converterControllerProvider);
    final controller = ref.read(converterControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mode == ConverterMode.ai)
          _buildAiInputBar(
            context,
            state.input,
            controller.updateInput,
            () => controller.processInput(context),
          )
        else
          _buildManualInputSection(context, state, controller),
        if (state.error != null) _buildErrorDisplay(state.error!, context),
        if (state.conversionResult == null &&
            state.concreteResult == null &&
            state.error == null)
          _buildEmptyState(context),
        if (state.conversionResult != null)
          _buildConversionResult(
            context,
            state.conversionResult!.mainValue,
            state.conversionResult!.secondaryValues,
            state.parsedQuery?.fromUnit ?? state.fromUnit?.name ?? 'Input',
            state.parsedQuery?.toUnit ?? state.toUnit?.symbol ?? '',
          ),
        if (state.concreteResult != null && state.parsedQuery != null)
          _buildConcreteResult(
            state.parsedQuery!,
            state.concreteResult!,
            context,
          ),
      ],
    );
  }

  Widget _buildManualInputSection(
    BuildContext context,
    ConverterState state,
    ConverterController controller,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
//     final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CATEGORY',
          style: SbTextStyles.caption(context).copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppLayout.vGap8,
        SbDropdown<UnitType>(
          value: state.selectedType,
          items: UnitType.values,
          onChanged: (val) {
            if (val != null) controller.updateManualType(val);
          },
          itemLabelBuilder: (t) => t.name.toUpperCase(),
        ),
        AppLayout.vGap24,
        Row(
          children: [
            Expanded(
              child: AppNumberField(
                label: 'Value',
                onChanged: (val) => controller.updateManualValue(context, val),
              ),
            ),
            AppLayout.hGap16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM',
                    style: SbTextStyles.caption(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap8,
                  SbDropdown<UnitDefinition>(
                    value: state.fromUnit,
                    items: EngineeringUnits.getUnitsForType(state.selectedType),
                    onChanged: (val) => controller.updateFromUnit(context, val),
                    itemLabelBuilder: (u) => u.name,
                  ),
                ],
              ),
            ),
          ],
        ),
        AppLayout.vGap16,
        Row(
          children: [
            const Spacer(),
            SbButton.icon(
              icon: SbIcons.swapVert,
              onPressed: () => controller.swapUnits(context),
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TO',
                    style: SbTextStyles.caption(context).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppLayout.vGap8,
                  SbDropdown<UnitDefinition>(
                    value: state.toUnit,
                    items: EngineeringUnits.getUnitsForType(state.selectedType),
                    onChanged: (val) => controller.updateToUnit(context, val),
                    itemLabelBuilder: (u) => u.name,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(String error, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppLayout.lg),
      child: SbCard(
        child: Text(
          error,
          style: SbTextStyles.body(context).copyWith(
            color: theme.colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAiInputBar(
    BuildContext context,
    String currentValue,
    Function(String) onChanged,
    VoidCallback onSubmit,
  ) {
    return SbInput(
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmit(),
      hint: 'e.g., "10 ft to m" or "10x5x0.2 slab m20"',
      prefixIcon: const Icon(SbIcons.assistant),
      suffixIcon: SbButton.icon(icon: SbIcons.send, onPressed: onSubmit),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: AppLayout.paddingLarge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SbIcons.lightbulb,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          AppLayout.vGap16,
          Text('Try asking the AI:', style: SbTextStyles.body(context)),
          AppLayout.vGap8,
          Text(
            '"50 kg to lbs"\n"10x12x0.5 ft m25"\n"100 sqm sqft"',
            textAlign: TextAlign.center,
            style: SbTextStyles.bodySecondary(context).copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionResult(
    BuildContext context,
    double mainValue,
    Map<String, double> secondaries,
    String fromLabel,
    String toSymbol,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLayout.vGap24,
        SbCard(
          child: Column(
            children: [
              Text(
                fromLabel,
                style: SbTextStyles.body(context).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(SbIcons.arrowDown, color: colorScheme.primary, size: 20),
              Text(
                '${mainValue.toStringAsFixed(2)} $toSymbol',
                style: SbTextStyles.headlineLarge(context).copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        if (secondaries.isNotEmpty) ...[
          AppLayout.vGap24,
          Text(
            'ALSO EQUALS',
            style: SbTextStyles.caption(context).copyWith(
              color: colorScheme.secondary,
              letterSpacing: 1.1,
            ),
          ),
          AppLayout.vGap8,
          Wrap(
            spacing: AppLayout.sm,
            runSpacing: AppLayout.sm,
            children: secondaries.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.md,
                  vertical: AppLayout.xs,
                ),

                child: Text(
                  '${e.value.toStringAsFixed(2)} ${e.key}',
                  style: SbTextStyles.bodySecondary(context),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildConcreteResult(
    AiQuery query,
    MaterialResult result,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLayout.vGap24,
        Text(
          'ESTIMATE: ${query.length} x ${query.width} x ${query.depth} (${query.grade?.label})',
          style: SbTextStyles.caption(context).copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        AppLayout.vGap8,
        SbCard(
          child: Column(
            children: [
              SbListItem(
                title: 'Wet Volume',
                trailing: Text(
                  '${result.volume.toStringAsFixed(2)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Dry Volume',
                trailing: Text(
                  '${result.dryVolume.toStringAsFixed(2)} m³',
                  style: SbTextStyles.body(context),
                ),
              ),
              SbListItem(
                title: 'Cement',
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} Bags',
                  style: SbTextStyles.body(context).copyWith(
                    color: theme.colorScheme.primary,
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