import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:site_buddy/core/utils/ui_formatters.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_entry.dart';
import 'package:site_buddy/features/level_log/domain/entities/level_method.dart';

/// SERVICE: LevelLogReportService
/// PURPOSE: Generates a professional PDF report for leveling survey data.
/// DESIGN: Includes tables, arithmetic closure checks, and vector profile graphs.
class LevelLogReportService {
  static Future<void> generateAndShareReport({
    required List<LevelEntry> entries,
    required LevelMethod method,
    required List<double?> slopes,
    required Map<String, double> closure,
    String projectName = 'Unnamed Project',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(projectName),
            pw.SizedBox(height: 20),
            _buildInfoSection(entries.length),
            pw.SizedBox(height: 20),
            _buildLevelTable(entries, method),
            pw.SizedBox(height: 20),
            _buildClosureCheck(closure),
            pw.SizedBox(height: 20),
            _buildSlopeAnalysis(entries, slopes),
            pw.SizedBox(height: 30),
            _buildGraphSection(entries),
            pw.Spacer(),
            _buildFooter(),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Level_Log_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.Widget _buildHeader(String projectName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'SITEBUDDY LEVELLING REPORT',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              'Project: $projectName',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Date: ${DateTime.now().toString().split(' ')[0]}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
            pw.Text(
              'Reference: SB-LVL-${DateTime.now().year}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildInfoSection(int stationCount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Stations: $stationCount',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Unit of Measurement: Meters (m)',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLevelTable(
    List<LevelEntry> entries,
    LevelMethod method,
  ) {
    final headers = [
      'Chainage',
      'Station',
      'BS',
      'IS',
      'FS',
      if (method == LevelMethod.heightOfInstrument)
        'H.I.'
      else ...[
        'Rise',
        'Fall',
      ],
      'R.L.',
      'Remark',
    ];

    final data = entries.map((entry) {
      return [
        entry.chainage != null ? UiFormatters.chainage(entry.chainage!) : '-',
        entry.station,
        UiFormatters.decimal(entry.bs, fractionDigits: 3),
        UiFormatters.decimal(entry.isReading, fractionDigits: 3),
        UiFormatters.decimal(entry.fs, fractionDigits: 3),
        if (method == LevelMethod.heightOfInstrument)
          UiFormatters.decimal(entry.hi, fractionDigits: 3)
        else ...[
          UiFormatters.decimal(entry.rise, fractionDigits: 3),
          UiFormatters.decimal(entry.fall, fractionDigits: 3),
        ],
        UiFormatters.decimal(entry.rl, fractionDigits: 3),
        entry.remark ?? '',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 10,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellAlignment: pw.Alignment.center,
      cellStyle: const pw.TextStyle(fontSize: 9),
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
    );
  }

  static pw.Widget _buildClosureCheck(Map<String, double> closure) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Arithmetic Closure Check',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        pw.Divider(thickness: 0.5, color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _checkItem('Total BS', closure['sumBS'] ?? 0),
            _checkItem('Total FS', closure['sumFS'] ?? 0),
            _checkItem('Diff (BS-FS)', closure['bsFsDiff'] ?? 0),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _checkItem('Diff (RL)', closure['rlDiff'] ?? 0, highlight: true),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            color: (closure['error'] ?? 0).abs() < 0.001
                ? PdfColors.green100
                : PdfColors.red100,
          ),
          child: pw.Center(
            child: pw.Text(
              (closure['error'] ?? 0).abs() < 0.001
                  ? 'Check: OK'
                  : 'Check: ERROR (${UiFormatters.decimal(closure['error'], fractionDigits: 4)})',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: (closure['error'] ?? 0).abs() < 0.001
                    ? PdfColors.green900
                    : PdfColors.red900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSlopeAnalysis(
    List<LevelEntry> entries,
    List<double?> slopes,
  ) {
    if (slopes.every((s) => s == null)) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Slope Analysis',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        pw.SizedBox(height: 5),
        pw.TableHelper.fromTextArray(
          headers: ['Segment', 'Chainage Range', 'Slope %'],
          data: List.generate(entries.length - 1, (index) {
            final slope = slopes[index + 1];
            if (slope == null) return [];
            final from = entries[index].chainage != null
                ? UiFormatters.chainage(entries[index].chainage!)
                : '-';
            final to = entries[index + 1].chainage != null
                ? UiFormatters.chainage(entries[index + 1].chainage!)
                : '-';
            return [
              'Segment ${index + 1}',
              '$from - $to',
              '${UiFormatters.decimal(slope, fractionDigits: 2)} %',
            ];
          }).where((row) => row.isNotEmpty).toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 8,
          ),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignment: pw.Alignment.center,
        ),
      ],
    );
  }

  static pw.Widget _checkItem(
    String label,
    double value, {
    bool highlight = false,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.Text(
          UiFormatters.decimal(value, fractionDigits: 3),
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _buildGraphSection(List<LevelEntry> entries) {
    final validPoints = entries
        .asMap()
        .entries
        .where((e) => e.value.rl != null)
        .toList();
    if (validPoints.length < 2) return pw.SizedBox();

    // Custom vector graph since pw.Chart is quite complex and version-dependent
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Ground Profile Visualization',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 180,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
          ),
          child: pw.Stack(
            children: [
              // Grid lines and labels (Conceptual placeholder or simple Drawing)
              pw.Padding(
                padding: const pw.EdgeInsets.all(10),
                child: _CustomPdfProfilePainter(points: validPoints),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated by SiteBuddy v1.0',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
            pw.Text(
              'Page 1 of 1',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomPdfProfilePainter extends pw.StatelessWidget {
  final List<MapEntry<int, LevelEntry>> points;

  _CustomPdfProfilePainter({required this.points});

  @override
  pw.Widget build(pw.Context context) {
    return pw.CustomPaint(
      size: const PdfPoint(400, 150),
      painter: (PdfGraphics canvas, PdfPoint size) {
        final double minY = points.map((p) => p.value.rl!).reduce(math.min);
        final double maxY = points.map((p) => p.value.rl!).reduce(math.max);
        double rangeY = maxY - minY;
        if (rangeY < 1.0) rangeY = 1.0;

        final double minX = points.first.value.chainage ?? 0;
        final double maxX =
            points.last.value.chainage ?? (points.length * 20.0);
        final double rangeX = math.max(1.0, maxX - minX);

        double getX(double x) => (x - minX) / rangeX * size.x;
        double getY(double y) => (y - minY) / rangeY * size.y;

        // Draw profile
        canvas.setStrokeColor(PdfColors.blue800);
        canvas.setLineWidth(2);

        for (int i = 0; i < points.length; i++) {
          final p = points[i];
          final x = getX(p.value.chainage ?? (p.key * 20.0));
          final y = getY(p.value.rl!);

          if (i == 0) {
            canvas.moveTo(x, y);
          } else {
            canvas.lineTo(x, y);
          }
        }
        canvas.strokePath();

        // Draw points
        for (var p in points) {
          final x = getX(p.value.chainage ?? (p.key * 20.0));
          final y = getY(p.value.rl!);
          canvas.drawEllipse(x, y, 3, 3);
          canvas.setFillColor(PdfColors.blue900);
          canvas.fillPath();
        }
      },
    );
  }
}




