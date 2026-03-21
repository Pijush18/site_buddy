import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: CalculatorHubScreen
/// PURPOSE: Central navigation hub for engineering tools with premium tiered hierarchy.
/// REFINEMENT: Upgrade from 'uniform list' to 'intentional flow' using featured entries and tiered variants.
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SbPage.scaffold(
      title: ScreenTitles.engineeringToolbox,
      body: SbSectionList(
        sections: [
          // ── PREMIUM HERO BANNER ──
          const SbSection(
            child: SbModuleHero(
              icon: SbIcons.calculator,
              title: ScreenTitles.engineeringToolbox,
              subtitle:
                  'Precision estimating and surveying tools designed for real-world site conditions.',
              isElevated: true,
            ),
          ),

          // ── SECTION 1: CORE ESTIMATORS ──
          SbSection(
            title: AppStrings.quantityTools,
            subtitle: 'Specialized calculators for volume and weight.',
            child: Column(
              children: [
                // FEATURED ENTRY: Visual anchor for the whole screen
                FeatureCard(
                  title: AppStrings.concreteMaterialEstimatorTitle,
                  description: AppStrings.concreteEstimatorDesc,
                  icon: SbIcons.calculator,
                  onTap: () => context.push('/calculator/material'),
                  isHorizontal: true,
                  variant: FeatureCardVariant.primary,
                  isFeatured: true,
                ),
                SizedBox(height: SbSpacing.md),

                // SECONDARY LIST: Tight grouping for less common tools
                SbListGroup(
                  isSubtle: true,
                  children: [
                    _buildToolCard(
                      context,
                      title: AppStrings.brickWallEstimatorTitle,
                      description: AppStrings.brickWallEstimatorDesc,
                      icon: SbIcons.gridView,
                      onTap: () => context.push('/calculator/brick-wall'),
                      variant: FeatureCardVariant.secondary,
                    ),
                    _buildToolCard(
                      context,
                      title: AppStrings.steelWeightEstimatorTitle,
                      description: AppStrings.steelWeightEstimatorDesc,
                      icon: SbIcons.rebar,
                      onTap: () => context.push('/calculator/rebar'),
                      variant: FeatureCardVariant.secondary,
                    ),
                    _buildToolCard(
                      context,
                      title: AppStrings.excavationEstimatorTitle,
                      description: AppStrings.excavationEstimatorDesc,
                      icon: SbIcons.terrain,
                      onTap: () => context.push('/calculator/excavation'),
                      variant: FeatureCardVariant.subtle,
                    ),
                    _buildToolCard(
                      context,
                      title: AppStrings.shutteringAreaTitle,
                      description: AppStrings.shutteringAreaDesc,
                      icon: SbIcons.layers,
                      onTap: () => context.push('/calculator/shuttering'),
                      variant: FeatureCardVariant.subtle,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── SECTION 2: FIELD SURVEYING (GRID) ──
          SbSection(
            title: AppStrings.fieldSurveying,
            subtitle: 'Levelling and measurement conversions.',
            child: SbCard(
              child: SbGrid(
                children: [
                  // CONTROLLED GRID BREAKING: One item is primary, others recede
                  _buildGridToolCard(
                    context,
                    title: EngineeringTerms.levelCalculator,
                    icon: SbIcons.height,
                    onTap: () => context.push('/level'),
                    variant: FeatureCardVariant.primary,
                  ),
                  _buildGridToolCard(
                    context,
                    title: EngineeringTerms.gradientTool,
                    icon: SbIcons.trendingUp,
                    onTap: () => context.push('/calculator/gradient'),
                    variant: FeatureCardVariant.secondary,
                  ),
                  _buildGridToolCard(
                    context,
                    title: AppStrings.unitConverter,
                    icon: SbIcons.compareArrows,
                    onTap: () => context.push('/converter'),
                    variant: FeatureCardVariant.subtle,
                  ),
                  _buildGridToolCard(
                    context,
                    title: AppStrings.currencyConverter,
                    icon: SbIcons.currencyExchange,
                    onTap: () => context.push('/currency'),
                    variant: FeatureCardVariant.subtle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// HELPER: List Tool Card with Hierarchy support
  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    FeatureCardVariant variant = FeatureCardVariant.secondary,
  }) {
    return FeatureCard(
      title: title,
      description: description,
      icon: icon,
      onTap: onTap,
      isHorizontal: true,
      variant: variant,
      isTile: true,
    );
  }

  /// HELPER: Grid Tool Card with Hierarchy support
  Widget _buildGridToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    FeatureCardVariant variant = FeatureCardVariant.secondary,
  }) {
    return FeatureCard(
      title: title, 
      icon: icon, 
      onTap: onTap, 
      isTile: true,
      variant: variant,
    );
  }
}
