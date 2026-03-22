import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:site_buddy/features/structural/shared/domain/models/design_report.dart';
import 'package:site_buddy/core/logging/app_logger.dart';

/// SERVICE: PdfReportService
/// PURPOSE: Standardized PDF generation for all engineer reports.
/// ARCHITECTURE: Independent service layer with zero UI dependency.
class PdfReportService {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

  /// GENERATE & PREVIEW: Standard entry point for UI
  static Future<void> preview(DesignReport report) async {
    try {
      AppLogger.info('Generating PDF for Preview: ${report.id}', tag: 'PdfService');
      final pdf = await _buildDocument(report);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: '${report.typeLabel}_Report_${report.id.substring(0, 8)}',
      );
    } catch (e, stack) {
      AppLogger.error('PDF Preview failed: ${report.id}', tag: 'PdfService', error: e, stackTrace: stack);
    }
  }

  /// GENERATE & SHARE: Standard entry point for sharing
  static Future<void> share(DesignReport report) async {
    try {
      AppLogger.info('Generating PDF for Sharing: ${report.id}', tag: 'PdfService');
      final pdf = await _buildDocument(report);
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: '${report.typeLabel}_Report.pdf',
      );
    } catch (e, stack) {
      AppLogger.error('PDF Sharing failed: ${report.id}', tag: 'PdfService', error: e, stackTrace: stack);
    }
  }

  /// BUILD: Core PDF Construction Logic
  static Future<pw.Document> _buildDocument(DesignReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(report),
            pw.SizedBox(height: 20),
            _buildMetadata(report),
            pw.SizedBox(height: 20),
            _buildSection(title: 'INPUTS', data: report.inputs),
            pw.SizedBox(height: 20),
            _buildSection(title: 'RESULTS', data: report.results),
            pw.SizedBox(height: 20),
            _buildSummary(report),
            pw.SizedBox(height: 40),
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf;
  }

  /// COMPONENT: Report Header
  static pw.Widget _buildHeader(DesignReport report) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey, width: 2)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SITEBUDDY ENGINEERING REPORT',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.blue700,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                report.typeLabel.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: pw.BoxDecoration(
              color: report.isSafe ? PdfColors.green : PdfColors.red,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text(
              report.isSafe ? 'SAFE' : 'UNSAFE',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// COMPONENT: Report Metadata
  static pw.Widget _buildMetadata(DesignReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildMetaRow('Date Generated:', _dateFormat.format(report.timestamp)),
        _buildMetaRow('Project ID:', report.projectId),
        _buildMetaRow('Report ID:', report.id),
      ],
    );
  }

  /// COMPONENT: Data Section (Inputs/Results)
  /// Now supports nested Grouping and Structured Fields {label, value, unit}.
  static pw.Widget _buildSection({
    required String title,
    required Map<String, dynamic> data,
  }) {
    if (data.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.Divider(thickness: 1, color: PdfColors.grey300),
        pw.SizedBox(height: 8),
        ...data.entries.map<pw.Widget>((group) {
          // If value is a Map but NOT a structured field, it's a Group
          if (group.value is Map<String, dynamic> &&
              !group.value.containsKey('label')) {
            return _buildGroup(group.key, group.value);
          }
          // Otherwise build a single row
          return _buildFieldRow(group.value);
        }),
      ],
    );
  }

  /// COMPONENT: Grouped Data Support
  static pw.Widget _buildGroup(String title, Map<String, dynamic> fields) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey),
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            children: fields.values.map((field) {
              return _buildFieldTableRow(field);
            }).toList(),
          ),
        ],
      ),
    );
  }

  static pw.TableRow _buildFieldTableRow(dynamic field) {
    final label = field is Map ? (field['label'] ?? '') : '';
    final value = field is Map ? (field['value'] ?? '') : field.toString();
    final unit = field is Map ? (field['unit'] ?? '') : '';

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Text(
            '$value $unit'.trim(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFieldRow(dynamic field) {
    return pw.Table(children: [_buildFieldTableRow(field)]);
  }

  /// COMPONENT: Summary Section
  static pw.Widget _buildSummary(DesignReport report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SUMMARY',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            report.summary,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// COMPONENT: Footer
  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey500),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'PRODUCED BY SITEBUDDY PRO',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
            pw.Text(
              'Page 1 of 1',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
          ],
        ),
      ],
    );
  }

  /// HELPERS: Formatters
  static pw.Widget _buildMetaRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 8),
          pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

