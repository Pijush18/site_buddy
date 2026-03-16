import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
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
    return const AppScreenWrapper(
      title: 'Smart Converter',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Conversion Assistant',
            style: TextStyle(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          _SegmentedToggleSection(),
          SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          _ConverterBodySection(),
          SizedBox(height: AppSpacing.lg), // Bottom padding
        ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CATEGORY',
          style: TextStyle(
            fontSize: AppFontSizes.tab,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
        SbDropdown<UnitType>(
          value: state.selectedType,
          items: UnitType.values,
          onChanged: (val) {
            if (val != null) controller.updateManualType(val);
          },
          itemLabelBuilder: (t) => t.name.toUpperCase(),
        ),
        const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
        Row(
          children: [
            Expanded(
              child: AppNumberField(
                label: 'Value',
                onChanged: (val) => controller.updateManualValue(context, val),
              ),
            ),
            const SizedBox(width: AppSpacing.md), // Replaced AppLayout.hGap16
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM',
                    style: TextStyle(
                      fontSize: AppFontSizes.tab,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
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
                    style: TextStyle(
                      fontSize: AppFontSizes.tab,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
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
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: SbCard(
        child: Text(
          error,
          style: TextStyle(
            fontSize: AppFontSizes.subtitle,
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
      suffixIcon: IconButton(icon: const Icon(SbIcons.send), onPressed: onSubmit),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg), // Replaced AppLayout.paddingLarge
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SbIcons.lightbulb,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          const Text(
            'Try asking the AI:',
            style: TextStyle(fontSize: AppFontSizes.subtitle),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          Text(
            '"50 kg to lbs"\n"10x12x0.5 ft m25"\n"100 sqm sqft"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.subtitle,
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
        const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
        SbCard(
          child: Column(
            children: [
              Text(
                fromLabel,
                style: TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(SbIcons.arrowDown, color: colorScheme.primary, size: 20),
              Text(
                '${mainValue.toStringAsFixed(2)} $toSymbol',
                style: TextStyle(
                  fontSize: 32, // headlineLarge equivalent
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        if (secondaries.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          Text(
            'ALSO EQUALS',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: colorScheme.secondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: secondaries.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm / 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${e.value.toStringAsFixed(2)} ${e.key}',
                  style: const TextStyle(fontSize: AppFontSizes.subtitle),
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
        const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
        Text(
          'ESTIMATE: ${query.length} x ${query.width} x ${query.depth} (${query.grade?.label})',
          style: TextStyle(
            fontSize: AppFontSizes.tab,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
        SbCard(
          child: Column(
            children: [
              SbListItem(
                title: 'Wet Volume',
                trailing: Text(
                  '${result.volume.toStringAsFixed(2)} m³',
                  style: const TextStyle(fontSize: AppFontSizes.subtitle),
                ),
              ),
              SbListItem(
                title: 'Dry Volume',
                trailing: Text(
                  '${result.dryVolume.toStringAsFixed(2)} m³',
                  style: const TextStyle(fontSize: AppFontSizes.subtitle),
                ),
              ),
              SbListItem(
                title: 'Cement',
                trailing: Text(
                  '${result.cementBags.toStringAsFixed(0)} Bags',
                  style: TextStyle(
                    fontSize: AppFontSizes.subtitle,
                    fontWeight: FontWeight.bold,
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