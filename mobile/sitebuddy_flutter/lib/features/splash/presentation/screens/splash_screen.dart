
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// SCREEN: SplashScreen
/// PURPOSE: Initial loading screen that waits for application bootstrap.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialization();
  }

  void _checkInitialization() {
    // We check if initialization is already done
    // and listen for changes.
    final initialized = ref.read(initializationProvider);
    if (initialized) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Small delay to ensure smooth transition
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for initialization completion
    ref.listen(initializationProvider, (previous, next) {
      if (next == true) {
        _navigateToHome();
      }
    });

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScreenWrapper(
      title: null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: SbSpacing.xxl * 2), // Replaced AppLayout.vGap64
            // Logo
            Icon(
              SbIcons.engineering,
              size: 64, // Standard large icon size
              color: colorScheme.primary,
            ),
            const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

            // App Name
            Text(
              'SiteBuddy',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: SbSpacing.lg), // Replaced const SizedBox(height: SbSpacing.lg)

            // Tagline
            Text(
              'Civil Engineering Intelligence',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24

            // Loading Indicator
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            
            const SizedBox(height: SbSpacing.xxl * 2), // Replaced const SizedBox(height: SbSpacing.xs)8

            // Footer
            Text(
              '© Pijush Debbarma',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            const SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap24
          ],
        ),
      ),
    );
  }
}











