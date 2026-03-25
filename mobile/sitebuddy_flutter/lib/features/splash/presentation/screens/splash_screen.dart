
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:site_buddy/core/navigation/app_routes.dart';
import 'package:site_buddy/app/bootstrap/app_initializer.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/shared/application/providers/active_project_provider.dart';

/// SCREEN: SplashScreen
/// PURPOSE: Initial loading screen that waits for application bootstrap.
/// 
<<<<<<< HEAD
/// [REFACTORED] - Now uses appInitializerProvider for proper async initialization.
/// The old AppInitializer class is deprecated.
=======
/// NAVIGATION FLOW:
/// - Waits for initialization
/// - ALWAYS navigates to Home first
/// - Project-dependent routes are protected by router guard
/// - Has fallback timeout to prevent infinite loading
/// 
/// NOTE: We always go to Home, not ProjectList. The router's scoped
/// project guard will redirect to /projects only when accessing
/// restricted routes (design, reports) without a project.
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
<<<<<<< HEAD
=======
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    debugPrint("Splash: Starting initialization check");
    
    try {
      // Check if already initialized
      final initialized = ref.read(initializationProvider);
      if (initialized) {
        debugPrint("Splash: Already initialized, navigating to Home");
        _navigateToHome();
        return;
      }

      // Listen for initialization completion
      ref.listen(initializationProvider, (previous, next) {
        debugPrint("Splash: Initialization provider changed: $next");
        if (next == true && !_hasNavigated) {
          _navigateToHome();
        }
      });

      debugPrint("Splash: Waiting for initialization");
    } catch (e) {
      debugPrint("Splash: Error during initialization check: $e");
      // On error, still navigate to home
      _navigateToHome();
    }

    // FALLBACK TIMEOUT: Always navigate after 3 seconds max
    // This prevents infinite loading if provider never completes
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint("Splash: Fallback timeout reached");
      if (!_hasNavigated && mounted) {
        debugPrint("Splash: Navigating via fallback");
        _navigateToHome();
      }
    });
  }

  /// Navigate to Home screen
  /// Project-dependent routes are protected by router guard
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
  void _navigateToHome() {
    if (_hasNavigated) {
      debugPrint("Splash: Already navigated, skipping");
      return;
    }

    _hasNavigated = true;
    
    // Check project state for logging
    final activeProject = ref.read(activeProjectProvider);
    debugPrint("Splash: Active project exists: ${activeProject != null}");
    debugPrint("Splash: Navigating to Home (tab index 0)");
    
    // Small delay to ensure smooth transition
    Future.delayed(const Duration(milliseconds: 500), () {
<<<<<<< HEAD
      if (mounted && context.mounted) {
=======
      if (mounted) {
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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

=======
>>>>>>> 64d70f8 (fix(navigation): resolve Home opening Project tab due to ShellRoute index mismatch)
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
