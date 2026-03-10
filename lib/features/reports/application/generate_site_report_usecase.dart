/// FILE HEADER
/// ----------------------------------------------
/// File: generate_site_report_usecase.dart
/// Feature: reports
/// Layer: application/usecases
///
/// PURPOSE:
/// Single-responsibility logic aggregating isolated project data into a uniform Report.
///
/// RESPONSIBILITIES:
/// - Reads AI chat history inputs matching a specific project stream.
/// - Structurally segregates knowledge domains and calculations into sequential sections.
/// - Injects global branding mapping natively before PDF transmission context.
/// ----------------------------------------------
library;


import 'package:site_buddy/core/branding/branding_model.dart';
import 'package:site_buddy/shared/domain/models/ai_chat.dart';
import 'package:site_buddy/shared/domain/models/report_section.dart';
import 'package:site_buddy/shared/domain/models/site_report.dart';

import 'package:site_buddy/core/enums/unit_system.dart';

class GenerateSiteReportUseCase {
  const GenerateSiteReportUseCase();

  /// METHOD: execute
  /// Builds a `SiteReport` dynamically mapped from existing domain models bypassing direct UI generation logic.
  SiteReport execute({
    required String projectName,
    required BrandingModel branding,
    required List<AiChat> projectChats,
    UnitSystem unitSystem = UnitSystem.metric,
  }) {
    final List<ReportSection> sections = [];
    final volumeUnit = unitSystem == UnitSystem.metric ? 'm³' : 'yd³';

    if (projectChats.isEmpty) {
      sections.add(
        const ReportSection(
          type: ReportSectionType.summary,
          title: 'Project Setup Null',
          content: [
            'No active AI processing history exists directly linked to this specific scope yet.',
          ],
        ),
      );
    } else {
      // 1. Generate core Summary Overview mapping questions natively
      final questions = projectChats.map((c) => '• ${c.query}').toList();
      sections.add(
        ReportSection(
          type: ReportSectionType.summary,
          title: 'Project Intelligence Summary',
          content: [
            'This report documents ${projectChats.length} interactions logged dynamically through Site Buddy mapping the following queries:',
            ...questions,
          ],
        ),
      );

      // 2. Map structural AI histories
      List<String> combinedHistory = [];
      for (var chat in projectChats) {
        final calc = chat.response.calculation;
        final answerBody =
            chat.response.knowledge?.definition ??
            (calc != null
                ? 'Concrete Volume: ${calc.volume.toStringAsFixed(2)} $volumeUnit | Cement Bags: ${calc.cementBags}'
                : null) ??
            chat.response.conversion?.mainValue.toString() ??
            'Processing result unresolved.';

        combinedHistory.add('Q: ${chat.query}\n\nA:\n$answerBody');
      }

      sections.add(
        ReportSection(
          type: ReportSectionType.history,
          title: 'Chronological AI Log',
          content: combinedHistory,
        ),
      );
    }

    return SiteReport(
      projectName: projectName,
      branding: branding,
      date: DateTime.now(),
      sections: sections,
    );
  }
}
