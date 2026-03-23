// lib/core/widgets/widgets_exports.dart
//
// WIDGETS EXPORTS
// ===============
// This file re-exports all atomic/molecular UI components.
// Import from here instead of individual files.
//
// ATOMIC COMPONENTS:
// - SBText: Unified text component (replaces all Text usage)
// - SBButton: Unified button component (replaces all button usage)
// - SBTextField: Unified text input component
// - SBIconButton: Unified icon button component
// - SBDivider: Unified divider component
//
// MOLECULAR COMPONENTS:
// - SBSection: Section wrapper with header
// - SbSectionHeader: Section header component
// - AppScreenWrapper: Screen layout wrapper

export 'sb_text.dart';
export 'sb_button.dart';
export 'sb_text_field.dart';
export 'sb_icon_button.dart';
export 'sb_divider.dart';

// Pre-existing molecular components
export 'sb_section.dart';
export 'sb_section_header.dart';
export 'app_screen_wrapper.dart';