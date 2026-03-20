/// FILE HEADER
/// ----------------------------------------------
/// File: site_report_pdf_generator.dart
/// Feature: core/utils
/// Layer: utilities
///
/// PURPOSE:
/// Responsible for rendering a dynamic `SiteReport` instance into a MultiPage PDF Document.
///
/// RESPONSIBILITIES:
/// - Transforms the raw `SiteReport` payload into an engineering form.
/// - Controls pagination, margins, footers, and complex structural splits.
/// - Interfaces natively with device specific physical printing/sharing APIs securely.
/// ----------------------------------------------
library;


import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';

class SiteReportPdfGenerator {
  /// METHOD: generateAndShare
  /// Converts the domain `SiteReport` into an explicit PDF spooling intent natively.
  static Future<void> generateAndShare(SiteReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(SbSpacing.xxl),
        header: (context) => _buildHeader(report),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildBody(report),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SiteBuddy_Report_${report.projectName.replaceAll(' ', '_')}.pdf',
    );
  }

  /// METHOD: saveToDisk
  /// SAVES the PDF to the local documents directory and returns the File.
  static Future<File> saveToDisk(SiteReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(SbSpacing.xxl),
        header: (context) => _buildHeader(report),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildBody(report),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'Report_${report.id}.pdf';
    final file = File('${directory.path}/$fileName');
    
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    
    return file;
  }

  /// METHOD: _buildHeader
  /// Creates the recurring branding stamp attached natively across all pages.
  static pw.Widget _buildHeader(SiteReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SITE BUDDY REPORT',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              'Confidential',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.red600,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: SbSpacing.sm),
        pw.Container(
          padding: const pw.EdgeInsets.all(SbSpacing.sm),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildMetaRow('Company:', report.branding.companyName),
                  pw.SizedBox(height: SbSpacing.xs),
                  _buildMetaRow('Engineer:', report.branding.engineerName),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _buildMetaRow('Project:', report.projectName),
                  pw.SizedBox(height: SbSpacing.xs),
                  _buildMetaRow(
                    'Date:',
                    '${report.date.day}/${report.date.month}/${report.date.year}',
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: SbSpacing.xxl),
      ],
    );
  }

  static pw.Widget _buildMetaRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColors.grey700,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: SbSpacing.sm),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 11, color: PdfColors.black),
        ),
      ],
    );
  }

  /// METHOD: _buildBody
  /// Maps dynamically the structural blocks defined natively inside the `SiteReport` lists.
  static List<pw.Widget> _buildBody(SiteReport report) {
    final widgets = <pw.Widget>[];

    for (var section in report.sections) {
      widgets.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: SbSpacing.xxl),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.blueGrey800,
                      width: 1.5,
                    ),
                  ),
                ),
                padding: const pw.EdgeInsets.only(bottom: SbSpacing.xs),
                margin: const pw.EdgeInsets.only(bottom: SbSpacing.sm),
                child: pw.Text(
                  section.title.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey800,
                  ),
                ),
              ),
              ...section.content.map(
                (text) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: SbSpacing.sm),
                  child: pw.Text(
                    text,
                    style: const pw.TextStyle(
                      fontSize: 11,
                      lineSpacing: 1.5,
                      color: PdfColors.grey900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  /// METHOD: _buildFooter
  /// Renders page tracking context alongside universal authorship declarations globally.
  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: SbSpacing.xxl),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      padding: const pw.EdgeInsets.only(top: SbSpacing.sm),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Site Buddy',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }
}







