import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/report_data.dart' as models;
import 'package:site_buddy/core/services/pdf_service.dart';
import 'package:printing/printing.dart';

/// SCREEN: DesignReportScreen
/// PURPOSE: Professional, PDF-like engineering calculation report.
class DesignReportScreen extends StatefulWidget {
  final models.ReportData? data;

  const DesignReportScreen({super.key, this.data});

  @override
  State<DesignReportScreen> createState() => _DesignReportScreenState();
}

class _DesignReportScreenState extends State<DesignReportScreen> {
  bool _isExporting = false;

  void _handleShare(models.ReportData reportData) async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes = await PdfService.generateDesignReportPdf(reportData);
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${reportData.title.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (mounted) {
        SbFeedback.showToast(
          context: context,
          message: 'Error sharing PDF: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final models.ReportData? reportData =
        widget.data ??
        ModalRoute.of(context)?.settings.arguments as models.ReportData?;

    if (reportData == null) {
      return const _ReportErrorState();
    }

    return SbPage.detail(
      title: reportData.title,
      appBarActions: [
        if (_isExporting)
          Padding(
            padding: AppLayout.paddingMedium,
            child: SizedBox(
              width: AppLayout.md,
              height: AppLayout.md,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          )
        else
          SbButton.icon(
            icon: SbIcons.share,
            onPressed: () => _handleShare(reportData),
          ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReportDocumentHeader(data: reportData),
          AppLayout.vGap24,
          ...reportData.sections.map(
            (section) => _ReportSectionWidget(section: section),
          ),
          AppLayout.vGap24,
          const _ReportFooter(),
          AppLayout.vGap32,
          if (_isExporting)
            const Center(child: CircularProgressIndicator())
          else ...[
            SbButton.primary(
              label: 'Share as PDF',
              icon: SbIcons.share,
              onPressed: () => _handleShare(reportData),
            ),
            AppLayout.vGap16,
            SbButton.primary(
              label: 'Download PDF',
              icon: SbIcons.download,
              onPressed: () => _handleShare(
                reportData,
              ), // In this context, both trigger the same share/save logic
            ),
          ],
          const SizedBox(height: AppLayout.xl + AppLayout.sm),
        ],
      ),
    );
  }
}

class _ReportErrorState extends StatelessWidget {
  const _ReportErrorState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SbPage.detail(
      title: 'Design Report',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.lg,
            vertical: AppLayout.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                SbIcons.error,
                size: 64,
                color: theme.colorScheme.error,
              ),
              AppLayout.vGap24,
              Text(
                'Report data unavailable.',
                style: SbTextStyles.title(context),
                textAlign: TextAlign.center,
              ),
              AppLayout.vGap8,
              Text(
                'Please try recalculating the design.',
                style: SbTextStyles.body(context),
                textAlign: TextAlign.center,
              ),
              AppLayout.vGap24,
              SbButton.primary(
                label: 'Go Back',
                width: 200,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportDocumentHeader extends StatelessWidget {
  final models.ReportData data;
  const _ReportDocumentHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title.toUpperCase(),
                  style: SbTextStyles.title(context).copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'ENGINEERING COMPUTATION SHEET',
                  style: SbTextStyles.caption(context).copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            // Logo/Badge
            Container(
              padding: const EdgeInsets.all(AppLayout.xs),
              
              child: Icon(SbIcons.architecture, color: colorScheme.onPrimary, size: 24),
            ),
          ],
        ),
        AppLayout.vGap24,
        Container(
          padding: AppLayout.paddingMedium,

          child: Row(
            children: [
               Expanded(
                child: _HeaderField(label: 'PROJECT', value: data.projectName),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppLayout.pMedium),
                child: Container(
                  width: 1,
                  height: 32,
                  color: colorScheme.outlineVariant,
                ),
              ),
              Expanded(
                child: _HeaderField(
                  label: 'DATE',
                  value: DateFormat('dd MMM yyyy').format(data.date),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderField extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SbTextStyles.caption(context).copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppLayout.vGap8,
        Text(
          value,
          style: SbTextStyles.body(context),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ReportSectionWidget extends StatelessWidget {
  final models.CalculationSection section;
  const _ReportSectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isResult = section.type == models.ReportSectionType.result;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppLayout.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: AppLayout.spaceXS,
                height: AppLayout.spaceL,
              ),
              AppLayout.hGap16,
              Text(
                section.heading.toUpperCase(),
                style: SbTextStyles.body(context).copyWith(letterSpacing: 1.1),
              ),
            ],
          ),
          AppLayout.vGap16,
          SbCard(
            padding: const EdgeInsets.all(AppLayout.pMedium),
            color: isResult
                ? colorScheme.primaryContainer.withValues(alpha: 0.1)
                : null,
            child: Column(
              children: [
                for (int i = 0; i < section.items.length; i++) ...[
                  _CalculationItemRow(
                    item: section.items[i],
                    isCheck: section.type == models.ReportSectionType.check,
                  ),
                  if (i < section.items.length - 1)
                    Divider(color: colorScheme.outlineVariant, height: AppLayout.vGap16.height),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculationItemRow extends StatelessWidget {
  final models.CalculationItem item;
  final bool isCheck;

  const _CalculationItemRow({required this.item, required this.isCheck});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSafe = item.value.toLowerCase() == 'safe';
    final isFail = item.value.toLowerCase() == 'fail';

    Color? statusColor;
    if (isCheck) {
      if (isSafe) {
        statusColor = colorScheme.primary; // Using primary for "Safe" consistent with system
      } else if (isFail) {
        statusColor = colorScheme.error;
      } else {
        statusColor = colorScheme.secondary;
      }
    }

    return SbListItem(
      title: item.label,
      subtitle: item.formula,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.value,
            style: SbTextStyles.body(context).copyWith(color: statusColor),
          ),
          if (item.unit != null) ...[
            const SizedBox(width: AppLayout.xs),
            Text(
              item.unit!,
              style: SbTextStyles.caption(context).copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportFooter extends StatelessWidget {
  const _ReportFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Icon(
            SbIcons.verified,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          AppLayout.vGap8,
          Text(
            'DESIGN VERIFIED BY SITE BUDDY PRO',
            style: SbTextStyles.caption(context).copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Structural Engineering Computation Suite v2.0',
            style: SbTextStyles.caption(context).copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
