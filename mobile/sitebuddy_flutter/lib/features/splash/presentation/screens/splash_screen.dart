
import 'package:site_buddy/core/design_system/sb_spacing.dart';
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
  @override
  void initState() {
    super.initState();
    // Trigger initialization - this starts the async initialization chain
    _triggerInitialization();
  }

  /// Trigger initialization by watching the provider.
  /// The provider is lazy, so watching it starts the initialization.
  void _triggerInitialization() {
    // By watching the provider, we trigger its lazy initialization
    // The FutureProvider will execute and complete when all async work is done
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
  }

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

    return SbPage.scaffold(
      title: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: SbSpacing.xxl * 2), 
            // Logo
            Icon(
              SbIcons.engineering,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: SbSpacing.xxl), 

            // App Name
            Text(
              'SiteBuddy',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: SbSpacing.lg),

            // Tagline
            Text(
              'Civil Engineering Intelligence',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            const SizedBox(height: SbSpacing.xxl), 

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
            
            const SizedBox(height: SbSpacing.xxl * 2), 

            // Footer
            Text(
              '© Pijush Debbarma',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            const SizedBox(height: SbSpacing.xxl), 
          ],
        ),
      ),
    );
  }
}
