import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

class SharedActionButtons extends StatelessWidget {
  final String calculateLabel;
  final bool isLoading;
  final VoidCallback onCalculate;
  final VoidCallback onReset;
  final VoidCallback onShare;

  const SharedActionButtons({
    super.key,
    required this.calculateLabel,
    required this.isLoading,
    required this.onCalculate,
    required this.onReset,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SbButton.primary(
            label: isLoading ? 'Calculating...' : calculateLabel,
            onPressed: isLoading ? null : onCalculate,
          ),
        ),
        const SizedBox(width: AppLayout.sm),
        _buildCircularAction(SbIcons.refresh, 'Reset', onReset),
        const SizedBox(width: AppLayout.sm),
        _buildCircularAction(SbIcons.share, 'Share', onShare),
      ],
    );
  }

  Widget _buildCircularAction(
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return SbCard(
      child: SbButton.icon(icon: icon, onPressed: onTap),
    );
  }
}
