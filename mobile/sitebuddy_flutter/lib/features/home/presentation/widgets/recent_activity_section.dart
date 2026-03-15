
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/features/home/application/controllers/home_controller.dart';
import 'package:site_buddy/features/home/presentation/widgets/activity_tile.dart';

/// WIDGET: RecentActivitySection
/// PURPOSE: Renders the list of recent history items on the home screen.
class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    if (state.recentActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < state.recentActivities.length; i++) ...[
          _PressableActivityTile(activity: state.recentActivities[i]),
          if (i < state.recentActivities.length - 1)
            AppLayout.vGap16,
        ],
      ],
    );
  }
}

class _PressableActivityTile extends StatefulWidget {
  final dynamic activity;
  const _PressableActivityTile({required this.activity});

  @override
  State<_PressableActivityTile> createState() => _PressableActivityTileState();
}

class _PressableActivityTileState extends State<_PressableActivityTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: ActivityTile(activity: widget.activity),
      ),
    );
  }
}
