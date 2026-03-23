import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/core/widgets/sb_section_header.dart';
import 'package:site_buddy/core/widgets/sb_card.dart';
import 'package:site_buddy/core/widgets/sb_list_item_tile.dart';
import 'package:site_buddy/core/widgets/sb_grid_action_card.dart';
import 'package:site_buddy/core/widgets/sb_text.dart';

/// SCREEN: HomeScreen
/// PURPOSE: Main dashboard rebuilt using SiteBuddy UI System (Phase 1)
/// REFINED: Compact layout, tight spacing, strong visual hierarchy
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ═══════════════════════════════════════════════════════════════════════
  // NAVIGATION HANDLERS
  // ═══════════════════════════════════════════════════════════════════════

  void _navigateToCalculator() => context.push(AppRoutes.calculator);
  void _navigateToDesign() => context.push(AppRoutes.design);
  void _navigateToLevelCalculator() => context.push(AppRoutes.levelLog);
  void _navigateToEngineeringTools() => context.push(AppRoutes.gradientCalc);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // ═══════════════════════════════════════════════════════════════════════
    // DATA (Would come from providers in real app)
    // ═══════════════════════════════════════════════════════════════════════

    final List<_ActivityItem> recentActivities = [
      _ActivityItem(
        title: 'Slab Design - Project A',
        subtitle: '2 hours ago',
        icon: SbIcons.layers,
        onTap: () => context.push(AppRoutes.slabInput),
      ),
      _ActivityItem(
        title: 'Beam Calculation - Site B',
        subtitle: 'Yesterday',
        icon: SbIcons.architectureOutlined,
        onTap: () => context.push(AppRoutes.beamInput),
      ),
    ];

    final List<_ActivityItem> historyItems = [
      _ActivityItem(
        title: 'Level Calculator used',
        subtitle: '3 days ago',
        icon: SbIcons.ruler,
        iconColor: colorScheme.outline,
        onTap: () => context.push(AppRoutes.levelLog),
      ),
      _ActivityItem(
        title: 'Gradient calculated',
        subtitle: '4 days ago',
        icon: SbIcons.trendingUp,
        iconColor: colorScheme.outline,
        onTap: () => context.push(AppRoutes.gradientCalc),
      ),
      _ActivityItem(
        title: 'Unit conversion performed',
        subtitle: 'Last week',
        icon: SbIcons.sync,
        iconColor: colorScheme.outline,
        onTap: () => context.push(AppRoutes.unitConverter),
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: SBText.heading('SiteBuddy'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(SbIcons.settings, color: colorScheme.onSurface),
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md, // Tighter than lg
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SECTION 1: QUICK ACTIONS - Compact grid
              _buildQuickActions(),
              const SizedBox(height: AppSpacing.lg), // Not xl

              // SECTION 2: RECENT ACTIVITY
              _buildRecentActivity(recentActivities),
              const SizedBox(height: AppSpacing.lg), // Not xl

              // SECTION 3: HISTORY
              _buildHistory(historyItems, colorScheme),
              const SizedBox(height: AppSpacing.xl), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SECTION 1: QUICK ACTIONS (Compact Grid)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SbSectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.sm), // Compact - not md
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm, // Tight
          crossAxisSpacing: AppSpacing.sm, // Tight
          childAspectRatio: 1.2,
          children: [
            // Calculator
            SBGridActionCard(
              icon: SbIcons.calculator,
              label: 'Calculator',
              subtitle: 'Material & Costs',
              onTap: _navigateToCalculator,
              isPrimary: true,
            ),
            // Design
            SBGridActionCard(
              icon: SbIcons.architecture,
              label: 'Design',
              subtitle: 'Structural Tools',
              onTap: _navigateToDesign,
            ),
            // Level Calculator - Correct route to Field Leveling
            SBGridActionCard(
              icon: SbIcons.ruler,
              label: 'Level Calculator',
              subtitle: 'Field Tools',
              onTap: _navigateToLevelCalculator,
            ),
            // Engineering Tools
            SBGridActionCard(
              icon: SbIcons.engineering,
              label: 'Engineering',
              subtitle: 'Calculations',
              onTap: _navigateToEngineeringTools,
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SECTION 2: RECENT ACTIVITY (Compact List)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildRecentActivity(List<_ActivityItem> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SbSectionHeader(title: 'Recent Activity'),
        const SizedBox(height: AppSpacing.sm), // Compact
        if (activities.isEmpty)
          _buildEmptyState('No recent activity')
        else
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (int i = 0; i < activities.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  SbListItemTile(
                    icon: activities[i].icon,
                    title: activities[i].title,
                    subtitle: activities[i].subtitle,
                    onTap: activities[i].onTap,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SECTION 3: HISTORY (Compact List)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHistory(List<_ActivityItem> items, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SbSectionHeader(
          title: 'History',
          onTap: () {},
          trailing: Icon(
            SbIcons.chevronRight,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm), // Compact
        if (items.isEmpty)
          _buildEmptyState('No history yet')
        else
          SbCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  SbListItemTile(
                    icon: items[i].icon,
                    iconColor: items[i].iconColor,
                    title: items[i].title,
                    subtitle: items[i].subtitle,
                    onTap: items[i].onTap,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // EMPTY STATE HELPER (Compact)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState(String message) {
    return SbCard(
      padding: const EdgeInsets.all(AppSpacing.lg), // Tighter than xl
      child: Center(
        child: SBText(
          message,
          variant: SBTextVariant.bodySmall,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// DATA MODEL: Activity Item
// ═══════════════════════════════════════════════════════════════════════
class _ActivityItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });
}
