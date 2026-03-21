/// BARREL: SiteBuddy Core Design System Widgets
/// PURPOSE: Single entry point for all reusable SiteBuddy core widgets.
/// Rule: All new core interaction widgets MUST be exported here.
library;

// 🧊 Layout & Structure
export 'sb_page.dart';
export 'sb_page_layout.dart';
export 'sb_section_list.dart';
export 'sb_section.dart';
export 'sb_section_header.dart';
export 'sb_grid.dart';
export 'sb_list_group.dart';
export 'sb_tool_grid_section.dart';
export 'screen_padding.dart';

// 🎨 Surfaces & Cards
export 'sb_card.dart';
export 'sb_grid_card.dart';
export 'sb_module_hero.dart';
export 'feature_card.dart';
export 'project_card.dart';
export 'sb_smart_assistant_card.dart';
export 'code_reference_card.dart';
export 'previewable_card.dart';
export 'info_card.dart';
export 'action_card.dart';

// ⌨️ Inputs & Controls
export 'sb_button.dart';
export 'sb_input.dart';
export 'sb_dropdown.dart';
export 'sb_selection.dart';
export 'segmented_toggle.dart';
export 'educational_toggle.dart';
export 'smart_assistant_input.dart';

// 📝 List Items & Tiles
export 'sb_list_item_tile.dart';
export 'sb_action_tile.dart';
export 'sb_settings_tile.dart';
export 'sb_list_item.dart';

// 🔔 Feedback & State
export 'sb_feedback.dart';
export 'sb_empty_state.dart';

// ⚠️ DEPRECATED (Legacy Compatibility)
@Deprecated('Use SbPage or SbSectionList instead')
export 'app_screen_wrapper.dart';
@Deprecated('Use SbSectionList instead')
export 'app_scaffold.dart';
@Deprecated('Use SbCard or SbGridCard instead')
export 'app_card.dart';
@Deprecated('Use SbGridCard instead')
export 'app_stat_card.dart';
@Deprecated('Replacement pending')
export 'app_header.dart';
@Deprecated('Replacement pending')
export 'app_bottom_navigation.dart';
@Deprecated('Replacement pending')
export 'app_report_dialog.dart';



