import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/form_labels.dart';
import 'package:site_buddy/core/constants/error_strings.dart';
import 'package:site_buddy/core/constants/screen_titles.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });

    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ref.read(authControllerProvider.notifier).loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    final authState = ref.read(authControllerProvider);
    if (!authState.hasError) {
      final user = firebase.FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        if (mounted) _showVerificationPrompt(user);
        return;
      }
      if (mounted) context.go('/');
    } else {
      if (mounted) {
        final error = authState.error;
        String message = ErrorStrings.authFailed;
        if (error is firebase.FirebaseAuthException) {
          switch (error.code) {
            case 'user-not-found':
              message = ErrorStrings.userNotFound;
              break;
            case 'wrong-password':
              message = ErrorStrings.wrongPassword;
              break;
            case 'invalid-credential':
              message = ErrorStrings.invalidCredential;
              break;
            case 'user-disabled':
              message = ErrorStrings.userDisabled;
              break;
            case 'too-many-requests':
              message = ErrorStrings.tooManyRequests;
              break;
          }
        }
        SbFeedback.showToast(context: context, message: message);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    await ref.read(authControllerProvider.notifier).loginWithGoogle();
    if (!ref.read(authControllerProvider).hasError) {
      if (mounted) context.go('/');
    }
  }

  void _showVerificationPrompt(firebase.User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(ScreenTitles.verifyYourEmail),
        content: const Text(AppStrings.pleaseVerifyEmail),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authRepositoryProvider).logout();
              Navigator.pop(context);
            },
            child: const Text(AppStrings.backToLogin),
          ),
          SbButton.primary(
            label: AppStrings.resendEmail,
            onPressed: () async {
              try {
                await user.sendEmailVerification();
                if (context.mounted) {
                  SbFeedback.showToast(
                    context: context,
                    message: AppStrings.verificationEmailSent,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                   SbFeedback.showToast(context: context, message: '${ErrorStrings.failedToSend}$e');
                }
              }
            },
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
      child: SbSectionList(
        sections: [
          // ── HEADER ──
          SbSection(
            child: Column(
              children: [
                const SizedBox(height: SbSpacing.xxl),
                Icon(SbIcons.engineering, size: 64, color: colorScheme.primary),
                const SizedBox(height: SbSpacing.lg),
                Text(AppStrings.siteBuddy, style: theme.textTheme.titleLarge),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  AppStrings.structuralDesignSuite,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // ── LOGIN FORM ──
          SbSection(
            title: AppStrings.signIn,
            child: SbCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SbInput(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    label: FormLabels.email,
                    hint: FormLabels.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(SbIcons.account, color: colorScheme.primary),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbInput(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    label: FormLabels.password,
                    hint: FormLabels.passwordHint,
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(SbIcons.lock, color: colorScheme.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? SbIcons.visibility : SbIcons.visibilityOff,
                        color: colorScheme.outline,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/reset-password'),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbButton.primary(
                    label: AppStrings.signIn,
                    onPressed: (isLoading || _emailController.text.isEmpty || _passwordController.text.isEmpty)
                        ? null
                        : _login,
                    isLoading: isLoading,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),

          // ── SOCIAL LOGIN ──
          SbSection(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: SbSpacing.lg),
                      child: Text(AppStrings.orContinueWith, style: theme.textTheme.labelMedium),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: SbSpacing.xl),
                SbButton.secondary(
                  label: AppStrings.continueWithGoogle,
                  icon: SbIcons.google,
                  onPressed: isLoading ? null : _loginWithGoogle,
                  width: double.infinity,
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: SbSpacing.lg),
                  const SbButton.secondary(
                    label: AppStrings.continueWithApple,
                    icon: SbIcons.apple,
                    onPressed: null,
                    width: double.infinity,
                  ),
                ],
              ],
            ),
          ),

          // ── FOOTER LINK ──
          SbSection(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.dontHaveAccount, style: theme.textTheme.bodyLarge),
                const SizedBox(width: SbSpacing.sm),
                GestureDetector(
                  onTap: () => context.go('/register'),
                  child: Text(
                    AppStrings.createAccount,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SbSpacing.xxl),
        ],
      ),
    );
  }
}











