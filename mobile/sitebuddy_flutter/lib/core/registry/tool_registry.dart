import 'package:flutter/material.dart';
import 'package:site_buddy/core/design_system/sb_icons.dart';

/// CLASS: ToolDefinition
/// PURPOSE: Data model for a single tool in the registry
class ToolDefinition {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final String category;
  final bool isPrimary;

  const ToolDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.category,
    this.isPrimary = false,
  });
}

/// CLASS: ToolCategory
/// PURPOSE: Data model for tool category grouping
class ToolCategory {
  final String id;
  final String title;
  final List<ToolDefinition> tools;

  const ToolCategory({
    required this.id,
    required this.title,
    required this.tools,
  });
}

/// CLASS: ToolRegistry
/// PURPOSE: Central registry of all SiteBuddy tools
/// This is the data-driven system - UI reads from here, not hardcoded lists
class ToolRegistry {
  ToolRegistry._();

  // ═══════════════════════════════════════════════════════════════════════
  // TOOL DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════

  static final List<ToolDefinition> _allTools = [
    // STRUCTURAL - Design module
    const ToolDefinition(
      id: 'slab_design',
      title: 'Slab Design',
      subtitle: 'RCC Slab Analysis',
      icon: SbIcons.layers,
      route: '/design/slab/input',
      category: 'Structural',
      isPrimary: true,
    ),
    const ToolDefinition(
      id: 'beam_design',
      title: 'Beam Design',
      subtitle: 'RCC Beam Analysis',
      icon: SbIcons.architectureOutlined,
      route: '/design/beam/input',
      category: 'Structural',
    ),
    const ToolDefinition(
      id: 'column_design',
      title: 'Column Design',
      subtitle: 'RCC Column Analysis',
      icon: SbIcons.viewColumn,
      route: '/design/column/input',
      category: 'Structural',
    ),
    const ToolDefinition(
      id: 'footing_design',
      title: 'Footing Design',
      subtitle: 'Foundation Design',
      icon: SbIcons.foundation,
      route: '/design/footing/type',
      category: 'Structural',
    ),

    // ESTIMATION - Calculator module
    const ToolDefinition(
      id: 'material_calculator',
      title: 'Material Calculator',
      subtitle: 'Concrete & Materials',
      icon: SbIcons.calculator,
      route: '/calculator/material',
      category: 'Estimation',
      isPrimary: true,
    ),
    const ToolDefinition(
      id: 'cement_calculator',
      title: 'Cement Calculator',
      subtitle: 'Cement Quantities',
      icon: SbIcons.construction,
      route: '/calculator/cement',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'sand_calculator',
      title: 'Sand Calculator',
      subtitle: 'Sand Quantities',
      icon: SbIcons.terrain,
      route: '/calculator/sand',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'rebar_calculator',
      title: 'Rebar Calculator',
      subtitle: 'Steel Quantities',
      icon: SbIcons.gridView,
      route: '/calculator/rebar',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'brickwall_calculator',
      title: 'Brick Wall',
      subtitle: 'Brick Quantities',
      icon: SbIcons.viewArray,
      route: '/calculator/brick-wall',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'plaster_calculator',
      title: 'Plaster Calculator',
      subtitle: 'Plaster Quantities',
      icon: SbIcons.grain,
      route: '/calculator/plaster',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'excavation_calculator',
      title: 'Excavation',
      subtitle: 'Earthwork Quantities',
      icon: Icons.landscape,
      route: '/calculator/excavation',
      category: 'Estimation',
    ),
    const ToolDefinition(
      id: 'shuttering_calculator',
      title: 'Shuttering',
      subtitle: 'Formwork Quantities',
      icon: SbIcons.construction,
      route: '/calculator/shuttering',
      category: 'Estimation',
    ),

    // FIELD TOOLS
    const ToolDefinition(
      id: 'level_calculator',
      title: 'Level Calculator',
      subtitle: 'Field Leveling',
      icon: SbIcons.ruler,
      route: '/level',
      category: 'Field Tools',
      isPrimary: true,
    ),
    const ToolDefinition(
      id: 'gradient_calculator',
      title: 'Gradient',
      subtitle: 'Slope Calculation',
      icon: SbIcons.trendingUp,
      route: '/calculator/gradient',
      category: 'Field Tools',
    ),
    const ToolDefinition(
      id: 'level_comparator',
      title: 'Level Comparator',
      subtitle: 'Compare Levels',
      icon: SbIcons.compareArrows,
      route: '/calculator/level-comparator',
      category: 'Field Tools',
    ),

    // ROAD
    const ToolDefinition(
      id: 'road_design',
      title: 'Road Design',
      subtitle: 'Pavement Design',
      icon: Icons.traffic,
      route: '/design/road',
      category: 'Road',
      isPrimary: true,
    ),

    // IRRIGATION
    const ToolDefinition(
      id: 'irrigation_design',
      title: 'Irrigation Design',
      subtitle: 'Canal & Pipeline',
      icon: SbIcons.waterDrop,
      route: '/design/irrigation',
      category: 'Irrigation',
      isPrimary: true,
    ),

    // UTILITIES
    const ToolDefinition(
      id: 'unit_converter',
      title: 'Unit Converter',
      subtitle: 'Quick Tools',
      icon: SbIcons.sync,
      route: '/converter',
      category: 'Utilities',
    ),
    const ToolDefinition(
      id: 'currency_converter',
      title: 'Currency',
      subtitle: 'Quick Tools',
      icon: SbIcons.currencyExchange,
      route: '/currency',
      category: 'Utilities',
    ),
    const ToolDefinition(
      id: 'shear_check',
      title: 'Shear Check',
      subtitle: 'Analysis Tools',
      icon: SbIcons.analytics,
      route: '/design/shear-check',
      category: 'Utilities',
    ),
    const ToolDefinition(
      id: 'deflection_check',
      title: 'Deflection',
      subtitle: 'Analysis Tools',
      icon: SbIcons.trendingDown,
      route: '/design/deflection-check',
      category: 'Utilities',
    ),
    const ToolDefinition(
      id: 'cracking_check',
      title: 'Cracking',
      subtitle: 'Analysis Tools',
      icon: Icons.warning,
      route: '/design/cracking-check',
      category: 'Utilities',
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // CATEGORY DEFINITIONS (in display order)
  // ═══════════════════════════════════════════════════════════════════════

  static const List<String> _categoryOrder = [
    'Structural',
    'Estimation',
    'Field Tools',
    'Road',
    'Irrigation',
    'Utilities',
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════

  /// Get all categories with their tools
  static List<ToolCategory> get categories {
    final Map<String, List<ToolDefinition>> grouped = {};

    for (final tool in _allTools) {
      grouped.putIfAbsent(tool.category, () => []).add(tool);
    }

    // Return in order
    return _categoryOrder
        .where((cat) => grouped.containsKey(cat))
        .map((cat) => ToolCategory(
              id: cat.toLowerCase().replaceAll(' ', '_'),
              title: cat,
              tools: grouped[cat]!,
            ))
        .toList();
  }

  /// Get all tools (flat list)
  static List<ToolDefinition> get allTools => _allTools;

  /// Get tools by category
  static List<ToolDefinition> getByCategory(String category) {
    return _allTools.where((t) => t.category == category).toList();
  }

  /// Get primary (featured) tools
  static List<ToolDefinition> get primaryTools {
    return _allTools.where((t) => t.isPrimary).toList();
  }

  /// Get total tool count
  static int get toolCount => _allTools.length;

  /// Get category count
  static int get categoryCount => _categoryOrder.length;
}