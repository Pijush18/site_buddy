import 'package:flutter/material.dart';
import 'package:site_buddy/core/registry/tool_registry.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/widgets/sb_tool_grid.dart';
import 'package:site_buddy/core/widgets/sb_text.dart';

/// SCREEN: DesignScreen
/// PURPOSE: Professional engineering dashboard rebuilt with data-driven tool registry
/// Uses ToolRegistry - UI reads from registry, not hardcoded lists
class DesignScreen extends StatelessWidget {
  const DesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Get categories from registry
    final categories = ToolRegistry.categories;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: SBText.heading('Design Tools'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display each category from registry
              for (int i = 0; i < categories.length; i++) ...[
                _buildCategorySection(categories[i]),
                if (i < categories.length - 1)
                  const SizedBox(height: AppSpacing.xl),
              ],
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a category section using SBSectionHeader + SBToolGrid from registry
  Widget _buildCategorySection(ToolCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SbSectionHeader(title: category.title),
        const SizedBox(height: AppSpacing.md),
        SBToolGrid(
          children: category.tools.map((tool) {
            return SBToolCard(
              icon: tool.icon,
              title: tool.title,
              subtitle: tool.subtitle,
              route: tool.route,
              isPrimary: tool.isPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }
}
