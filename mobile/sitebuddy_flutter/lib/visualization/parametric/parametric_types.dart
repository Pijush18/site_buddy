import 'dart:ui';

/// Parametric parameter definition
class Parameter {
  final String name;
  final String unit;
  final double defaultValue;
  final double min;
  final double max;
  final List<double>? discreteValues;

  const Parameter({
    required this.name,
    required this.unit,
    required this.defaultValue,
    required this.min,
    required this.max,
    this.discreteValues,
  });
}

/// Parametric expression evaluator
abstract class ParametricEvaluator {
  /// Evaluate expression with parameter values
  double evaluate(String expression, Map<String, double> values);

  /// Parse and validate expression
  bool validate(String expression);

  /// Get list of parameters in expression
  List<String> getParameters(String expression);
}

/// Parametric curve generator
abstract class CurveGenerator {
  /// Generate points for a parametric curve
  List<Offset> generateCurve(
    String xExpression,
    String yExpression,
    double tStart,
    double tEnd,
    int samples,
    Map<String, double> values,
  );

  /// Generate surface mesh
  List<List<Offset>> generateSurface(
    String xExpression,
    String yExpression,
    String zExpression,
    Rect uRange,
    Rect vRange,
    int uSamples,
    int vSamples,
    Map<String, double> values,
  );
}
