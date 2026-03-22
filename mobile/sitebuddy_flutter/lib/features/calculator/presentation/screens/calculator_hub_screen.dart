import 'package:site_buddy/core/design_system/sb_icons.dart';
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
            padding: EdgeInsets.zero,
            child: SbModuleHero(
              icon: SbIcons.calculator,
              title: ScreenTitles.engineeringToolbox,
              subtitle:
                  'Precision estimating and surveying tools designed for real-world site conditions.',
            ),
          ),


          // ── SECTION 1: CORE ESTIMATORS ──
          SbSection(
            title: AppStrings.quantityTools,
            subtitle: 'Specialized calculators for volume and weight.',
            child: SbGrid(
              children: [
                SBGridActionCard(
                  label: AppStrings.concreteMaterialEstimatorTitle,
                  icon: SbIcons.calculator,
                  onTap: () => context.push('/calculator/material'),
                  isHighlighted: true,
                ),
                SBGridActionCard(
                  label: AppStrings.brickWallEstimatorTitle,
                  icon: SbIcons.gridView,
                  onTap: () => context.push('/calculator/brick-wall'),
                ),
                SBGridActionCard(
                  label: AppStrings.excavationEstimatorTitle,
                  icon: SbIcons.terrain,
                  onTap: () => context.push('/calculator/excavation'),
                ),
                SBGridActionCard(
                  label: EngineeringTerms.sandQuantityEstimator,
                  icon: SbIcons.terrain,
                  onTap: () => context.push('/calculator/sand'),
                ),
                SBGridActionCard(
                  label: EngineeringTerms.plasterEstimator,
                  icon: SbIcons.layers,
                  onTap: () => context.push('/calculator/plaster'),
                ),
              ],
            ),
          ),
 
          // ── SECTION 2: OTHER TOOLS ──
          SbSection(
            title: 'Other Tools',
            subtitle: 'Quick material and geometry calculations.',
            child: SbGrid(
              children: [
                // Steel Weight
                SBGridActionCard(
                  label: AppStrings.steelWeightEstimatorTitle,
                  icon: SbIcons.rebar,
                  onTap: () => context.push('/calculator/rebar'),
                ),
 
                // Shuttering Area
                SBGridActionCard(
                  label: AppStrings.shutteringAreaTitle,
                  icon: SbIcons.layers,
                  onTap: () => context.push('/calculator/shuttering'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
