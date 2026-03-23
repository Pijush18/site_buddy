import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/subscription/subscription_tier.dart';
import 'package:site_buddy/core/subscription/subscription_provider.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// SCREEN: PaywallScreen
/// Displays subscription options to unlock premium features.
class PaywallScreen extends ConsumerWidget {
  final VoidCallback? onUpgrade;
  final String? featureName;

  const PaywallScreen({
    super.key,
    this.onUpgrade,
    this.featureName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(SbSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: SbSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(SbSpacing.lg),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        size: 64,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: SbSpacing.lg),
                    Text(
                      featureName != null 
                          ? 'Unlock $featureName'
                          : 'Upgrade to Premium',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SbSpacing.sm),
                    Text(
                      featureName != null
                          ? 'Get unlimited access to all features'
                          : 'Get the full SiteBuddy experience',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Current tier indicator
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(SbSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: SbSpacing.sm),
                      Text(
                        'Current: ${subscription.tierBadge}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SbSpacing.xl)),

            // Pro Plan
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: _PricingCard(
                  tier: SubscriptionTier.pro,
                  title: 'Pro',
                  subtitle: 'Most Popular',
                  price: PricingConstants.proMonthlyDisplay,
                  yearlyPrice: PricingConstants.proYearlyDisplay,
                  lifetimePrice: PricingConstants.proLifetimeDisplay,
                  features: const [
                    'Unlimited Projects',
                    'Full Diagram Features',
                    'High-Res PDF Export',
                    'Annotation Tools',
                    'Full History',
                  ],
                  isRecommended: true,
                  onSelect: () => _handleUpgrade(context, ref, SubscriptionTier.pro),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SbSpacing.md)),

            // Premium Plan
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: _PricingCard(
                  tier: SubscriptionTier.premium,
                  title: 'Premium',
                  subtitle: 'Everything + More',
                  price: PricingConstants.premiumMonthlyDisplay,
                  yearlyPrice: PricingConstants.premiumYearlyDisplay,
                  lifetimePrice: PricingConstants.premiumLifetimeDisplay,
                  features: const [
                    'All Pro Features',
                    'Multi-Page Reports',
                    'Advanced Snapping',
                    'Measurement Tools',
                    'Priority Features',
                  ],
                  onSelect: () => _handleUpgrade(context, ref, SubscriptionTier.premium),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SbSpacing.xl)),

            // Comparison link
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: Center(
                  child: TextButton(
                    onPressed: () => _showComparison(context),
                    child: const Text('View Full Comparison'),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SbSpacing.lg)),

            // Close button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                child: GhostButton(
                  label: 'Maybe Later',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SbSpacing.xl)),
          ],
        ),
      ),
    );
  }

  void _handleUpgrade(BuildContext context, WidgetRef ref, SubscriptionTier tier) {
    // TODO: Integrate with actual payment gateway
    // For now, just upgrade locally
    ref.read(subscriptionProvider.notifier).upgradeTo(
      tier,
      expiresAt: DateTime.now().add(const Duration(days: 365)), // 1 year subscription
      purchaseId: 'test_purchase_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upgraded to ${tier.displayName}!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
    onUpgrade?.call();
  }

  void _showComparison(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _ComparisonSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final SubscriptionTier tier;
  final String title;
  final String subtitle;
  final String price;
  final String yearlyPrice;
  final String lifetimePrice;
  final List<String> features;
  final bool isRecommended;
  final VoidCallback onSelect;

  const _PricingCard({
    required this.tier,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.yearlyPrice,
    required this.lifetimePrice,
    required this.features,
    this.isRecommended = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPro = tier == SubscriptionTier.pro;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isRecommended ? colorScheme.primary : colorScheme.outlineVariant,
          width: isRecommended ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(vertical: SbSpacing.xs),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: SbSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SbSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isPro 
                            ? colorScheme.primaryContainer 
                            : colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tier.displayName.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isPro
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SbSpacing.md),
                
                // Pricing options
                _PriceOption(label: 'Monthly', price: price),
                _PriceOption(label: 'Yearly', price: yearlyPrice, isHighlighted: true),
                _PriceOption(label: 'Lifetime', price: lifetimePrice),
                
                const SizedBox(height: SbSpacing.md),
                const Divider(),
                const SizedBox(height: SbSpacing.md),
                
                // Features list
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: SbSpacing.sm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: isPro ? colorScheme.primary : colorScheme.tertiary,
                      ),
                      const SizedBox(width: SbSpacing.sm),
                      Expanded(
                        child: Text(
                          feature,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: SbSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: isRecommended
                      ? PrimaryCTA(label: 'Get Started', onPressed: onSelect)
                      : OutlinedButton(
                          onPressed: onSelect,
                          child: Text('Choose $title'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceOption extends StatelessWidget {
  final String label;
  final String price;
  final bool isHighlighted;

  const _PriceOption({
    required this.label,
    required this.price,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: SbSpacing.xs),
      child: Row(
        children: [
          Radio<String>(
            value: price,
            groupValue: price,
            onChanged: (_) {},
            visualDensity: VisualDensity.compact,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SbSpacing.sm,
              vertical: 2,
            ),
            decoration: isHighlighted
                ? BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: Text(
              price,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isHighlighted ? colorScheme.onPrimaryContainer : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonSheet extends StatelessWidget {
  final ScrollController scrollController;

  const _ComparisonSheet({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: SbSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Feature Comparison',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SbSpacing.lg),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(SbSpacing.lg),
              children: [
                _ComparisonRow(
                  feature: 'Projects',
                  free: '3',
                  pro: 'Unlimited',
                  premium: 'Unlimited',
                ),
                _ComparisonRow(
                  feature: 'Calculations',
                  free: 'Basic',
                  pro: 'Unlimited',
                  premium: 'Unlimited',
                ),
                _ComparisonRow(
                  feature: 'Diagram Features',
                  free: 'Basic',
                  pro: 'Full',
                  premium: 'Full',
                ),
                _ComparisonRow(
                  feature: 'Export Quality',
                  free: 'Low-Res',
                  pro: 'High-Res',
                  premium: 'Ultra HD',
                ),
                _ComparisonRow(
                  feature: 'PDF Export',
                  free: 'Basic',
                  pro: 'High-Qity',
                  premium: 'Multi-Page',
                ),
                _ComparisonRow(
                  feature: 'Annotations',
                  free: '❌',
                  pro: '✓',
                  premium: '✓',
                ),
                _ComparisonRow(
                  feature: 'History',
                  free: 'Recent',
                  pro: 'Full',
                  premium: 'Full',
                ),
                _ComparisonRow(
                  feature: 'Advanced Snapping',
                  free: '❌',
                  pro: '❌',
                  premium: '✓',
                ),
                _ComparisonRow(
                  feature: 'Measurement Tools',
                  free: '❌',
                  pro: '❌',
                  premium: '✓',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final String free;
  final String pro;
  final String premium;

  const _ComparisonRow({
    required this.feature,
    required this.free,
    required this.pro,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: SbSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              free,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              pro,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              premium,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
