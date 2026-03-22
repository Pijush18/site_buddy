import 'package:flutter/widgets.dart';
import 'package:site_buddy/core/engineering/engineering_constants.dart';
import 'package:site_buddy/core/localization/l10n_extension.dart';

/// HELPER: DiagramTextHelper
/// PURPOSE: Standardized, localization-safe text construction for engineering diagrams.
/// LAYER: Core / Diagram
class DiagramTextHelper {
  DiagramTextHelper._();

  /// "Length (L)"
  static String length(BuildContext context) {
    return '${context.l10n.labelLength} (${EngineeringSymbols.length})';
  }

  /// "Width (B)"
  static String width(BuildContext context) {
    return '${context.l10n.labelWidth} (${EngineeringSymbols.width})';
  }

  /// "Depth (D)"
  static String depth(BuildContext context) {
    return '${context.l10n.labelDepth} (${EngineeringSymbols.depth})';
  }

  /// "Diameter Ø12 mm"
  static String diameterValue(BuildContext context, int value) {
    return '${context.l10n.labelDiameter} ${EngineeringFormatter.dia(value)} ${EngineeringUnits.mm}';
  }

  /// "Length: 500 mm"
  static String lengthValue(BuildContext context, double value) {
    // Format to 0 decimal places if it's a whole number for diagrams
    final displayValue = value == value.toInt() ? value.toInt().toString() : value.toStringAsFixed(1);
    return '${context.l10n.labelLength}: $displayValue ${EngineeringUnits.mm}';
  }

  /// Generic "Label (Symbol)"
  static String labelWithSymbol(String label, String symbol) {
    return '$label ($symbol)';
  }

  /// Generic "Label: Value Unit"
  static String labelWithValue(String label, Object value, String unit) {
    return '$label: $value $unit';
  }

  /// "Reinforcement (As)"
  static String reinforcement(BuildContext context) {
    return '${context.l10n.labelReinforcement} (${EngineeringSymbols.reinforcement})';
  }

  /// "Spacing (s)"
  static String spacing(BuildContext context) {
    return '${context.l10n.labelSpacing} (${EngineeringSymbols.spacing})';
  }

  /// "Load (P)"
  static String load(BuildContext context) {
    return '${context.l10n.labelLoad} (${EngineeringSymbols.load})';
  }
}
