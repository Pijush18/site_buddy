import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

import 'package:site_buddy/features/structural/column/application/column_design_controller.dart';
import 'package:site_buddy/features/structural/column/domain/column_enums.dart';
import 'package:site_buddy/core/data/code_references/is_456_references.dart';
import 'package:site_buddy/core/services/educational_mode_service.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/slenderness_diagram.dart';
import 'package:site_buddy/features/structural/shared/presentation/widgets/engineering_diagrams/design_result_card.dart';

/// SCREEN: SlendernessCheckScreen
/// PURPOSE: Slenderness classification (Step 3).
class SlendernessCheckScreen extends ConsumerWidget {
  const SlendernessCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(columnDesignControllerProvider);

    return SbPage.form(
      title: l10n.titleSlenderness,
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryCTA(
            label: l10n.actionNext,
            onPressed: () {
              context.push('/column/design');
            },
            icon: Icons.navigate_next,
          ),
          const SizedBox(height: AppSpacing.sm),
          GhostButton(
            label: l10n.actionBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          // ── STEP HEADER ──
          SbSection(
            child: Text(
              l10n.labelStep3Stability,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),

          // ── CLASSIFICATION SECTION ──
          SbSection(
            title: l10n.labelClassification,
            child: DesignResultCard(
              title: l10n.labelVerification,
              isSafe: state.isShort,
              items: [
                DesignResultItem(
                  label: l10n.labelStatus,
                  value: state.isShort ? l10n.labelShortColumn : l10n.labelSlenderColumn,
                  isCritical: true,
                ),
                DesignResultItem(
                   label: l10n.labelRule,
                  value: state.isShort ? 'λ < 12' : 'λ ≥ 12', // Symbols are usually not localized
                   subtitle: l10n.msgCodeNoteSlenderness,
                ),
              ],
            ),
          ),

          // ── VISUALIZATION SECTION ──
          SbSection(
            title: l10n.labelGeometry,
            child: SlendernessDiagram(
              slendernessX: state.slendernessX,
              slendernessY: state.slendernessY,
              lex: state.lex,
              ley: state.ley,
              b: state.b,
              d: state.d,
              isCircular: state.type == ColumnType.circular,
            ),
          ),
          if (ref.watch(educationalModeProvider))
            const SbSection(
              child: CodeReferenceCard(
                reference: IS456References.slendernessRatio,
              ),
            ),

          // ── PARAMETERS SECTION ──
          SbSection(
            title: l10n.labelEffectiveLength,
            child: DesignResultCard(
              title: l10n.labelParameters,
              isSafe: true,
              items: [
                DesignResultItem(
                  label: l10n.labelLexMajor,
                  value: state.lex.toInt().toString(),
                  unit: 'mm',
                ),
                DesignResultItem(
                  label: l10n.labelLeyMinor,
                  value: state.ley.toInt().toString(),
                  unit: 'mm',
                ),
                DesignResultItem(
                  label: l10n.labelUnsupportedLengthLUnit,
                  value: state.length.toInt().toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}













