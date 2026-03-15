import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';
import 'package:site_buddy/features/auth/presentation/providers/auth_controller.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

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
      SbFeedback.showToast(context: context, message: 'Please enter a valid email');
      return;
    }

    if (password != confirmPassword) {
      SbFeedback.showToast(context: context, message: 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      SbFeedback.showToast(context: context, message: 'Password must be at least 6 characters');
      return;
    }

    await ref.read(authControllerProvider.notifier).registerWithEmail(email, password.trim());
    
    final authState = ref.read(authControllerProvider);
    if (!authState.hasError) {
      if (mounted) _showSuccessPrompt();
    } else {
      if (mounted) {
        final error = authState.error;
        String message = 'Registration failed.';
        if (error is firebase.FirebaseAuthException) {
          if (error.code == 'email-already-in-use') {
            message = 'Email already registered.';
          } else if (error.code == 'weak-password') {
            message = 'Password is too weak.';
          } else if (error.code == 'network-request-failed') {
            message = 'Network error. Check connection.';
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
        title: const Text('Account Created'),
        content: const Text(
          'Verification email sent. Please verify your email before signing in.',
        ),
        actions: [
          SbButton.primary(
            label: 'Back to Login',
            onPressed: () {
              ref.read(authRepositoryProvider).logout();
              context.go('/login');
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
                              'Join SiteBuddy',
                              style: theme.textTheme.headlineSmall,
                            ),
                            AppLayout.vGap8,
                            Text(
                              'Start your professional design journey',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppLayout.vGap32,

                      // Register Card
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                              prefixIcon: Icon(SbIcons.account, color: colorScheme.primary),
                            ),
                            AppLayout.vGap16,
                            SbInput(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              label: 'Password',
                              hint: '••••••••',
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                              prefixIcon: Icon(SbIcons.lock, color: colorScheme.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? SbIcons.visibility : SbIcons.visibilityOff,
                                  color: colorScheme.outline,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            AppLayout.vGap16,
                            SbInput(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              label: 'Confirm Password',
                              hint: '••••••••',
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _register(),
                              prefixIcon: Icon(SbIcons.lock, color: colorScheme.primary),
                            ),
                            AppLayout.vGap24,
                            SbButton.primary(
                              label: 'Register',
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
                      const Spacer(),
                      AppLayout.vGap24,
                      SbButton.ghost(
                        label: 'Already have an account? Sign In',
                        onPressed: () => context.go('/login'),
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
