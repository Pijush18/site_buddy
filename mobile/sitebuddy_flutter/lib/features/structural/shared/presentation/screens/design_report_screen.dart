import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/shared/domain/models/report_data.dart';

/// SCREEN: DesignReportScreen
/// PURPOSE: Screen wrapper for DesignReportView to display structural analysis results.
class DesignReportScreen extends StatelessWidget {
  final ReportData? data;

  const DesignReportScreen({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return const SbPage.scaffold(
      title: 'Design Report',
      body: Center(
        child: Text('Report View Placeholder'),
      ),
    );
  }
}
