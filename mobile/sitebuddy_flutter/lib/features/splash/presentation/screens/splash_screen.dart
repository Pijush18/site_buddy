import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

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

    return SbPage.detail(
      title: null,
      usePadding: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo
            Icon(
              SbIcons.engineering,
              size: AppLayout.iconSizeLarge,
              color: colorScheme.primary,
            ),
            AppLayout.vGap24,

            // App Name
            Text(
              'SiteBuddy',
              style: theme.textTheme.headlineMedium?.copyWith(
                
                color: colorScheme.primary,
              ),
            ),
            AppLayout.vGap16,

            // Tagline
            Text(
              'Civil Engineering Intelligence',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppLayout.vGap24,

            // Loading Indicator
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const Spacer(),

            // Footer
            Text(
              '© Pijush Debbarma',
              style: theme.textTheme.bodySmall,
            ),
            AppLayout.vGap24,
          ],
        ),
      ),
    );
  }
}
