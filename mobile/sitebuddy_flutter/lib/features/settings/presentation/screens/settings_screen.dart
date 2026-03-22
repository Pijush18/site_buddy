import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/providers/settings_provider.dart';
import 'package:site_buddy/core/enums/unit_system.dart';
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/error_strings.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/application/user_provider.dart';
import 'package:go_router/go_router.dart';

/// SCREEN: SettingsScreen
/// PURPOSE: Standardized global app settings (Theming, Language, Professional Profile).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SbPage.scaffold(
      title: AppStrings.settings,
      body: SbSectionList(
        sections: [
          // --- SECTION 1: ACCOUNT ---
          SbSection(
            title: AppStrings.account,
            child: _buildAccountSection(context),
          ),

          // --- SECTION: APPEARANCE ---
          SbSection(
            title: AppStrings.appearance,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.palette,
                    title: AppStrings.themeMode,
                    subtitle: AppStrings.chooseHowAppAppears,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<ThemeMode>(
                          value: settings.themeMode,
                          items: const [
                            ThemeMode.system,
                            ThemeMode.light,
                            ThemeMode.dark,
                          ],
                          labelBuilder: (mode) {
                            switch (mode) {
                              case ThemeMode.system:
                                return AppStrings.auto;
                              case ThemeMode.light:
                                return AppStrings.light;
                              case ThemeMode.dark:
                                return AppStrings.dark;
                            }
                          },
                          onChanged: (mode) => ref
                              .read(settingsProvider.notifier)
                              .setTheme(mode),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.refresh,
                    title: AppStrings.language,
                    subtitle: AppStrings.selectPreferredLanguage,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<String>(
                          value: settings.locale,
                          items: const ['en', 'hi'],
                          labelBuilder: (code) =>
                              code == 'en' ? AppStrings.english : AppStrings.hindi,
                          onChanged: (code) {
                            ref.read(settingsProvider.notifier).setLocale(code);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- SECTION: ENGINEERING STANDARDS ---
          SbSection(
            title: AppStrings.engineeringStandards,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    isVertical: true,
                    icon: SbIcons.ruler,
                    title: AppStrings.unitSystem,
                    subtitle: AppStrings.selectMeasurementSystem,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final settings = ref.watch(settingsProvider);
                        return SegmentedToggle<UnitSystem>(
                          value: settings.unitSystem,
                          items: UnitSystem.values,
                          labelBuilder: (unit) => unit == UnitSystem.metric
                              ? AppStrings.metric
                              : AppStrings.imperial,
                          onChanged: (unit) => ref
                              .read(settingsProvider.notifier)
                              .setUnitSystem(unit),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- SECTION: APP BEHAVIOR ---
          SbSection(
            title: AppStrings.appBehavior,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Consumer(
                builder: (context, ref, _) {
                  final settings = ref.watch(settingsProvider);
                  return Column(
                    children: [
                      SbSettingsTile(
                        isVertical: true,
                        icon: SbIcons.refresh,
                        title: AppStrings.restoreLastScreen,
                        subtitle: AppStrings.continueWhereLeftOff,
                        onTap: () => ref
                            .read(settingsProvider.notifier)
                            .setRestoreLastScreen(!settings.restoreLastScreen),
                        trailing: Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: settings.restoreLastScreen,
                            onChanged: (value) => ref
                                .read(settingsProvider.notifier)
                                .setRestoreLastScreen(value),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      SbSettingsTile(
                        icon: SbIcons.history,
                        title: AppStrings.resetToDefault,
                        subtitle: AppStrings.revertSettingsState,
                        onTap: () => _showResetDialog(context, ref),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // --- SECTION: LEGAL ---
          SbSection(
            title: AppStrings.legal,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SbSettingsTile(
                    icon: SbIcons.shield,
                    title: AppStrings.privacyPolicy,
                    onTap: () async {
                      final url = Uri.parse("https://pijush.com/privacy-policy/");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.description,
                    title: AppStrings.termsOfService,
                    onTap: () async {
                      final url = Uri.parse("https://pijush.com/terms-of-service/");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- SECTION: ABOUT ---
          SbSection(
            title: AppStrings.about,
            child: SbCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const SbSettingsTile(
                    icon: SbIcons.info,
                    title: AppStrings.appVersion,
                    subtitle: AppStrings.appVersionValue,
                  ),
                  const Divider(height: 1, indent: 56),
                  const SbSettingsTile(
                    icon: SbIcons.profile,
                    title: AppStrings.developer,
                    subtitle: AppStrings.developerName,
                  ),
                  const Divider(height: 1, indent: 56),
                  SbSettingsTile(
                    icon: SbIcons.link,
                    title: AppStrings.website,
                    subtitle: AppStrings.developerWebsite,
                    onTap: () async {
                      final url = Uri.parse("https://www.pijush.com");
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final accountAsync = ref.watch(accountDataProvider);

        return accountAsync.when(
          data: (accountData) {
            if (accountData == null) return const SizedBox.shrink();
            return _buildProfileCard(context, ref, accountData);
          },
          loading: () => const _AccountSkeleton(),
          error: (e, _) => _AccountError(
            message: ErrorStrings.syncError,
            onRetry: () => ref.invalidate(accountDataProvider),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    AccountData data,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = data.profile;

    return Column(
      children: [
        // 1. Primary Account Info Card
        SbCard(
          padding: const EdgeInsets.all(SbSpacing.md),
          child: Row(
            children: [
              GestureDetector(
                onDoubleTap: () =>
                    ref.read(profileControllerProvider.notifier).pickImage(),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  backgroundImage: user.profileImage != null
                      ? FileImage(File(user.profileImage!))
                      : null,
                  child: user.profileImage == null
                      ? Icon(
                          SbIcons.account,
                          size: 30,
                          color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.isEmpty ? AppStrings.developerName : user.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email.isEmpty
                          ? AppStrings.noEmailRegistered
                          : user.email,
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SbSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SbSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (data.subscription.isPremium
                                ? AppStrings.premiumPlan
                                : AppStrings.freePlan)
                            .toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: SbSpacing.md),

        // 2. Action List Card
        SbCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SbSettingsTile(
                icon: SbIcons.profile,
                title: AppStrings.editProfile,
                onTap: () => context.push('/settings/branding'),
              ),
              const Divider(height: 1, indent: 56, endIndent: SbSpacing.md),
              SbSettingsTile(
                icon: SbIcons.payments,
                title: AppStrings.subscriptionBilling,
                onTap: () => context.push('/subscription'),
              ),
              const Divider(height: 1, indent: 56, endIndent: SbSpacing.md),
              SbSettingsTile(
                icon: SbIcons.logout,
                title: AppStrings.logout,
                onTap: () async {
                  await ref.read(authRepositoryProvider).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.resetSettingsQuestion, style: textTheme.titleLarge),
        content: Text(
          AppStrings.resetSettingsDisclaimer,
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel, style: textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).setTheme(ThemeMode.system);
              ref
                  .read(settingsProvider.notifier)
                  .setUnitSystem(UnitSystem.metric);
              ref.read(settingsProvider.notifier).setLocale('en');
              ref.read(settingsProvider.notifier).setRestoreLastScreen(false);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppStrings.settingsResetToDefaults,
                    style: textTheme.bodyMedium,
                  ),
                ),
              );
            },
            child: Text(AppStrings.reset, style: textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

/// PRIVATE WIDGET: _AccountSkeleton
/// Provides a non-blocking placeholder for account loading.
class _AccountSkeleton extends StatelessWidget {
  const _AccountSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greyColor = theme.colorScheme.surfaceContainerHighest;

    return Column(
      children: [
        SbCard(
          padding: const EdgeInsets.all(SbSpacing.md),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: greyColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: SbSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 120, color: greyColor),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 180, color: greyColor),
                    const SizedBox(height: 8),
                    Container(height: 10, width: 60, color: greyColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SbSpacing.md),
        SbCard(
          padding: const EdgeInsets.symmetric(vertical: SbSpacing.sm),
          child: Column(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SbSpacing.md,
                vertical: SbSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(width: 24, height: 24, color: greyColor),
                  const SizedBox(width: 16),
                  Container(height: 12, width: 100, color: greyColor),
                ],
              ),
            )),
          ),
        ),
      ],
    );
  }
}

/// PRIVATE WIDGET: _AccountError
class _AccountError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AccountError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SbCard(
      padding: const EdgeInsets.all(SbSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 24),
              const SizedBox(width: SbSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SbSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: const Text(AppStrings.reset), 
          ),
        ],
      ),
    );
  }
}
