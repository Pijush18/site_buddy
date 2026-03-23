
import 'package:site_buddy/core/theme/app_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// SCREEN: SplashScreen
/// PURPOSE: Initial loading screen that waits for application bootstrap.
/// 
/// [REFACTORED] - Now uses appInitializerProvider for proper async initialization.
/// The old AppInitializer class is deprecated.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void _navigateToHome() {
    // Small delay to ensure smooth transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && context.mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the initialization provider
    // This triggers the async initialization and rebuilds when complete
    final initAsync = ref.watch(appInitializerProvider);

    // Listen for initialization completion to trigger navigation
    // ref.listen is valid here in build() method
    ref.listen(appInitializerProvider, (previous, next) {
      next.when(
        data: (_) => _navigateToHome(),
        loading: () {},
        error: (e, st) {
          // Handle initialization error - still navigate but could show error
          debugPrint('Initialization error: $e');
          _navigateToHome();
        },
      );
    });

    return SbPage.scaffold(
      title: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xxl * 2), 
            // Logo
            Icon(
              SbIcons.engineering,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.xxl), 

            // App Name
            Text(
              'SiteBuddy',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tagline
            Text(
              'Civil Engineering Intelligence',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: AppSpacing.xxl), 

            // Loading Indicator
            // Show progress based on initialization state
            initAsync.when(
              data: (_) => Icon(
                Icons.check_circle,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              loading: () => CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              error: (e, st) => Icon(
                Icons.warning,
                size: 32,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl * 2), 

            // Footer
            Text(
              '© Pijush Debbarma',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            const SizedBox(height: AppSpacing.xxl), 
          ],
        ),
      ),
    );
  }
}
