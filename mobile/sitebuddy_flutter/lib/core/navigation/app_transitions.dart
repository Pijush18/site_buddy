import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  /// Standard page transition used across the app
  static CustomTransitionPage<T> fadeSlide<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0), // subtle right → center
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
