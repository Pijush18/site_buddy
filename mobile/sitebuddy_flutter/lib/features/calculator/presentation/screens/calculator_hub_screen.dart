import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: CalculatorHubScreen
/// PURPOSE: Central navigation hub for all calculator and estimator tools.
/// RULE: AppScreenWrapper → SbSectionList → SbSection.
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenWrapper(
      title: ScreenTitles.engineeringToolbox,
      child: SbSectionList(
        sections: [
          // ── SECTION 1: QUANTITY TOOLS ──
          SbSection(
            title: AppStrings.quantityTools,
            child: SbListGroup(
              children: [
                _buildToolCard(
                  context,
                  title: AppStrings.concreteMaterialEstimatorTitle,
                  description: AppStrings.concreteEstimatorDesc,
                  icon: SbIcons.calculator,
                  onTap: () => context.push('/calculator/material'),
                ),
                _buildToolCard(
                  context,
                  title: AppStrings.brickWallEstimatorTitle,
                  description: AppStrings.brickWallEstimatorDesc,
                  icon: SbIcons.gridView,
                  onTap: () => context.push('/calculator/brick-wall'),
                ),
                _buildToolCard(
                  context,
                  title: AppStrings.steelWeightEstimatorTitle,
                  description: AppStrings.steelWeightEstimatorDesc,
                  icon: SbIcons.rebar,
                  onTap: () => context.push('/calculator/rebar'),
                ),
                _buildToolCard(
                  context,
                  title: AppStrings.excavationEstimatorTitle,
                  description: AppStrings.excavationEstimatorDesc,
                  icon: SbIcons.terrain,
                  onTap: () => context.push('/calculator/excavation'),
                ),
                _buildToolCard(
                  context,
                  title: AppStrings.shutteringAreaTitle,
                  description: AppStrings.shutteringAreaDesc,
                  icon: SbIcons.layers,
                  onTap: () => context.push('/calculator/shuttering'),
                ),
              ],
            ),
          ),

          // ── SECTION 2: FIELD SURVEYING ──
          SbSection(
            title: AppStrings.fieldSurveying,
            child: SbGrid(
              children: [
                _buildGridToolCard(
                  context,
                  title: EngineeringTerms.levelCalculator,
                  icon: SbIcons.height,
                  onTap: () => context.push('/level'),
                ),
                _buildGridToolCard(
                  context,
                  title: EngineeringTerms.gradientTool,
                  icon: SbIcons.trendingUp,
                  onTap: () => context.push('/calculator/gradient'),
                ),
                _buildGridToolCard(
                  context,
                  title: AppStrings.unitConverter,
                  icon: SbIcons.compareArrows,
                  onTap: () => context.push('/converter'),
                ),
                _buildGridToolCard(
                  context,
                  title: AppStrings.currencyConverter,
                  icon: SbIcons.currencyExchange,
                  onTap: () => context.push('/currency'),
                ),
              ],
            ),
          ),
        ],
      ),
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



