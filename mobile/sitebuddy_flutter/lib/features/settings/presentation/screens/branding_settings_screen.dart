import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/branding/branding_provider.dart';
import 'package:site_buddy/features/auth/application/user_provider.dart';
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
    final branding = ref.read(brandingProvider).profile;
    final user = ref.read(userProvider).value;
    
    _companyController = TextEditingController(text: branding.companyName);
    // Prefer name from User model for the "Engineer Name" field
    _engineerController = TextEditingController(
      text: (user?.name != null && user!.name.isNotEmpty) 
          ? user.name 
          : branding.engineerName
    );
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
        message: 'Company and Engineer names cannot be blank.',
      );
      return;
    }

    try {
      // 1. Update Profile Controller (User model - name and persistence)
      await ref.read(profileControllerProvider.notifier).updateName(engineer);
      
      // 2. Update Branding Provider (Report branding - company and engineer name)
      await ref.read(brandingProvider.notifier).updateProfile(
            companyName: company,
            engineerName: engineer,
          );
      
      if (mounted) {
        SbFeedback.showToast(
          context: context,
          message: 'Profile updated successfully!',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        SbFeedback.showToast(
          context: context,
          message: 'Update failed: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _resetBranding() async {
    await ref.read(brandingProvider.notifier).resetToDefault();
    if (mounted) {
      final branding = ref.read(brandingProvider).profile;
      _companyController.text = branding.companyName;
      _engineerController.text = branding.engineerName;
      setState(() {});
      SbFeedback.showToast(context: context, message: 'Defaults Restored');
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandingState = ref.watch(brandingProvider);
    final isSyncing = brandingState.isLoading;

    // Listen for sync results to show global feedback
    ref.listen(brandingProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) {
        if (next.errorMessage != null) {
          SbFeedback.showToast(
            context: context,
            message: 'Sync Failed: ${next.errorMessage}',
            isError: true,
          );
        } else if (next.isSuccess) {
          SbFeedback.showToast(
            context: context,
            message: 'Profile Synced Successfully',
          );
        }
      }
    });

    return SbPage.form(
      title: 'Branding',
      primaryAction: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: isSyncing ? null : _saveBranding,
            child: isSyncing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
          const SizedBox(height: SbSpacing.sm),
          TextButton(
            onPressed: isSyncing ? null : _resetBranding,
            child: const Text('Reset Defaults'),
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
                  'Profile',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  'Customize report identity.',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const SizedBox(height: SbSpacing.xl),
                _buildInputLabel(context, 'Company Name'),
                const SizedBox(height: SbSpacing.sm),
                SbInput(
                  controller: _companyController,
                  hint: 'e.g., ABC Infra Pvt Ltd',
                  keyboardType: TextInputType.text,
                  label: 'Company',
                  onChanged: (v) {},
                ),
                const SizedBox(height: SbSpacing.md),
                _buildInputLabel(context, 'Lead Engineer'),
                const SizedBox(height: SbSpacing.sm),
                SbInput(
                  controller: _engineerController,
                  hint: 'e.g., Er. Pijush Debbarma',
                  keyboardType: TextInputType.name,
                  label: 'Lead Engineer',
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











