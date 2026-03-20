
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
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
      return SbPage.detail(
        title: ScreenTitles.reportPreview,
        body: Center(
          child: Text(
            AppStrings.noEntriesFound,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ),
      );
    }

    return SbPage.detail(
      title: ScreenTitles.reportPreview,
      body: PreviewableCard(
        previewKey: _previewKey,
        title: widget.report.projectName,
        actions: [
          PreviewAction(
            icon: SbIcons.image,
            label: AppStrings.shareImage,
            onPressed: () {
              SiteReportImageGenerator.generateAndShareImage(
                _previewKey,
                widget.report.projectName,
              );
            },
          ),
          PreviewAction(
            icon: SbIcons.pdf,
            label: AppStrings.exportPdf,
            onPressed: () {
              SiteReportPdfGenerator.generateAndShare(widget.report);
            },
          ),
          PreviewAction(
            icon: SbIcons.bookmarkAdd,
            label: AppStrings.save,
            onPressed: () {
              SbFeedback.showToast(
                context: context,
                message: AppStrings.copiedToClipboard,
              );
            },
          ),
        ],
        child: SiteReportCard(report: widget.report),
      ),
    );
  }
}






