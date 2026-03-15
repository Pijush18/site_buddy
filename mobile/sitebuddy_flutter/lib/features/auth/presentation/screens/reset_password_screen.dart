import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

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
      SbFeedback.showToast(context: context, message: 'Please enter your email');
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
        String message = 'Failed to send reset email.';
        if (error is firebase.FirebaseAuthException) {
          if (error.code == 'user-not-found') {
            message = 'No account found for this email.';
          } else if (error.code == 'invalid-email') {
            message = 'Invalid email address.';
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
        title: const Text('Email Sent'),
        content: Text(
          'A password reset link has been sent to $email. Please check your inbox and follow the instructions.',
        ),
        actions: [
          SbButton.primary(
            label: 'Back to Login',
            onPressed: () => context.go('/login'),
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppLayout.paddingLarge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  SbIcons.engineering,
                  size: 64,
                  color: colorScheme.primary,
                ),
                AppLayout.vGap16,
                Text(
                  'SiteBuddy',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                AppLayout.vGap8,
                Text(
                  'Professional Structural Design Suite',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppLayout.vGap48,

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppLayout.vGap8,
                      Text(
                        'Enter your email to receive a reset link',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppLayout.vGap32,

                // Auth Card
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SbInput(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'Email',
                        hint: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _resetPassword(),
                        prefixIcon: Icon(SbIcons.account, color: colorScheme.primary),
                      ),
                      AppLayout.vGap24,
                      SbButton.primary(
                        label: 'Send Reset Link',
                        onPressed: (isLoading || _emailController.text.isEmpty) ? null : _resetPassword,
                        isLoading: isLoading,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
                AppLayout.vGap24,
                SbButton.ghost(
                  label: 'Back to Sign In',
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
