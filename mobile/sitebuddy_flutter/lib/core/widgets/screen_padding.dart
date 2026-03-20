import 'package:flutter/material.dart';

/// WIDGET: ScreenPadding
/// PURPOSE: Multi-item wrapper providing global standard horizontal padding (16px).
class ScreenPadding extends StatelessWidget {
  final Widget child;
  final double horizontal;
  final double top;
  final double bottom;

  const ScreenPadding({
    super.key,
    required this.child,
    this.horizontal = 16.0,
    this.top = 0.0,
    this.bottom = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}



