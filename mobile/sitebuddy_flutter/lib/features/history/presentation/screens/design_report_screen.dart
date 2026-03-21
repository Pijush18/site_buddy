import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';

/// SCREEN: DesignReportScreen
/// PURPOSE: A premium, reusable UI for rendering standardized design reports.
/// 
/// FEATURES:
/// - Dynamic section rendering (Inputs/Results).
/// - Safety status badges.
/// - Compact, professional typography.
class DesignReportScreen extends StatelessWidget {
  final DesignReport report;

  const DesignReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SbPage.detail(
      title: 'Design Report',
      body: SbSectionList(
        sections: [
          // 1. Overview Header
          SbSection(
            child: _ReportHeader(report: report),
          ),

          // 2. Input Parameters
          SbSection(
            title: 'Design Inputs',
            child: _ReportDataGrid(data: report.inputs),
          ),

          // 3. Calculation Results
          SbSection(
            title: 'Technical Results',
            child: _ReportDataGrid(data: report.results),
          ),

          // 4. Summary & Actions
          SbSection(
            title: 'Engineering Summary',
            child: _ReportSummary(report: report),
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _ReportHeader
class _ReportHeader extends StatelessWidget {
  final DesignReport report;
  const _ReportHeader({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('MMM dd, yyyy • HH:mm').format(report.timestamp);

    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.typeLabel.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: SbSpacing.xs),
                  Text(
                    dateStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _SafetyBadge(isSafe: report.isSafe),
            ],
          ),
          const Divider(height: SbSpacing.lg * 2),
          Text(
            report.summary,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _ReportDataGrid
/// Renders a list of key-value pairs from a dynamic map.
class _ReportDataGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ReportDataGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SbEmptyState(message: 'No data recorded for this section.');
    }

    return SbCard(
      child: Column(
        children: data.entries.map((e) {
          final isLast = data.keys.last == e.key;
          return Column(
            children: [
              _ReportRow(
                label: _formatKey(e.key),
                value: _formatValue(e.value),
              ),
              if (!isLast) const Divider(height: 1, indent: SbSpacing.md),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatKey(String key) {
    // Convert snake_case or camelCase to Sentence Case
    return key
        .replaceAll('_', ' ')
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}')
        .trim();
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is double) return value.toStringAsFixed(2);
    if (value is bool) return value ? 'YES' : 'NO';
    return value.toString();
  }
}

/// PRIVATE WIDGET: _ReportRow
class _ReportRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SbSpacing.md,
        vertical: SbSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: SbSpacing.md),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _ReportSummary
class _ReportSummary extends StatelessWidget {
  final DesignReport report;
  const _ReportSummary({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InfoCard(
          message: 'This report is based on IS 456:2000 standards. Please verify manually before execution.',
          isWarning: !report.isSafe,
        ),
        const SizedBox(height: SbSpacing.lg),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  // TODO: Implement PDF Export
                  SbFeedback.showToast(context: context, message: 'PDF Export coming soon!');
                },
                label: 'Export PDF',
                icon: Icons.picture_as_pdf,
              ),
            ),
            const SizedBox(width: SbSpacing.md),
            Expanded(
              child: PrimaryCTA(
                onPressed: () {
                  // TODO: Implement Design Sharing
                  SbFeedback.showToast(context: context, message: 'Sharing feature coming soon!');
                },
                label: 'Share Report',
                icon: Icons.share,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// PRIVATE WIDGET: _SafetyBadge
class _SafetyBadge extends StatelessWidget {
  final bool isSafe;
  const _SafetyBadge({required this.isSafe});

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSafe ? Icons.check_circle : Icons.warning_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isSafe ? 'SAFE' : 'UNSAFE',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
