import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:site_buddy/shared/domain/models/report_data.dart';
import 'package:intl/intl.dart';

/// SERVICE: PdfService
/// PURPOSE: Handles PDF generation from calculation data. (Pure Logic)
class PdfService {
  PdfService._();

  /// Generates a professional PDF document from ReportData.
  static Future<Uint8List> generateDesignReportPdf(ReportData data) async {
    final pdf = pw.Document();

    // Note: We use default fonts or passed-in fonts to remain pure.
    // In a real scenario, font bytes should be passed in or loaded via a pure Dart way.
    // For this refactor, we focus on removing Flutter framework imports.

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(data),
          pw.SizedBox(height: 24),
          ...data.sections.map((section) => _buildSection(section)),
          pw.SizedBox(height: 40),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(ReportData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  data.title.toUpperCase(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                pw.Text(
                  'ENGINEERING COMPUTATION SHEET',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blueGrey700,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                child: _buildHeaderField('PROJECT', data.projectName),
              ),
              pw.Container(
                width: 1,
                height: 30,
                color: PdfColors.grey400,
                margin: const pw.EdgeInsets.symmetric(horizontal: 16.0),
              ),
              pw.Expanded(
                child: _buildHeaderField(
                  'DATE',
                  DateFormat('dd MMM yyyy').format(data.date),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildHeaderField(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildSection(CalculationSection section) {
    final isResult = section.type == ReportSectionType.result;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            section.heading.toUpperCase(),
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              color: isResult ? PdfColors.blue50 : null,
            ),
            child: pw.Column(
              children: section.items
                  .map((item) => _buildItemRow(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemRow(CalculationItem item) {
    final isSafe = item.value.toLowerCase() == 'safe';
    final isFail = item.value.toLowerCase() == 'fail';

    final valueColor = isSafe
        ? PdfColors.green800
        : (isFail ? PdfColors.red800 : PdfColors.black);

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                item.label,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey900,
                ),
              ),
              pw.Row(
                children: [
                  pw.Text(
                    item.value,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                      color: valueColor,
                    ),
                  ),
                  if (item.unit != null)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 4),
                      child: pw.Text(
                        item.unit!,
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (item.formula != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                item.formula!,
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 8),
          pw.Text(
            'DESIGN VERIFIED BY SITE BUDDY PRO',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
              color: PdfColors.grey700,
              letterSpacing: 2,
            ),
          ),
          pw.Text(
            'Structural Engineering Computation Suite v2.0',
            style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }
}



