import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/design/design_report.dart';

/// WIDGET: DesignReportView
/// PURPOSE: A reusable, premium component to render any standardized DesignReport.
/// 
/// FEATURES:
/// - Dynamic section rendering from Inputs/Results maps.
/// - Adaptive status badges.
/// - Compact, engineering-focused typography.
class DesignReportView extends StatelessWidget {
  final DesignReport report;

  const DesignReportView({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header Section
        _ReportHeader(report: report),
        const SizedBox(height: SbSpacing.md),

        // 2. Calculation Summary Card
        _ReportSummaryCard(summary: report.summary, isSafe: report.isSafe),
        const SizedBox(height: SbSpacing.md),

        // 3. Dynamic Data Sections
        _ReportSection(
          title: 'INPUT PARAMETERS',
          data: report.inputs,
        ),
        const SizedBox(height: SbSpacing.md),

        _ReportSection(
          title: 'TECHNICAL RESULTS',
          data: report.results,
          highlight: true,
        ),
      ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTitle(report.designType.name),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
          _StatusBadge(isSafe: report.isSafe),
        ],
      ),
    );
  }

  String _formatTitle(String type) {
    return '${type[0].toUpperCase()}${type.substring(1)} Report';
  }
}

/// PRIVATE WIDGET: _ReportSummaryCard
class _ReportSummaryCard extends StatelessWidget {
  final String summary;
  final bool isSafe;

  const _ReportSummaryCard({required this.summary, required this.isSafe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSafe ? Colors.green : Colors.red;

    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(SbSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSafe ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: SbSpacing.md),
          Expanded(
            child: Text(
              summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _ReportSection
class _ReportSection extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final bool highlight;

  const _ReportSection({
    required this.title,
    required this.data,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: SbSpacing.xs, bottom: SbSpacing.sm),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: data.entries.map((e) {
              final isLast = data.keys.last == e.key;
              return _ReportRow(
                label: _formatLabel(e.key),
                value: _formatValue(e.value),
                showDivider: !isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '')
        .join(' ');
  }

  String _formatValue(dynamic val) {
    if (val == null) return '-';
    if (val is double) return val.toStringAsFixed(2);
    if (val is bool) return val ? 'OK' : 'FAIL';
    return val.toString();
  }
}

/// PRIVATE WIDGET: _ReportRow
class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _ReportRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SbSpacing.md,
            vertical: SbSpacing.sm + 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: SbSpacing.sm),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: SbSpacing.md,
            color: theme.dividerColor.withOpacity(0.05),
          ),
      ],
    );
  }
}

/// PRIVATE WIDGET: _StatusBadge
class _StatusBadge extends StatelessWidget {
  final bool isSafe;
  const _StatusBadge({required this.isSafe});

  @override
  Widget build(BuildContext context) {
    final color = isSafe ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        isSafe ? 'SAFE' : 'UNSAFE',
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
