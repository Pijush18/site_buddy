import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/ai_response.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/knowledge_card.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/conversion_card.dart';
import 'package:site_buddy/features/ai/presentation/widgets/ai_assistant/calculation_card.dart';

class AiResponseCard extends StatelessWidget {
  final AiResponse response;
  final VoidCallback? onSaveToProject;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onExportImage;
  final VoidCallback? onExportPdf;

  const AiResponseCard({
    super.key,
    required this.response,
    this.onSaveToProject,
    this.onCopy,
    this.onShare,
    this.onExportImage,
    this.onExportPdf,
  });

  @override
  Widget build(BuildContext context) {
    if (response.error != null && response.intent == AiIntent.unknown) {
      return _ErrorCard(message: response.error!);
    }

    Widget child;

    switch (response.intent) {
      case AiIntent.knowledge:
        if (response.knowledge == null) {
          child = const _ErrorCard(message: 'Knowledge topic not populated.');
        } else {
          child = KnowledgeCard(topic: response.knowledge!);
        }
        break;

      case AiIntent.conversion:
        if (response.conversion == null) {
          child = const _ErrorCard(message: 'Conversion data missing.');
        } else {
          child = ConversionCard(
            result: response.conversion!,
            inputTitle: response.conversionFromTitle ?? 'Input',
            outputUnit: response.conversionToTitle ?? 'Result',
          );
        }
        break;

      case AiIntent.calculation:
      case AiIntent.calculateConcrete:
        if (response.calculation == null) {
          child = const _ErrorCard(message: 'Calculation data missing.');
        } else {
          child = CalculationCard(
            result: response.calculation!,
            dimensionsTitle: response.calculationTitle ?? 'Unknown Dimensions',
          );
        }
        break;

      case AiIntent.concreteQuantity:
      case AiIntent.brickQuantity:
      case AiIntent.steelWeight:
      case AiIntent.shutteringArea:
      case AiIntent.excavationVolume:
      case AiIntent.slabDesign:
      case AiIntent.beamDesign:
      case AiIntent.columnDesign:
      case AiIntent.footingDesign:
        child = _ToolSuggestionCard(
          intent: response.intent,
          prefillData: response.prefillData,
          message: response.text ?? response.error,
        );
        break;

      case AiIntent.createProject:
      case AiIntent.addToProject:
      case AiIntent.fetchProject:
      case AiIntent.leveling:
      case AiIntent.unknown:
        child = _ErrorCard(
          message:
              response.error ?? 'I did not understand that query. Try asking something like: "brick work calculator" or "calculate excavation".',
        );
        break;
    }

    final hasAnyAction =
        onSaveToProject != null ||
        onCopy != null ||
        onShare != null ||
        onExportImage != null ||
        onExportPdf != null;

    if (!hasAnyAction) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
        child: child,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          const SizedBox(height: SbSpacing.sm),
          Row(
            children: [
              if (onSaveToProject != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.bookmarkAdd,
                    label: 'Save',
                    onPressed: onSaveToProject,
                  ),
                ),
              if (onSaveToProject != null &&
                  (onCopy != null || onShare != null || onExportPdf != null))
                const SizedBox(width: SbSpacing.sm),
              if (onCopy != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.copy,
                    label: 'Copy',
                    onPressed: onCopy,
                  ),
                ),
              if (onCopy != null && (onShare != null || onExportPdf != null))
                const SizedBox(width: SbSpacing.sm),
              if (onShare != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.iosShare,
                    label: 'Share',
                    onPressed: onShare,
                  ),
                ),
              if (onShare != null && (onExportPdf != null))
                const SizedBox(width: SbSpacing.sm),
              if (onExportPdf != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.pdf,
                    label: 'PDF',
                    onPressed: onExportPdf,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _MiniActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: SbSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ToolSuggestionCard extends StatelessWidget {
  final AiIntent intent;
  final ToolPrefillData? prefillData;
  final String? message;

  const _ToolSuggestionCard({
    required this.intent,
    this.prefillData,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    String route = '';
    IconData icon = SbIcons.calculator;

    switch (intent) {
      case AiIntent.concreteQuantity:
        title = 'Concrete Estimator';
        route = '/calculator/material';
        break;
      case AiIntent.brickQuantity:
        title = 'Brick Wall Estimator';
        route = '/calculator/brick-wall';
        icon = SbIcons.gridView;
        break;
      case AiIntent.steelWeight:
        title = 'Steel Weight Estimator';
        route = '/calculator/rebar';
        icon = SbIcons.rebar;
        break;
      case AiIntent.excavationVolume:
        title = 'Excavation Estimator';
        route = '/calculator/excavation';
        icon = SbIcons.terrain;
        break;
      case AiIntent.shutteringArea:
        title = 'Shuttering Area Estimator';
        route = '/calculator/shuttering';
        icon = SbIcons.layers;
        break;
      case AiIntent.slabDesign:
        title = 'Slab Design';
        route = '/design/slab/input';
        icon = SbIcons.gridView;
        break;
      case AiIntent.beamDesign:
        title = 'Beam Design';
        route = '/design/beam/input';
        icon = SbIcons.viewArray;
        break;
      case AiIntent.columnDesign:
        title = 'Column Design';
        route = '/design/column/input';
        icon = SbIcons.viewColumn;
        break;
      case AiIntent.footingDesign:
        title = 'Footing Design';
        route = '/design/footing/type';
        icon = SbIcons.foundation;
        break;
      default:
        return const SizedBox.shrink();
    }

    String? prefillSummary;
    if (prefillData != null) {
      if (prefillData is ConcretePrefillData) {
        final p = prefillData as ConcretePrefillData;
        prefillSummary = 'Detected: ${p.length ?? "_"}m × ${p.width ?? "_"}m × ${p.thickness ?? "_"}m';
      } else if (prefillData is BrickPrefillData) {
        final p = prefillData as BrickPrefillData;
        prefillSummary = 'Detected: ${p.length ?? "_"}m × ${p.height ?? "_"}m × ${p.thickness ?? "_"}m';
      } else if (prefillData is SteelWeightPrefillData) {
        final p = prefillData as SteelWeightPrefillData;
        prefillSummary = 'Detected: L=${p.length ?? "_"}m, D=${p.diameter ?? "_"}mm, S=${p.spacing ?? "_"}mm';
      } else if (prefillData is ExcavationPrefillData) {
        final p = prefillData as ExcavationPrefillData;
        prefillSummary = 'Detected: ${p.length ?? "_"}m × ${p.width ?? "_"}m × ${p.depth ?? "_"}m';
      } else if (prefillData is ShutteringPrefillData) {
        final p = prefillData as ShutteringPrefillData;
        prefillSummary = 'Detected: ${p.length ?? "_"}m × ${p.width ?? "_"}m × ${p.depth ?? "_"}m';
      } else if (prefillData is SlabDesignPrefillData) {
        final p = prefillData as SlabDesignPrefillData;
        prefillSummary = 'Detected: Lx=${p.lx ?? "_"}m, Ly=${p.ly ?? "_"}m, D=${p.depth ?? "_"}mm';
      } else if (prefillData is BeamDesignPrefillData) {
        final p = prefillData as BeamDesignPrefillData;
        prefillSummary = 'Detected: L=${p.length ?? "_"}m, W=${p.width ?? "_"}m, D=${p.depth ?? "_"}mm';
      } else if (prefillData is ColumnDesignPrefillData) {
        final p = prefillData as ColumnDesignPrefillData;
        prefillSummary = 'Detected: W=${p.width ?? "_"}m, D=${p.depth ?? "_"}m, H=${p.height ?? "_"}m';
      } else if (prefillData is FootingDesignPrefillData) {
        final p = prefillData as FootingDesignPrefillData;
        prefillSummary = 'Detected: L=${p.length ?? "_"}m, W=${p.width ?? "_"}m, D=${p.depth ?? "_"}m';
      }
    }

    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) ...[
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: SbSpacing.sm),
          ],
          SbListItemTile(
            icon: icon,
            color: Theme.of(context).colorScheme.primary,
            title: title,
            subtitle: prefillSummary ?? 'Open the specialized tool for this calculation.',
            onTap: () => context.push(route, extra: prefillData),
          ),
          const SizedBox(height: SbSpacing.sm),
          SbButton.primary(
            label: 'Launch $title',
            icon: SbIcons.assistant,
            width: double.infinity,
            onPressed: () => context.push(route, extra: prefillData),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SbCard(
      color: colorScheme.errorContainer.withValues(alpha: 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(SbIcons.error, color: colorScheme.error),
          const SizedBox(width: SbSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
        ],
      ),
    );
  }
}








