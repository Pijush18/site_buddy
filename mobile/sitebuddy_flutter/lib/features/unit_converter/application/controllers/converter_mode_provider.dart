/// FILE HEADER
/// ----------------------------------------------
/// File: converter_mode_provider.dart
/// Feature: unit_converter
/// Layer: application/controllers
///
/// PURPOSE:
/// Strictly isolates the UI Tab Mode state (Smart AI vs Manual) from the heavy business logic state.
///
/// RESPONSIBILITIES:
/// - Provide a microscopic, independent state provider to drive the `SegmentedToggle` perfectly.
/// - Prevent macro UI rebuilds when heavy computations occur in the converter form.
///
/// DEPENDENCIES:
/// - Riverpod NotifierProvider
/// ----------------------------------------------
library;


import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the deterministic modes for the smart converter.
enum ConverterMode { ai, manual }

/// High-performance UI provider storing nothing but the strict tab mode.
final converterModeProvider =
    NotifierProvider<ConverterModeNotifier, ConverterMode>(
      ConverterModeNotifier.new,
    );

class ConverterModeNotifier extends Notifier<ConverterMode> {
  @override
  ConverterMode build() => ConverterMode.ai;

  void setMode(ConverterMode activeMode) {
    state = activeMode;
  }
}



