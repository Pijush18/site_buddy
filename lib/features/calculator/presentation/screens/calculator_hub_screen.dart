import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: CalculatorHubScreen
/// PURPOSE: Central navigation hub for all calculator and estimator tools.
///
/// MATERIAL ESTIMATION TOOLS (as of this update):
///   1. Concrete Material Estimator
///   2. Brick Wall Material Estimator
///   3. Plaster Material Estimator
///   4. Rebar Length Estimator
///
/// NOTE: Cement Bag Calculator and Sand Quantity Estimator have been removed
/// from the menu (their screen files are preserved on disk).
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SbPage.detail(
      title: 'Engineering Toolbox',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbSection(
            title: 'Material Estimation',
            child: _buildMaterialEstimationSection(context),
          ),
          const SizedBox(height: AppLayout.pLarge),
          SbSection(
            title: 'Field Tools',
            child: _buildFieldToolsSection(context),
          ),
          const SizedBox(height: AppLayout.pLarge),
        ],
      ),
    );
  }

  Widget _buildMaterialEstimationSection(BuildContext context) {
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
        const SizedBox(height: AppLayout.pMedium),

        // 2 — Brick Wall Material Estimator (new)
        _buildToolCard(
          context,
          title: 'Brick Wall Estimator',
          description:
              'Estimate bricks, cement bags, mortar, and sand for brick walls.',
          icon: SbIcons.gridView,
          onTap: () => context.push('/calculator/brick-wall'),
        ),
        const SizedBox(height: AppLayout.pMedium),

        // 3 — Plaster Material Estimator (new)
        _buildToolCard(
          context,
          title: 'Plaster Estimator',
          description:
              'Calculate cement bags and sand for internal and external plaster.',
          icon: SbIcons.layers,
          onTap: () => context.push('/calculator/plaster'),
        ),
        const SizedBox(height: AppLayout.pMedium),

        // 4 — Rebar Length Estimator (existing, kept)
        _buildToolCard(
          context,
          title: 'Rebar Length Estimator',
          description: 'Estimate steel rebar length and spacing requirements.',
          icon: SbIcons.rebar,
          onTap: () => context.push('/calculator/rebar'),
        ),
      ],
    );
  }

  Widget _buildFieldToolsSection(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppLayout.pMedium,
      crossAxisSpacing: AppLayout.pMedium,
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
          icon: SbIcons.trendingDown,
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
