
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
    return SbPage.form(
      title: 'Report Branding',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SbButton.primary(
            label: 'Save Branding Profile',
            onPressed: _saveBranding,
            width: double.infinity,
          ),
          const SizedBox(height: SbSpacing.lg),
          SbButton.ghost(
            label: 'Reset to Site Buddy Defaults',
            onPressed: _resetBranding,
            width: double.infinity,
          ),
        ],
      ),
      body: SbSectionList(
        sections: [
          SbSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enterprise Profile',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  'Customize the identity projected natively across multi-page Site Reports and PDF deployments securely.',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const SizedBox(height: SbSpacing.xxl),
                _buildInputLabel(context, 'Company / Enterprise Name'),
                const SizedBox(height: SbSpacing.sm),
                SbInput(
                  controller: _companyController,
                  hint: 'e.g., ABC Infra Pvt Ltd',
                  keyboardType: TextInputType.text,
                  label: 'COMPANY NAME',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.lg),
                _buildInputLabel(context, 'Lead Engineer Name'),
                const SizedBox(height: SbSpacing.sm),
                SbInput(
                  controller: _engineerController,
                  hint: 'e.g., Er. Pijush Debbarma',
                  keyboardType: TextInputType.name,
                  label: 'ENGINEER NAME',
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge!,
    );
  }
}











