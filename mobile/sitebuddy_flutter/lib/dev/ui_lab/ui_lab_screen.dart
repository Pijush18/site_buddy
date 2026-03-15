import 'package:site_buddy/core/design_system/sb_icons.dart';
import 'package:site_buddy/core/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:site_buddy/core/widgets/sb_widgets.dart';

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
    return SbPage.scaffold(
      title: 'SiteBuddy UI Laboratory',
      appBarActions: [
        IconButton(
          icon: const Icon(SbIcons.refresh),
          onPressed: () => setState(() {}),
          tooltip: 'Refresh Lab',
        ),
      ],
      body: Column(
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
          Expanded(
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
      padding: const EdgeInsets.all(AppLayout.pMedium),
      children: const [
        ColorsLabSection(),
        AppLayout.vGap32,
        TypographyLabSection(),
        AppLayout.vGap32,
        SpacingLabSection(),
        AppLayout.vGap32,
        RadiusLabSection(),
      ],
    );
  }
}

class _ComponentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppLayout.pMedium),
      children: const [
        ComponentLabSection(),
        AppLayout.vGap32,
        EngineeringWidgetsSection(),
      ],
    );
  }
}

class _LayoutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppLayout.pMedium),
      children: const [LayoutLabSection()],
    );
  }
}
