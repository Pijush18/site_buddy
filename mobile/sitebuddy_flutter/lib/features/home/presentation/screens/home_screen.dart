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

    // Recent Activity data
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

    // History data
    final List<_ActivityItem> historyItems = [
      _ActivityItem(
        title: 'Level Calculator used',
        subtitle: '3 days ago',
        icon: SbIcons.calculator,
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
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SECTION 1: QUICK ACTIONS
              _buildQuickActions(),
              const SizedBox(height: AppSpacing.xl),

              // SECTION 2: RECENT ACTIVITY
              _buildRecentActivity(recentActivities),
              const SizedBox(height: AppSpacing.xl),

              // SECTION 3: HISTORY
              _buildHistory(historyItems, colorScheme),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SECTION 1: QUICK ACTIONS (Grid)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SbSectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1,
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
            // Level Calculator (IMPORTANT: navigates to Field Leveling)
            SBGridActionCard(
              icon: SbIcons.height,
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
  // SECTION 2: RECENT ACTIVITY
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildRecentActivity(List<_ActivityItem> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SbSectionHeader(title: 'Recent Activity'),
        const SizedBox(height: AppSpacing.md),
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
  // SECTION 3: HISTORY
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHistory(List<_ActivityItem> items, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SbSectionHeader(
          title: 'History',
          onTap: () {}, // View All - placeholder
          trailing: Icon(
            SbIcons.chevronRight,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
  // EMPTY STATE HELPER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState(String message) {
    return SbCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
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
