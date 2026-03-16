import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: CalculatorHubScreen
/// PURPOSE: Central navigation hub for all calculator and estimator tools.
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenWrapper(
      title: 'Engineering Toolbox',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbSection(
            title: 'Quantity Tools',
            child: _buildQuantityToolsSection(context),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          SbSection(
            title: 'Field Surveying',
            child: _buildFieldToolsSection(context),
          ),
          const SizedBox(height: AppSpacing.lg), // Added for bottom padding consistency
        ],
      ),
    );
  }

  Widget _buildQuantityToolsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1 — Concrete Material Estimator
        _buildToolCard(
          context,
          title: 'Concrete Material Estimator',
          description:
              'Calculate cement bags, sand, aggregate, and steel for any slab.',
          icon: SbIcons.calculator,
          onTap: () => context.push('/calculator/material'),
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

        // 2 — Brick Wall Material Estimator
        _buildToolCard(
          context,
          title: 'Brick Wall Estimator',
          description:
              'Estimate bricks, cement bags, mortar, and sand for brick walls.',
          icon: SbIcons.gridView,
          onTap: () => context.push('/calculator/brick-wall'),
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

        // 3 — Steel Weight Estimator
        _buildToolCard(
          context,
          title: 'Steel Weight Estimator',
          description: 'Estimate steel rebar length and weight requirements.',
          icon: SbIcons.rebar,
          onTap: () => context.push('/calculator/rebar'),
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

        // 4 — Excavation Volume
        _buildToolCard(
          context,
          title: 'Excavation Estimator',
          description: 'Calculate excavation volume and swell factors for foundations.',
          icon: SbIcons.terrain,
          onTap: () => context.push('/calculator/excavation'),
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16

        // 5 — Shuttering Area
        _buildToolCard(
          context,
          title: 'Shuttering Area',
          description: 'Estimate formwork area for beams and footings.',
          icon: SbIcons.layers,
          onTap: () => context.push('/calculator/shuttering'),
        ),
      ],
    );
  }

  Widget _buildFieldToolsSection(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md, // Replaced AppLayout.pMedium
      crossAxisSpacing: AppSpacing.md, // Replaced AppLayout.pMedium
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildGridToolCard(
          context,
          title: 'Level Calculator',
          icon: SbIcons.height,
          onTap: () => context.push('/level'),
        ),
        _buildGridToolCard(
          context,
          title: 'Gradient Tool',
          icon: SbIcons.trendingUp,
          onTap: () => context.push('/calculator/gradient'),
        ),
        _buildGridToolCard(
          context,
          title: 'Unit Converter',
          icon: SbIcons.compareArrows,
          onTap: () => context.push('/converter'),
        ),
        _buildGridToolCard(
          context,
          title: 'Currency Converter',
          icon: SbIcons.currencyExchange,
          onTap: () => context.push('/currency'),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return FeatureCard(
      title: title,
      description: description,
      icon: icon,
      onTap: onTap,
      isHorizontal: true,
    );
  }

  Widget _buildGridToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return FeatureCard(title: title, icon: icon, onTap: onTap);
  }
}
