import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_radius.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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
    return SbPage.scaffold(
      title: 'Smart Converter',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Conversion Assistant',
            style: Theme.of(context).textTheme.titleLarge!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.md),
          const _SegmentedToggleSection(),
          const SizedBox(height: SbSpacing.xl),
          const _ConverterBodySection(),
          const SizedBox(height: SbSpacing.xl), // Bottom padding
        ],
      ),
    );
  }
}

class _SegmentedToggleSection extends ConsumerWidget {
  const _SegmentedToggleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.read(converterModeProvider);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CATEGORY',
          style: Theme.of(context).textTheme.labelMedium!,
        ),
        const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
        SbDropdown<UnitType>(
          value: state.selectedType,
          items: UnitType.values,
          onChanged: (val) {
            if (val != null) controller.updateManualType(val);
          },
          itemLabelBuilder: (t) => t.name.toUpperCase(),
        ),
        const SizedBox(height: SbSpacing.md),
        Row(
          children: [
            Expanded(
              child: SbInput(
                label: 'Value',
                onChanged: (val) => controller.updateManualValue(context, val),
              ),
            ),
            const SizedBox(width: SbSpacing.lg), // Replaced const SizedBox(width: SbSpacing.lg)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM',
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                  const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
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
        const SizedBox(height: SbSpacing.md),
        Row(
          children: [
            const Spacer(),
            AppIconButton(
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
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
                  const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
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
    return Container(
      padding: const EdgeInsets.only(top: SbSpacing.xl),
      child: SbCard(
        child: Text(
          error,
          style: Theme.of(context).textTheme.bodyLarge!,
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
      suffixIcon: IconButton(icon: const Icon(SbIcons.send), onPressed: onSubmit),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(SbSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SbIcons.lightbulb,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: SbSpacing.md),
          Text(
            'Try asking the AI:',
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
          Text(
            '"50 kg to lbs"\n"10x12x0.5 ft m25"\n"100 sqm sqft"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!,
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
        const SizedBox(height: SbSpacing.xl),
        SbCard(
          child: Column(
            children: [
              Text(
                fromLabel,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              Icon(SbIcons.arrowDown, color: colorScheme.onSurfaceVariant, size: 20),

              Text(
                '${mainValue.toStringAsFixed(2)} $toSymbol',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
            ],
          ),
        ),
        if (secondaries.isNotEmpty) ...[
          const SizedBox(height: SbSpacing.xl),
          Text(
            'ALSO EQUALS',
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
          Wrap(
            spacing: SbSpacing.md,
            runSpacing: SbSpacing.md,
            children: secondaries.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg, vertical: SbSpacing.xs),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: SbRadius.borderSmall,
                ),
                child: Text(
                  '${e.value.toStringAsFixed(2)} ${e.key}',
                  style: Theme.of(context).textTheme.bodyLarge!,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: SbSpacing.xl),
        Text(
          'ESTIMATE: ${query.length} x ${query.width} x ${query.depth} (${query.grade?.label})',
          style: Theme.of(context).textTheme.labelMedium!,
        ),
        const SizedBox(height: SbSpacing.sm), // Replaced SizedBox(height: SbSpacing.sm)
        SbCard(
          child: Column(
            children: [
              SbListItemTile(
                title: 'Wet Volume',
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '${result.volume.toStringAsFixed(2)} m³',
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
              SbListItemTile(
                title: 'Dry Volume',
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '${result.dryVolume.toStringAsFixed(2)} m³',
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
              SbListItemTile(
                title: 'Cement',
                onTap: () {}, // Detail view entry
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} Bags',
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}










