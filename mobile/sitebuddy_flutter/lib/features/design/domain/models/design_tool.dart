import 'package:flutter/widgets.dart';

/// MODEL: DesignTool
/// PURPOSE: Data-driven representation of a structural design tool.
class DesignTool {
  final String title;
  final IconData icon;
  final String route;
  final bool isEnabled;

  const DesignTool({
    required this.title,
    required this.icon,
    required this.route,
    this.isEnabled = true,
  });
}
