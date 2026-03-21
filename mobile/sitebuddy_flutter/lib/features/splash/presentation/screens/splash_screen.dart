
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
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


    return SbPage.scaffold(
      title: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SbSpacing.xxl * 2), 
            // Logo
            Icon(
              SbIcons.engineering,
              size: 64, // Standard large icon size
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: SbSpacing.xxl), 

            // App Name
            Text(
              'SiteBuddy',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            SizedBox(height: SbSpacing.lg), // Replaced SizedBox(height: SbSpacing.lg)

            // Tagline
            Text(
              'Civil Engineering Intelligence',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            SizedBox(height: SbSpacing.xxl), 

            // Loading Indicator
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            
            SizedBox(height: SbSpacing.xxl * 2), 

            // Footer
            Text(
              '© Pijush Debbarma',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            SizedBox(height: SbSpacing.xxl), 
          ],
        ),
      ),
    );
  }
}











