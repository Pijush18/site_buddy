import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_category_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/rcc_info_bottom_sheet.dart';

/// SCREEN: DesignHomeScreen
/// PURPOSE: Main hub for structural design information and RCC standards.
/// RULE: AppScreenWrapper → SbSectionList → SbSection.
class DesignHomeScreen extends ConsumerWidget {
  const DesignHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designControllerProvider);
    
    return AppScreenWrapper(
      title: 'Structural Design',
      child: SbSectionList(
        sections: [
          // ── SECTION 1: HERO BANNER ──
          const _DesignInfoBanner(),

          // ── SECTION 2: DESIGN CATEGORIES ──
          SbSection(
            title: 'Design Categories',
            child: SbGrid(
              children: state.items.map((item) {
                return DesignCategoryCard(
                  icon: item.icon,
                  label: item.title,
                  onTap: () => RccInfoBottomSheet.show(context, item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner showing summary info about the Design module.
class _DesignInfoBanner extends StatelessWidget {
  const _DesignInfoBanner();

  @override
  Widget build(BuildContext context) {
    return const SbModuleHero(
      icon: SbIcons.architecture,
      title: 'Structural Reference',
      subtitle: 'Quickly access standard engineering RCC specifications for site reference and planning.',
    );
  }
}
