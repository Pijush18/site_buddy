import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_text_styles.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return SbPage.scaffold(
      title: 'Subscription',
      body: statusAsync.when(
        data: (status) => SingleChildScrollView(
          padding: AppLayout.paddingMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCurrentStatus(context, status),
              AppLayout.vGap32,
              if (!status.isPremium) ...[
                Text(
                  'Upgrade to Premium',
                  style: SbTextStyles.headline(context),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap8,
                Text(
                  'Unlock the full power of SiteBuddy Engineering AI',
                  style: SbTextStyles.body(context).copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap24,
                _buildPremiumCard(context, ref),
              ] else ...[
                const SbCard(
                  child: Padding(
                    padding: AppLayout.paddingMedium,
                    child: Column(
                      children: [
                        Icon(SbIcons.checkFilled, color: Colors.green, size: 48),
                        AppLayout.vGap16,
                        Text(
                          'You are a Premium User',
                          style: TextStyle( ),
                        ),
                        AppLayout.vGap8,
                        Text(
                          'All advanced engineering tools and AI assistant are unlocked.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              AppLayout.vGap32,
              _buildFeatureComparison(context),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context, dynamic status) {
    return SbCard(
      child: ListTile(
        leading: Icon(
          status.isPremium ? SbIcons.premium : SbIcons.account,
          color: status.isPremium ? Colors.amber : Colors.grey,
        ),
        title: const Text('Current Plan'),
        subtitle: Text(status.plan.toUpperCase()),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          
          child: Text(
            status.status.toUpperCase(),
            style: TextStyle(
              
              
              color: status.status == 'active' ? Colors.green : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, WidgetRef ref) {
    return SbCard(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: AppLayout.paddingMedium,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: const Column(
              children: [
                Text(
                  'PREMIUM LOGIC',
                  style: TextStyle( letterSpacing: 1.2),
                ),
                AppLayout.vGap8,
                Text(
                  '\$9.99 / Month',
                  style: TextStyle( ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppLayout.paddingMedium,
            child: Column(
              children: [
                _buildBenefitItem(context, 'Full AI Engineering Assistant'),
                _buildBenefitItem(context, 'PDF Report Cloud Sync'),
                _buildBenefitItem(context, 'Advanced Steel Reinforcement Designs'),
                _buildBenefitItem(context, 'Multi-Project Management'),
                AppLayout.vGap24,
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(SbIcons.check, color: Colors.green, size: 20),
          AppLayout.hGap12,
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildFeatureComparison(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Compare Plans', style: SbTextStyles.title(context)),
        AppLayout.vGap16,
        const Divider(),
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
          Expanded(child: Text(feature)),
          Icon(free ? Icons.check_circle : Icons.cancel, color: free ? Colors.green : Colors.grey, size: 20),
          const SizedBox(width: AppLayout.xl),
          Icon(premium ? Icons.check_circle : Icons.cancel, color: premium ? Colors.amber : Colors.grey, size: 20),
        ],
      ),
    );
  }
}
