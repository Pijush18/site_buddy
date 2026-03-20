import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/design_system/sb_spacing.dart';
import 'package:site_buddy/core/widgets/app_screen_wrapper.dart';
import 'package:flutter/material.dart';

// Sections
import 'package:site_buddy/dev/ui_lab/sections/colors_lab_section.dart';
import 'package:site_buddy/dev/ui_lab/sections/typography_lab_section.dart';
import 'package:site_buddy/dev/ui_lab/sections/spacing_radius_section.dart';
import 'package:site_buddy/dev/ui_lab/sections/component_lab_section.dart';
import 'package:site_buddy/dev/ui_lab/sections/engineering_widgets_section.dart';
import 'package:site_buddy/dev/ui_lab/sections/layout_lab_section.dart';

class UiLabScreen extends StatefulWidget {
  const UiLabScreen({super.key});

  @override
  State<UiLabScreen> createState() => _UiLabScreenState();
}

class _UiLabScreenState extends State<UiLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenWrapper(
      title: 'SiteBuddy UI Laboratory',
      actions: [
        IconButton(
          icon: const Icon(SbIcons.refresh),
          onPressed: () => setState(() {}),
          tooltip: 'Refresh Lab',
        ),
      ],
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Design Tokens'),
              Tab(text: 'Components'),
              Tab(text: 'Layout & Grid'),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7, // Basic height to contain TabBarView
            child: TabBarView(
              controller: _tabController,
              children: [_DesignTokensTab(), _ComponentsTab(), _LayoutTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesignTokensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SbSpacing.lg),
      children: const [
        ColorsLabSection(),
        SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32
        TypographyLabSection(),
        SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32
        SpacingLabSection(),
        SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32
        RadiusLabSection(),
      ],
    );
  }
}

class _ComponentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SbSpacing.lg),
      children: const [
        ComponentLabSection(),
        SizedBox(height: SbSpacing.xxl), // Replaced AppLayout.vGap32
        EngineeringWidgetsSection(),
      ],
    );
  }
}

class _LayoutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SbSpacing.lg),
      children: const [LayoutLabSection()],
    );
  }
}







