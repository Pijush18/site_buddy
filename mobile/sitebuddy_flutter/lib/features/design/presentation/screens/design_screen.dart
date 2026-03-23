import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/registry/tool_registry.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_grid.dart';
import 'package:site_buddy/core/widgets/sb_grid_action_card.dart';
import 'package:site_buddy/core/widgets/sb_section.dart';
import 'package:site_buddy/core/widgets/sb_text.dart';

/// SCREEN: DesignScreen
/// PURPOSE: Professional engineering dashboard rebuilt with data-driven tool registry
/// REFINED: Uses SbSection + SBGridActionCard for standardized components
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
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display each category from registry
              for (int i = 0; i < categories.length; i++) ...[
                _buildCategorySection(context, categories[i]),
                if (i < categories.length - 1)
                  const SizedBox(height: AppSpacing.lg),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a category section using SbSection + SbGrid + SBGridActionCard
  Widget _buildCategorySection(BuildContext context, ToolCategory category) {
    return SbSection(
      title: category.title,
      child: SbGrid(
        children: category.tools.map((tool) {
          return SBGridActionCard(
            icon: tool.icon,
            label: tool.title,
            subtitle: tool.subtitle,
            isPrimary: tool.isPrimary,
            onTap: () => context.push(tool.route),
          );
        }).toList(),
      ),
    );
  }
}
