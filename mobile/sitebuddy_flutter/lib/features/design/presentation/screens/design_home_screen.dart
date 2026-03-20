import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/features/design/application/controllers/design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_category_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/rcc_info_bottom_sheet.dart';

/// SCREEN: DesignHomeScreen
/// PURPOSE: Main hub for structural design information and RCC standards.
/// RULE: SbPage → SbSectionList → SbSection (NO loose widgets).
class DesignHomeScreen extends ConsumerWidget {
  const DesignHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designControllerProvider);

    return SbPage.scaffold(
      title: 'Structural Design',
      body: SbSectionList(
        sections: [
          // ── SECTION 1: HERO BANNER (FIXED: now wrapped in SbSection) ──
          const SbSection(
            title: null, // IMPORTANT: no title, but still behaves as a section
            child: _DesignInfoBanner(),
          ),

          // ── SECTION 2: DESIGN CATEGORIES ──
          SbSection(
            title: 'Design Categories',
            subtitle: 'RCC standards and reinforcement guides.',
            child: SbCard(
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
          ),

          // ── SECTION 3: ENGINEERING STANDARDS ──
          SbSection(
            title: 'Key References',
            subtitle: 'Access national structural design codes.',
            child: SbListGroup(
              children: [
                SbListItemTile(
                  icon: SbIcons.description,
                  title: 'IS 456:2000',
                  subtitle: 'Plain and Reinforced Concrete Code',
                  onTap: () {},
                ),
                SbListItemTile(
                  icon: SbIcons.description,
                  title: 'IS 800:2007',
                  subtitle: 'Steel Construction Code of Practice',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner showing summary info about the Design module.
/// IMPORTANT: This widget must NOT add external spacing.
/// Section controls spacing, not this widget.
class _DesignInfoBanner extends StatelessWidget {
  const _DesignInfoBanner();

  @override
  Widget build(BuildContext context) {
    return const SbModuleHero(
      icon: SbIcons.architecture,
      title: 'Structural Reference',
      subtitle:
          'Quickly access standard engineering RCC specifications for site reference and planning.',
    );
  }
}



