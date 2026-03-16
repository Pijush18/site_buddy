import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

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
        String message = 'Authentication failed.';
        if (error is firebase.FirebaseAuthException) {
          switch (error.code) {
            case 'user-not-found':
              message = 'No account found for this email.';
              break;
            case 'wrong-password':
              message = 'Incorrect password.';
              break;
            case 'invalid-credential':
              message = 'Invalid email or password.';
              break;
            case 'user-disabled':
              message = 'This account has been disabled.';
              break;
            case 'too-many-requests':
              message = 'Too many attempts. Try again later.';
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
        title: const Text('Verify Your Email'),
        content: const Text(
          'Please verify your email before signing in. Check your inbox for the verification link.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authRepositoryProvider).logout();
              Navigator.pop(context);
            },
            child: const Text('Back to Login'),
          ),
          SbButton.primary(
            label: 'Resend Email',
            onPressed: () async {
              try {
                await user.sendEmailVerification();
                if (context.mounted) {
                  SbFeedback.showToast(
                    context: context,
                    message: 'Verification email sent!',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  SbFeedback.showToast(context: context, message: 'Failed to send: $e');
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

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: AppLayout.paddingLarge,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (AppLayout.pLarge * 2),
                ),
                child: IntrinsicHeight(
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
                              'Sign In',
                              style: theme.textTheme.headlineSmall,
                            ),
                            AppLayout.vGap8,
                            Text(
                              'Welcome back to your workspace',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppLayout.vGap32,

                      // Login Card
                      SbCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SbInput(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              label: "Email",
                              hint: "your@email.com",
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                              prefixIcon: Icon(SbIcons.account, color: colorScheme.primary),
                            ),
                            AppLayout.vGap16,
                            SbInput(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              label: "Password",
                              hint: "••••••••",
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _login(),
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
                                child: const Text("Forgot password?"),
                              ),
                            ),
                            AppLayout.vGap16,
                            SbButton.primary(
                              label: "Sign In",
                              onPressed: (isLoading ||
                                      _emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty)
                                  ? null
                                  : _login,
                              isLoading: isLoading,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      AppLayout.vGap32,

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppLayout.md),
                            child: Text(
                              'OR CONTINUE WITH',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.outline,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      AppLayout.vGap32,

                      // OAuth Buttons
                      Column(
                        children: [
                          SbButton.outline(
                            label: 'Continue with Google',
                            icon: SbIcons.google,
                            onPressed: isLoading ? null : _loginWithGoogle,
                            width: double.infinity,
                          ),
                          if (Platform.isIOS) ...[
                            AppLayout.vGap16,
                            const SbButton.outline(
                              label: 'Continue with Apple',
                              icon: SbIcons.apple,
                              onPressed: null, // Placeholder for future implementation
                              width: double.infinity,
                            ),
                          ],
                        ],
                      ),
                      AppLayout.vGap48,

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: theme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              "Create account",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
