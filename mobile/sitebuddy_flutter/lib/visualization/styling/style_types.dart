import 'dart:ui';

/// Line style
class LineStyle {
  final double width;
  final Color color;
  final StrokeCap cap;
  final StrokeJoin join;
  final List<double>? dashPattern;

  const LineStyle({
    this.width = 1.0,
    this.color = const Color(0xFF000000),
    this.cap = StrokeCap.butt,
    this.join = StrokeJoin.miter,
    this.dashPattern,
  });
}

/// Fill style
class FillStyle {
  final Color color;
  final double opacity;
  final HatchPattern? hatch;

  const FillStyle({
    this.color = const Color(0xFFE0E0E0),
    this.opacity = 1.0,
    this.hatch,
  });
}

/// Hatch pattern type
enum HatchPatternType {
  solid,
  horizontal,
  vertical,
  diagonal,
  cross,
  dots,
}

/// Hatch pattern definition
class HatchPattern {
  final HatchPatternType type;
  final double spacing;
  final double angle;
  final Color color;

  const HatchPattern({
    this.type = HatchPatternType.solid,
    this.spacing = 5.0,
    this.angle = 45.0,
    this.color = const Color(0xFF000000),
  });
}

/// Text style
class TextStyle2D {
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final TextAlign align;

  const TextStyle2D({
    this.fontFamily = 'Roboto',
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.color = const Color(0xFF000000),
    this.align = TextAlign.left,
  });
}

/// Style catalog for reusable styles
abstract class StyleCatalog {
  /// Add a named line style
  void addLineStyle(String name, LineStyle style);

  /// Get a line style by name
  LineStyle? getLineStyle(String name);

  /// Add a named fill style
  void addFillStyle(String name, FillStyle style);

  /// Get a fill style by name
  FillStyle? getFillStyle(String name);

  /// Add a named text style
  void addTextStyle(String name, TextStyle2D style);

  /// Get a text style by name
  TextStyle2D? getTextStyle(String name);

  /// List all registered style names
  List<String> getStyleNames(StyleType type);

  /// Remove a style by name
  void removeStyle(String name);
}

/// Style type enum
enum StyleType {
  line,
  fill,
  text,
}
