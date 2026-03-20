import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';

class SiteReportCard extends StatelessWidget {
  final SiteReport report;

  const SiteReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.lg),
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
      padding: const EdgeInsets.only(bottom: SbSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.branding.logoPath != null) ...[
            Container(
              height: 48,
              width: 48,
              margin: const EdgeInsets.only(right: SbSpacing.lg),
              child: Icon(SbIcons.site, color: colorScheme.primary),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SITE BUDDY REPORT',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: SbSpacing.sm),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: SbSpacing.xs),
      child: RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(context).textTheme.labelMedium!,
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.labelMedium!,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    return report.sections.map((section) {
      return Padding(
        padding: const EdgeInsets.only(bottom: SbSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(SbSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.title.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SbSpacing.sm),
            ...section.content.map(
              (text) => Padding(
                padding: const EdgeInsets.only(
                  bottom: SbSpacing.sm,
                  left: SbSpacing.sm,
                ),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: SbSpacing.sm),
      child: Text(
        'Generated natively by Site Buddy',
        style: Theme.of(context).textTheme.bodyMedium!,
      ),
    );
  }
}









