import 'package:site_buddy/core/design_system/sb_icons.dart';

import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';
import 'package:site_buddy/core/widgets/sb_module_hero.dart';
import 'package:site_buddy/features/design/application/controllers/design_controller.dart';
import 'package:site_buddy/features/design/presentation/widgets/design_category_card.dart';
import 'package:site_buddy/features/design/presentation/widgets/rcc_info_bottom_sheet.dart';

/// SCREEN: DesignHomeScreen
/// PURPOSE: Main hub for structural design information and RCC standards.
class DesignHomeScreen extends ConsumerWidget {
  const DesignHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designControllerProvider);
    return SbPage.detail(
      title: 'Structural Design',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DesignInfoBanner(),
          AppLayout.vGap24,

          // Header Section
          SbSection(
            title: 'Design Categories',
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppLayout.verticalSpace,
                crossAxisSpacing: AppLayout.horizontalSpace,
                childAspectRatio: 1.0,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return DesignCategoryCard(
                  icon: item.icon,
                  label: item.title,
                  onTap: () {
                    debugPrint(
                      'ACTION: DesignCategoryCard tapped for ${item.id}',
                    );
                    RccInfoBottomSheet.show(context, item);
                  },
                );
              },
            ),
          ),
          AppLayout.vGap32,
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
