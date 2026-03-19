import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/report_data.dart' as models;
import 'package:site_buddy/core/services/pdf_service.dart';
import 'package:printing/printing.dart';

/// SCREEN: DesignReportScreen
/// PURPOSE: Professional, PDF-like engineering calculation report.
/// RULE: AppScreenWrapper → SbSectionList → SbSection.
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
    final models.ReportData? reportData =
        widget.data ??
        ModalRoute.of(context)?.settings.arguments as models.ReportData?;

    if (reportData == null) {
      return const _ReportErrorState();
    }

    return AppScreenWrapper(
      title: reportData.title,
      actions: [
        if (_isExporting)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            icon: const Icon(SbIcons.share),
            onPressed: () => _handleShare(reportData),
          ),
      ],
      // ── PREDEFINED LAYOUT SYSTEM ──
      // SbSectionList centralizes the 24px gap between sections.
      child: SbSectionList(
        sections: [
          // ── SECTION 1: DOCUMENT HEADER ──
          _ReportDocumentHeader(data: reportData),

          // ── SECTION 2-N: CALCULATION SECTIONS ──
          ...reportData.sections.map(
            (section) => _ReportSectionWidget(section: section),
          ),

          // ── SECTION: FOOTER ──
          const _ReportFooter(),

          // ── SECTION: EXPORT ACTIONS ──
          _ReportExportActions(
            isExporting: _isExporting,
            onShare: () => _handleShare(reportData),
          ),
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
    return AppScreenWrapper(
      title: 'Design Report',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                SbIcons.error,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Report data unavailable.',
                style: TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Please try recalculating the design.',
                style: TextStyle(fontSize: AppFontSizes.subtitle),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                  style: const TextStyle(
                    fontSize: AppFontSizes.title,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'ENGINEERING COMPUTATION SHEET',
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(SbIcons.architecture, color: colorScheme.onPrimary, size: 24),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
               Expanded(
                child: _HeaderField(label: 'PROJECT', value: data.projectName),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
          style: TextStyle(
            fontSize: AppFontSizes.tab,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: const TextStyle(fontSize: AppFontSizes.subtitle),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: isResult ? colorScheme.primary : colorScheme.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              section.heading.toUpperCase(),
              style: const TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SbCard(
          padding: const EdgeInsets.all(AppSpacing.md),
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
                  Divider(color: colorScheme.outlineVariant, height: 16),
              ],
            ],
          ),
        ),
      ],
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
        statusColor = colorScheme.primary; 
      } else if (isFail) {
        statusColor = colorScheme.error;
      } else {
        statusColor = colorScheme.secondary;
      }
    }

    return SbListItemTile(
      title: item.label,
      subtitle: item.formula,
      onTap: () {},
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.value,
            style: TextStyle(
              fontSize: AppFontSizes.subtitle,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (item.unit != null) ...[
            const SizedBox(width: AppSpacing.sm / 2),
            Text(
              item.unit!,
              style: TextStyle(
                fontSize: AppFontSizes.tab,
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
          const SizedBox(height: AppSpacing.sm),
          Text(
            'DESIGN VERIFIED BY SITE BUDDY PRO',
            style: TextStyle(
              fontSize: AppFontSizes.tab,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Structural Engineering Computation Suite v2.0',
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportExportActions extends StatelessWidget {
  final bool isExporting;
  final VoidCallback onShare;

  const _ReportExportActions({required this.isExporting, required this.onShare});

  @override
  Widget build(BuildContext context) {
    if (isExporting) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        SbButton.primary(
          label: 'Share as PDF',
          icon: SbIcons.share,
          onPressed: onShare,
        ),
        const SizedBox(height: AppSpacing.md),
        SbButton.primary(
          label: 'Download PDF',
          icon: SbIcons.download,
          onPressed: onShare,
        ),
        // Buffer at the bottom to ensure last button is not cut off by SafeArea
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
