import 'package:site_buddy/core/design_system/sb_icons.dart';
/// FILE HEADER
/// ----------------------------------------------
/// File: design_controller.dart
/// Feature: design
/// Layer: application/controllers
///
/// PURPOSE:
/// Manages state for the Design module using Riverpod.
///
/// RESPONSIBILITIES:
/// - Provides a list of available structural design categories.
/// - Handles selection of a design item for detailed viewing.
/// ----------------------------------------------


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:site_buddy/shared/domain/models/design/design_item.dart';

/// State for the Design module.
class DesignState {
  final List<DesignItem> items;
  final DesignItem? selectedItem;
  final bool isLoading;

  const DesignState({
    this.items = const [],
    this.selectedItem,
    this.isLoading = false,
  });

  DesignState copyWith({
    List<DesignItem>? items,
    DesignItem? selectedItem,
    bool? isLoading,
    bool clearSelection = false,
  }) {
    return DesignState(
      items: items ?? this.items,
      selectedItem: clearSelection ? null : (selectedItem ?? this.selectedItem),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for DesignController.
final designControllerProvider =
    NotifierProvider<DesignController, DesignState>(DesignController.new);

class DesignController extends Notifier<DesignState> {
  @override
  DesignState build() {
    // Initial data load (static for now, could be from a use case/repo)
    return DesignState(items: _getInitialItems());
  }

  /// METHOD: selectItem
  /// PURPOSE: Sets the currently selected design item.
  void selectItem(DesignItem item) {
    state = state.copyWith(selectedItem: item);
  }

  /// METHOD: clearSelection
  /// PURPOSE: Deselects any active design item.
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// HELPER: _getInitialItems
  /// PURPOSE: Returns the list of standard structural design categories.
  List<DesignItem> _getInitialItems() {
    return const [
      DesignItem(
        id: 'slab',
        title: 'Slab Design',
        description: 'Standard RCC specifications for floor and roof slabs.',
        icon: SbIcons.layers,
        rccSpecs: [
          RccSpec(label: 'Concrete Grade', value: 'M20 - M25'),
          RccSpec(label: 'Min Thickness', value: '125 mm'),
          RccSpec(label: 'Main Rebar', value: '8mm or 10mm @ 150mm c/c'),
          RccSpec(label: 'Clear Cover', value: '15 mm - 20 mm'),
        ],
      ),
      DesignItem(
        id: 'beam',
        title: 'Beam Design',
        description: 'RCC guidelines for structural beams.',
        icon: Icons.view_headline,
        rccSpecs: [
          RccSpec(label: 'Concrete Grade', value: 'M25'),
          RccSpec(label: 'Min Width', value: '230 mm'),
          RccSpec(label: 'Avg Rebar', value: '12mm or 16mm'),
          RccSpec(label: 'Clear Cover', value: '25 mm'),
        ],
      ),
      DesignItem(
        id: 'column',
        title: 'Column Design',
        description: 'Vertical structural member specifications.',
        icon: SbIcons.viewColumn,
        rccSpecs: [
          RccSpec(label: 'Concrete Grade', value: 'M25 - M30'),
          RccSpec(label: 'Min Size', value: '230mm x 300mm'),
          RccSpec(label: 'Main Rebar', value: 'Min 4 bars of 12mm'),
          RccSpec(label: 'Clear Cover', value: '40 mm'),
        ],
      ),
      DesignItem(
        id: 'footing',
        title: 'Footing Design',
        description: 'Foundation and soil-bearing specifications.',
        icon: SbIcons.foundation,
        rccSpecs: [
          RccSpec(label: 'Concrete Grade', value: 'M20'),
          RccSpec(label: 'Min Depth', value: '300 mm'),
          RccSpec(label: 'Rebar Mesh', value: '10mm or 12mm @ 150mm c/c'),
          RccSpec(label: 'Clear Cover', value: '50 mm'),
        ],
      ),
    ];
  }
}



