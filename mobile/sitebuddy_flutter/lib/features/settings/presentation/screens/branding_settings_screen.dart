import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/theme/app_font_sizes.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

import 'package:site_buddy/core/branding/branding_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BrandingSettingsScreen extends ConsumerStatefulWidget {
  const BrandingSettingsScreen({super.key});

  @override
  ConsumerState<BrandingSettingsScreen> createState() =>
      _BrandingSettingsScreenState();
}

class _BrandingSettingsScreenState
    extends ConsumerState<BrandingSettingsScreen> {
  late final TextEditingController _companyController;
  late final TextEditingController _engineerController;

  @override
  void initState() {
    super.initState();
    final branding = ref.read(brandingProvider);
    _companyController = TextEditingController(text: branding.companyName);
    _engineerController = TextEditingController(text: branding.engineerName);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _engineerController.dispose();
    super.dispose();
  }

  Future<void> _saveBranding() async {
    final company = _companyController.text.trim();
    final engineer = _engineerController.text.trim();

    if (company.isEmpty || engineer.isEmpty) {
      SbFeedback.showToast(
        context: context,
        message: 'Company and Engineer names cannot be securely blank.',
      );
      return;
    }

    await ref
        .read(brandingProvider.notifier)
        .updateFields(companyName: company, engineerName: engineer);

    if (mounted) {
      SbFeedback.showToast(
        context: context,
        message: 'Settings saved successfully!',
      );
      context.pop();
    }
  }

  Future<void> _resetBranding() async {
    await ref.read(brandingProvider.notifier).resetToDefault();
    if (mounted) {
      final branding = ref.read(brandingProvider);
      _companyController.text = branding.companyName;
      _engineerController.text = branding.engineerName;
      setState(() {});
      SbFeedback.showToast(context: context, message: 'Defaults Restored');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: 'Report Branding',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enterprise Profile',
            style: TextStyle(
              fontSize: AppFontSizes.title, // headline-like
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          Text(
            'Customize the identity projected natively across multi-page Site Reports and PDF deployments securely.',
            style: TextStyle(
              fontSize: AppFontSizes.subtitle,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          _buildInputLabel(context, 'Company / Enterprise Name'),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          SbInput(
            controller: _companyController,
            hint: 'e.g., ABC Infra Pvt Ltd',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          _buildInputLabel(context, 'Lead Engineer Name'),
          const SizedBox(height: AppSpacing.sm), // Replaced AppLayout.vGap8
          SbInput(
            controller: _engineerController,
            hint: 'e.g., Er. Pijush Debbarma',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: AppSpacing.lg), // Replaced AppLayout.vGap24
          SbButton.primary(
            label: 'Save Branding Profile',
            onPressed: _saveBranding,
          ),
          const SizedBox(height: AppSpacing.md), // Replaced AppLayout.vGap16
          SbButton.ghost(
            label: 'Reset to Site Buddy Defaults',
            onPressed: _resetBranding,
          ),
          const SizedBox(height: AppSpacing.lg), // Added for consistency
        ],
      ),
    );
  }

  Widget _buildInputLabel(BuildContext context, String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: AppFontSizes.tab, // Button text style equiv
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
