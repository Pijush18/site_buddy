import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// SbInteractiveCard
/// ------------------------------------------------------------
/// A reusable interactive wrapper that adds:
/// - Tap animation (scale)
/// - Ripple effect
/// - Consistent interaction feedback
///
/// This should wrap ALL tappable cards across the app.
///
/// Usage:
/// SbInteractiveCard(
///   onTap: () {},
///   child: YourCardContent(),
/// )
/// ------------------------------------------------------------
class SbInteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Duration duration;

  const SbInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<SbInteractiveCard> createState() => _SbInteractiveCardState();
}

class _SbInteractiveCardState extends State<SbInteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  static const double _pressedScale = 0.97;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: _pressedScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    if (widget.onTap == null) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            splashFactory: InkRipple.splashFactory,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
