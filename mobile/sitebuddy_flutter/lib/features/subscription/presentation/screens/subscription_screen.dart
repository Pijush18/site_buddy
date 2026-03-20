import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/subscription/application/subscription_providers.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/engineering_terms.dart';
import 'package:site_buddy/core/theme/app_colors.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return AppScreenWrapper(
      title: AppStrings.subscription,
      isScrollable: true,
      child: statusAsync.when(
        data: (status) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentStatus(context, status),
            const SizedBox(height: SbSpacing.xxl * 1.5), 
            if (!status.isPremium) ...[
              Text(
                AppStrings.upgradeToPremium,
                style: Theme.of(context).textTheme.titleLarge!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SbSpacing.sm), 
              Text(
                AppStrings.unlockAIPower,
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SbSpacing.xxl), 
              _buildPremiumCard(context, ref),
            ] else ...[
              SbCard(
                child: Padding(
                  padding: const EdgeInsets.all(SbSpacing.lg),
                  child: Column(
                    children: [
                      Icon(SbIcons.checkFilled, color: AppColors.success(context), size: 48),
                      const SizedBox(height: SbSpacing.lg), 
                      Text(
                        AppStrings.premiumUserStatus,
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      const SizedBox(height: SbSpacing.sm), 
                      Text(
                        AppStrings.allToolsUnlocked,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: SbSpacing.xxl * 1.5), 
            _buildFeatureComparison(context),
            const SizedBox(height: SbSpacing.xxl),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCurrentStatus(BuildContext context, dynamic status) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPremium = status.isPremium;
    final bool isActive = status.status == 'active';

    return SbListItemTile(
      icon: isPremium ? SbIcons.premium : SbIcons.account,
      iconColor: isPremium ? AppColors.premium(context) : colorScheme.onSurfaceVariant,
      title: AppStrings.currentPlan,
      subtitle: status.plan.toUpperCase(),
      onTap: () {}, 
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: SbSpacing.sm, vertical: SbSpacing.xs),
        decoration: BoxDecoration(
          color: (isActive ? AppColors.success(context) : AppColors.warning(context)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status.status.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium!,
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
            padding: const EdgeInsets.all(SbSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer, // Standard Slate 100 for premium header
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.premiumLogic,
                  style: Theme.of(context).textTheme.labelLarge!,
                ),
                const SizedBox(height: SbSpacing.sm), 
                Text(
                  AppStrings.monthlyPrice,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SbSpacing.lg),
            child: Column(
              children: [
                _buildBenefitItem(context, AppStrings.fullAIAssistant),
                _buildBenefitItem(context, AppStrings.cloudSync),
                _buildBenefitItem(context, AppStrings.advancedSteelDesign),
                _buildBenefitItem(context, AppStrings.multiProjectManagement),
                const SizedBox(height: SbSpacing.xxl), 
                SbButton.primary(
                  label: AppStrings.subscribeNow,
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
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
      child: Row(
        children: [
          Icon(SbIcons.check, color: AppColors.success(context), size: 20),
          const SizedBox(width: SbSpacing.sm), 
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!,
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
        Text(
          AppStrings.comparePlans,
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        const SizedBox(height: SbSpacing.lg), 
        Divider(color: colorScheme.outline), 
        _buildComparisonRow(context, AppStrings.basicCalculations, true, true),
        _buildComparisonRow(context, AppStrings.offlineUsage, true, true),
        _buildComparisonRow(context, EngineeringTerms.aiAssistant, false, true),
        _buildComparisonRow(context, AppStrings.cloudSync, false, true),
        _buildComparisonRow(context, AppStrings.professionalReports, false, true),
      ],
    );
  }

  Widget _buildComparisonRow(BuildContext context, String feature, bool free, bool premium) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
          Icon(
            free ? Icons.check_circle : Icons.cancel,
            color: free ? AppColors.success(context) : colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: SbSpacing.xxl), 
          Icon(
            premium ? Icons.check_circle : Icons.cancel,
            color: premium ? AppColors.premium(context) : colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}








