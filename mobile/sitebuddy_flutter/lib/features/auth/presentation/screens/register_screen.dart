import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:site_buddy/core/constants/app_strings.dart';
import 'package:site_buddy/core/constants/form_labels.dart';
import 'package:site_buddy/core/constants/error_strings.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
    
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
    _confirmPasswordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _confirmPasswordController.removeListener(_updateState);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || !email.contains('@')) {
      SbFeedback.showToast(context: context, message: ErrorStrings.enterValidEmail);
      return;
    }

    if (password != confirmPassword) {
      SbFeedback.showToast(context: context, message: ErrorStrings.passwordsDoNotMatch);
      return;
    }

    if (password.length < 6) {
      SbFeedback.showToast(context: context, message: ErrorStrings.passwordTooShort);
      return;
    }

    await ref.read(authControllerProvider.notifier).registerWithEmail(email, password.trim());
    
    final authState = ref.read(authControllerProvider);
    if (!authState.hasError) {
      if (mounted) _showSuccessPrompt();
    } else {
      if (mounted) {
        final error = authState.error;
        String message = ErrorStrings.registrationFailed;
        if (error is firebase.FirebaseAuthException) {
          if (error.code == 'email-already-in-use') {
            message = ErrorStrings.emailAlreadyInUse;
          } else if (error.code == 'weak-password') {
            message = ErrorStrings.weakPassword;
          } else if (error.code == 'network-request-failed') {
            message = ErrorStrings.networkError;
          }
        }
        SbFeedback.showToast(context: context, message: message);
      }
    }
  }

  void _showSuccessPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.accountCreated),
        content: const Text(AppStrings.verifyEmailToSignIn),
        actions: [
          PrimaryCTA(
            label: AppStrings.backToLogin,
            onPressed: () {
              ref.read(authRepositoryProvider).logout();
              context.go('/login');
            },
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

    return SbPage.scaffold(
      body: SbSectionList(
        sections: [
          // ── HEADER ──
          SbSection(
            child: Column(
              children: [
                const SizedBox(height: SbSpacing.xxl),
                Icon(
                  SbIcons.engineering,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: SbSpacing.lg),
                Text(
                  AppStrings.siteBuddy,
                  style: Theme.of(context).textTheme.titleLarge!,
                ),
                const SizedBox(height: SbSpacing.sm),
                Text(
                  AppStrings.structuralDesignSuite,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // ── REGISTER FORM ──
          SbSection(
            title: AppStrings.createAccount,
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    prefixIcon:
                        Icon(SbIcons.account, color: colorScheme.primary),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbInput(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    label: FormLabels.password,
                    hint: FormLabels.passwordHint,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        _confirmPasswordFocusNode.requestFocus(),
                    prefixIcon: Icon(SbIcons.lock, color: colorScheme.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? SbIcons.visibility
                            : SbIcons.visibilityOff,
                        color: colorScheme.outline,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: SbSpacing.lg),
                  SbInput(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    label: FormLabels.confirmPassword,
                    hint: FormLabels.passwordHint,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    prefixIcon: Icon(SbIcons.lock, color: colorScheme.primary),
                  ),
                  const SizedBox(height: SbSpacing.xxl),
                  PrimaryCTA(
                    label: AppStrings.register,
                    onPressed: (isLoading ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _confirmPasswordController.text.isEmpty)
                        ? null
                        : _register,
                    isLoading: isLoading,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),

          // ── ACTIONS ──
          SbSection(
            child: SecondaryButton(
              label: AppStrings.alreadyHaveAccountSignIn,
              onPressed: () => context.go('/login'),
              width: double.infinity,
            ),
          ),
          const SizedBox(height: SbSpacing.xxl),
        ],
      ),
    );
  }
}











