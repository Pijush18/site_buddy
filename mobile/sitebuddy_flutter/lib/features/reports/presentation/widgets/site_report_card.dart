import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';

import 'package:site_buddy/core/theme/app_layout.dart';

/// FILE HEADER
/// ----------------------------------------------
/// File: site_report_card.dart
/// Feature: reports
/// Layer: presentation/widgets
///
/// PURPOSE:
/// Visually represents a compiled `SiteReport` on the screen precisely as it would map to standard A4 printing.
///
/// RESPONSIBILITIES:
/// - Reusably formats headers, dynamically iterates `ReportSection`s, and locks footer branding securely.
/// - Adheres exclusively to `AppLayout` constraints for paddings assuring strict enterprise UI/UX specifications.
/// ----------------------------------------------

import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';

import 'package:site_buddy/shared/domain/models/site_report.dart';

class SiteReportCard extends StatelessWidget {
  final SiteReport report;

  const SiteReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      padding: AppLayout.paddingMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          AppLayout.vGap24,
          ..._buildSections(context),
          AppLayout.vGap24,
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.only(bottom: AppLayout.pMedium),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.branding.logoPath != null) ...[
            Container(
              height: 48,
              width: 48,
              margin: const EdgeInsets.only(right: AppLayout.pMedium),

              child: Icon(SbIcons.site, color: colorScheme.primary),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SITE BUDDY REPORT',
                  style: SbTextStyles.title(context).copyWith(
                    letterSpacing: 1.2,
                    color: colorScheme.primary,
                  ),
                ),
                AppLayout.vGap8,
                _buildMetaText(
                  context,
                  'Company: ',
                  report.branding.companyName,
                ),
                _buildMetaText(context, 'Project: ', report.projectName),
                _buildMetaText(
                  context,
                  'Engineer: ',
                  report.branding.engineerName,
                ),
                _buildMetaText(
                  context,
                  'Date: ',
                  '${report.date.day}/${report.date.month}/${report.date.year}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaText(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: RichText(
        text: TextSpan(
          text: label,
          style: SbTextStyles.caption(context).copyWith(color: Colors.grey),
          children: [
            TextSpan(
              text: value,
              style: SbTextStyles.caption(context).copyWith(
                color: colorScheme.onSurface,

                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return report.sections.map((section) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppLayout.pMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppLayout.pSmall),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.title.toUpperCase(),
                      style: SbTextStyles.caption(context).copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppLayout.vGap8,
            ...section.content.map(
              (text) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppLayout.pSmall,
                  left: AppLayout.pSmall,
                ),
                child: Text(
                  text,
                  style: SbTextStyles.body(context).copyWith(
                    height: 1.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFooter(BuildContext context) {
//     final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: AppLayout.pSmall),

      child: Text(
        'Generated natively by Site Buddy',
        style: SbTextStyles.bodySecondary(context).copyWith(color: Colors.grey),
      ),
    );
  }
}