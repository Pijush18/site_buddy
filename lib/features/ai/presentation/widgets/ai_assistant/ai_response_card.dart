import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: ai_response_card.dart
/// Feature: ai_assistant
/// Layer: presentation/widgets
///
/// PURPOSE:
/// A factory widget that routes the `AiResponse` into the correct UI visualization.
/// ----------------------------------------------

import 'package:flutter/material.dart';

import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/ai_response.dart';

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
    if (response.error != null) {
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

      case AiIntent.createProject:
      case AiIntent.addToProject:
      case AiIntent.fetchProject:
      case AiIntent.leveling:
      case AiIntent.unknown:
        child = const _ErrorCard(
          message:
              'I did not understand that query. Try asking something like: "define concrete", "convert 10m to ft", or "10x5 slab m20".',
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.pSmall),
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppLayout.pSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          const SizedBox(height: AppLayout.pSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const SizedBox(width: AppLayout.pSmall),
              if (onCopy != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.copy,
                    label: 'Copy',
                    onPressed: onCopy,
                  ),
                ),
              if (onCopy != null && (onShare != null || onExportPdf != null))
                const SizedBox(width: AppLayout.pSmall),
              if (onShare != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.iosShare,
                    label: 'Share',
                    onPressed: onShare,
                  ),
                ),
              if (onShare != null &&
                  (onExportImage != null || onExportPdf != null))
                const SizedBox(width: AppLayout.pSmall),
              if (onExportImage != null)
                Expanded(
                  child: _MiniActionButton(
                    icon: SbIcons.image,
                    label: 'Image',
                    onPressed: onExportImage,
                  ),
                ),
              if (onExportImage != null && onExportPdf != null)
                const SizedBox(width: AppLayout.pSmall),
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
      padding: AppLayout.paddingSmall,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: AppLayout.pSmall),
          Text(
            label,
            style: SbTextStyles.caption(context).copyWith(color: colorScheme.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: AppLayout.pSmall),
          Expanded(
            child: Text(
              message,
              style: SbTextStyles.body(context).copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}