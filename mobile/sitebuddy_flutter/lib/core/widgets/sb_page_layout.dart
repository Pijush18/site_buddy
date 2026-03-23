import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_page.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';

/// WIDGET: SbPageLayout
/// PURPOSE: Standardized page layout wrapper for SiteBuddy screens.
/// 
/// FEATURES:
/// - Uses [SbPage.detail] for consistent scroll behavior.
/// - SINGLE AUTHORITY: Manages exact vertical spacing between all sections.
/// - RHYTHM: Enforces exactly SbSpacing.xxl (24px) between sections.
class SbPageLayout extends StatelessWidget {
  /// The title displayed in the AppBar.
  final String title;
  
  /// Optional list of widgets to display in the AppBar's action slot.
  final List<Widget>? actions;
  
  /// The collection of sections that make up the page content.
  final List<Widget> sections;

  const SbPageLayout({
    super.key,
    required this.title,
    this.actions,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SbPage.detail(
      title: title,
      appBarActions: actions,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            sections[i],
            // ── SINGLE SPACING AUTHORITY ──
            // Exactly 24px (lg) between all children sections.
            if (i < sections.length - 1) 
              const SizedBox(height: SbSpacing.xxl),
          ],
        ],
      ),
    );
  }
}




