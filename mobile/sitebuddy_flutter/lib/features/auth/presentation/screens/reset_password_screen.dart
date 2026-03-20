import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/form_labels.dart';
import 'package:site_buddy/core/constants/error_strings.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
    _emailController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateState);
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      SbFeedback.showToast(context: context, message: ErrorStrings.enterEmail);
      return;
    }

    await ref.read(authControllerProvider.notifier).sendPasswordResetEmail(email);
    
    final authState = ref.read(authControllerProvider);
    if (!authState.hasError) {
      if (mounted) {
        _showSuccessDialog(email);
      }
    } else {
      if (mounted) {
        final error = authState.error;
        String message = ErrorStrings.failedToSendReset;
        if (error is firebase.FirebaseAuthException) {
          if (error.code == 'user-not-found') {
            message = ErrorStrings.userNotFound;
          } else if (error.code == 'invalid-email') {
            message = ErrorStrings.invalidEmail;
          }
        }
        SbFeedback.showToast(context: context, message: message);
      }
    }
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.emailSent),
        content: Text(
          '${AppStrings.passwordResetLinkSentPrefix}$email${AppStrings.passwordResetLinkSentSuffix}',
        ),
        actions: [
          SbButton.primary(
            label: AppStrings.backToLogin,
            onPressed: () => context.go('/login'),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return AppScreenWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: SbSpacing.xxl * 2), // Extra top spacing
          Icon(
            SbIcons.engineering,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)
          Text(
            AppStrings.siteBuddy,
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          const SizedBox(height: SbSpacing.sm), // Replaced const SizedBox(height: SbSpacing.sm)
          Text(
            AppStrings.structuralDesignSuite,
            style: Theme.of(context).textTheme.bodyMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SbSpacing.xxl * 2), // Replaced const SizedBox(height: SbSpacing.xs)8

          const SbSectionHeader(
            title: AppStrings.forgotPassword,
          ),
          Text(
            AppStrings.enterEmailToReset,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          const SizedBox(height: SbSpacing.xxl + SbSpacing.sm), // Replaced AppLayout.vGap32 (approx)

          // Auth Card
          SbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SbInput(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: FormLabels.email,
                  hint: FormLabels.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _resetPassword(),
                  prefixIcon: Icon(SbIcons.account, color: colorScheme.primary),
                ),
                const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
                SbButton.primary(
                  label: AppStrings.sendResetLink,
                  onPressed: (isLoading || _emailController.text.isEmpty) ? null : _resetPassword,
                  isLoading: isLoading,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
          SbButton.secondary(
            label: AppStrings.backToSignIn,
            onPressed: () => context.go('/login'),
            width: double.infinity,
          ),
          const SizedBox(height: SbSpacing.xxl), // Bottom padding
        ],
      ),
    );
  }
}











