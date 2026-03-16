import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(subscriptionStatusProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Subscription',
      child: statusAsync.when(
        data: (status) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentStatus(context, status),
            const SizedBox(height: AppSpacing.lg * 1.5), // Replaced AppLayout.vGap32
            if (!status.isPremium) ...[
              const Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontSize: AppFontSizes.title,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
              Text(
                'Unlock the full power of SiteBuddy Engineering AI',
                style: TextStyle(
                  fontSize: AppFontSizes.subtitle,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
              _buildPremiumCard(context, ref),
            ] else ...[
              SbCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      const Icon(SbIcons.checkFilled, color: Colors.green, size: 48),
                      const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
                      const Text(
                        'You are a Premium User',
                        style: TextStyle(
                          fontSize: AppFontSizes.subtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                      Text(
                        'All advanced engineering tools and AI assistant are unlocked.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSizes.subtitle,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg * 1.5), // Replaced AppLayout.vGap32
            _buildFeatureComparison(context),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context, dynamic status) {
    final colorScheme = Theme.of(context).colorScheme;
    return SbCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          status.isPremium ? SbIcons.premium : SbIcons.account,
          color: status.isPremium ? Colors.amber : colorScheme.outline,
        ),
        title: const Text(
          'Current Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          status.plan.toUpperCase(),
          style: TextStyle(fontSize: AppFontSizes.tab, color: colorScheme.onSurfaceVariant),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (status.status == 'active' ? Colors.green : Colors.orange).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status.status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: status.status == 'active' ? Colors.green : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  'PREMIUM LOGIC',
                  style: TextStyle(
                    fontSize: AppFontSizes.tab,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
                const Text(
                  '\$9.99 / Month',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildBenefitItem(context, 'Full AI Engineering Assistant'),
                _buildBenefitItem(context, 'PDF Report Cloud Sync'),
                _buildBenefitItem(context, 'Advanced Steel Reinforcement Designs'),
                _buildBenefitItem(context, 'Multi-Project Management'),
                const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
                SbButton.primary(
                  label: 'Subscribe Now',
                  onPressed: () => ref.read(subscriptionRepositoryProvider).purchasePremium(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(SbIcons.check, color: Colors.green, size: 20),
          const SizedBox(width: 12), // Replaced AppLayout.hGap12
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: AppFontSizes.subtitle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureComparison(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compare Plans',
          style: TextStyle(
            fontSize: AppFontSizes.subtitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
        Divider(color: colorScheme.outlineVariant),
        _buildComparisonRow('Basic Calculations', true, true),
        _buildComparisonRow('Offline Usage', true, true),
        _buildComparisonRow('AI Assistant', false, true),
        _buildComparisonRow('Cloud Sync', false, true),
        _buildComparisonRow('Professional Reports', false, true),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, bool free, bool premium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: AppFontSizes.subtitle),
            ),
          ),
          Icon(
            free ? Icons.check_circle : Icons.cancel,
            color: free ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.lg), // Replaced AppLayout.xl (assuming xl=24)
          Icon(
            premium ? Icons.check_circle : Icons.cancel,
            color: premium ? Colors.amber : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
