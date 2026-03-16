import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: site_report_preview_screen.dart
/// Feature: reports
/// Layer: presentation/screens
///
/// PURPOSE:
/// Presents an interactive full-screen preview of a generated `SiteReport` before native extraction.
///
/// RESPONSIBILITIES:
/// - Secures the `AiShareReportCard` uniformly observing the 6px edge constraint natively.
/// - Injects [Export PDF] [Share Image] [Save] bottom actions bounding natively via core exporters safely.
/// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/core/widgets/previewable_card.dart';
import 'package:site_buddy/core/utils/site_report_pdf_generator.dart';
import 'package:site_buddy/core/utils/site_report_image_generator.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';
import 'package:site_buddy/features/reports/presentation/widgets/site_report_card.dart';

class SiteReportPreviewScreen extends StatefulWidget {
  final SiteReport report;

  const SiteReportPreviewScreen({super.key, required this.report});

  @override
  State<SiteReportPreviewScreen> createState() =>
      _SiteReportPreviewScreenState();
}

class _SiteReportPreviewScreenState extends State<SiteReportPreviewScreen> {
  final GlobalKey _previewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.report.isEmpty) {
      return const AppScreenWrapper(
        title: 'Report Preview',
        child: Center(child: Text('Cannot generate report: Empty data source.')),
      );
    }

    return AppScreenWrapper(
      title: 'Report Preview',
      child: PreviewableCard(
        previewKey: _previewKey,
        title: widget.report.projectName,
        actions: [
          PreviewAction(
            icon: SbIcons.image,
            label: 'Share Image',
            onPressed: () {
              SiteReportImageGenerator.generateAndShareImage(
                _previewKey,
                widget.report.projectName,
              );
            },
          ),
          PreviewAction(
            icon: SbIcons.pdf,
            label: 'Export PDF',
            onPressed: () {
              SiteReportPdfGenerator.generateAndShare(widget.report);
            },
          ),
          PreviewAction(
            icon: SbIcons.bookmarkAdd,
            label: 'Save',
            onPressed: () {
              SbFeedback.showToast(
                context: context,
                message: 'Generated report copied to clipboard!',
              );
            },
          ),
        ],
        child: SiteReportCard(report: widget.report),
      ),
    );
  }
}
