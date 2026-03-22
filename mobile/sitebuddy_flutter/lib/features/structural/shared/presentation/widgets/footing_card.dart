import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

/// WIDGET: FootingCard
/// A premium-styled card used on the footing type selection screen.
/// DESIGN: Standardized with AppCard and circular icon background.
// Footing Card component ...

class FootingCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const FootingCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SBGridActionCard(
      label: title,
      icon: icon,
      onTap: onTap,
    );
  }
}




