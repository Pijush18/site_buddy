import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: EstimationHubScreen
/// PURPOSE: Central navigation hub for engineering tools with premium tiered hierarchy.
/// REFINEMENT: Upgrade from 'uniform list' to 'intentional flow' using featured entries and tiered variants.
class EstimationHubScreen extends StatelessWidget {
  const EstimationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SbPage.scaffold(
      title: l10n.titleToolbox,
      body: SbSectionList(
        sections: [
          // ── PREMIUM HERO BANNER ──
          SbSection(
            padding: EdgeInsets.zero,
            child: SbModuleHero(
              icon: SbIcons.calculator,
              title: l10n.titleToolbox,
              subtitle: l10n.msgCalculatorHeroSubtitle,
            ),
          ),


          // ── SECTION 1: CORE ESTIMATORS ──
          SbSection(
            title: l10n.labelQuantityTools,
            subtitle: l10n.msgQuantityToolsSubtitle,
            child: SbGrid(
              children: [
                SBGridActionCard(
                  label: l10n.titleConcreteEstimator,
                  icon: SbIcons.calculator,
                  onTap: () => context.push('/calculator/material'),
                  isHighlighted: true,
                ),
                SBGridActionCard(
                  label: l10n.titleBrickWallEstimator,
                  icon: SbIcons.gridView,
                  onTap: () => context.push('/calculator/brick-wall'),
                ),
                SBGridActionCard(
                  label: l10n.titleExcavationEstimator,
                  icon: SbIcons.terrain,
                  onTap: () => context.push('/calculator/excavation'),
                ),
                SBGridActionCard(
                  label: l10n.titleSandEstimator,
                  icon: SbIcons.terrain,
                  onTap: () => context.push('/calculator/sand'),
                ),
                SBGridActionCard(
                  label: l10n.titlePlasterEstimator,
                  icon: SbIcons.layers,
                  onTap: () => context.push('/calculator/plaster'),
                ),
              ],
            ),
          ),
 
          // ── SECTION 2: OTHER TOOLS ──
          SbSection(
            title: l10n.labelOtherTools,
            subtitle: l10n.msgOtherToolsSubtitle,
            child: SbGrid(
              children: [
                // Steel Weight
                SBGridActionCard(
                  label: l10n.titleRebarEstimator,
                  icon: SbIcons.rebar,
                  onTap: () => context.push('/calculator/rebar'),
                ),
 
                // Shuttering Area
                SBGridActionCard(
                  label: l10n.titleShutteringEstimator,
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

