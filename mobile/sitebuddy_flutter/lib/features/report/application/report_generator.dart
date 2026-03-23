
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:site_buddy/features/report/domain/report_model.dart';
import 'package:site_buddy/features/report/domain/report_section.dart';

/// SERVICE: ReportGenerator
/// PURPOSE: Converts EngineeringReport models into PDF documents.
class ReportGenerator {
  
  Future<Uint8List> generatePdf(EngineeringReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(report),
        footer: (context) => _buildFooter(context, report),
        build: (context) => [
          _buildInfoTable(report),
          pw.SizedBox(height: 20),
          ...report.sections.map((section) => _buildSection(section, report.isPro)),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(EngineeringReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "SITEBUDDY REPORT",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              report.codeReference,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blueGrey),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildInfoTable(EngineeringReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(report.title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text("Project: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(report.projectTitle),
          ],
        ),
        pw.Row(
          children: [
            pw.Text("Engineer: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(report.engineerName),
          ],
        ),
        pw.Row(
          children: [
            pw.Text("Date: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(report.date.toString().substring(0, 16)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSection(ReportSection section, bool isPro) {
    if (section.isProOnly && !isPro) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 10),
        padding: const pw.EdgeInsets.all(10),
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        child: pw.Text("[PRO FEATURE] Detailed calculation steps locked."),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(
          section.title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.Divider(thickness: 0.5),
        ...section.content.entries.map((e) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(e.key, style: const pw.TextStyle(fontSize: 10)),
              pw.Text(e.value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        )),
        if (isPro && section.steps != null) ...[
          pw.SizedBox(height: 5),
          pw.Text("Calculation Steps:", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
          ...section.steps!.map((step) => pw.Text("- $step", style: const pw.TextStyle(fontSize: 9))),
        ],
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context, EngineeringReport report) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(report.footerNote, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            pw.Text("Page ${context.pageNumber} of ${context.pagesCount}", style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }
}
