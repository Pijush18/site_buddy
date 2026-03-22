/// FILE HEADER
/// ----------------------------------------------
/// File: concrete_grade.dart
/// Feature: calculator
/// Layer: domain
///
/// PURPOSE:
/// Defines the types of concrete grades available for calculation.
///
/// RESPONSIBILITIES:
/// - Provides concrete grade values and their basic properties.
///
/// DEPENDENCIES:
/// - none
///
/// FUTURE IMPROVEMENTS:
/// - Support custom ratios or other grades (like M30, M35).
///
/// ----------------------------------------------
library;


/// CLASS: ConcreteGrade
/// PURPOSE: Enumerates the supported grades of concrete and their mix proportions.
/// WHY: To enforce strong typing and centralize grade properties rather than hardcoding.
enum ConcreteGrade {
  m10(label: 'M10', customRatioSum: 10.0), // 1:3:6
  m15(label: 'M15', customRatioSum: 7.0), // 1:2:4
  m20(label: 'M20', customRatioSum: 5.5), // 1:1.5:3
  m25(label: 'M25', customRatioSum: 4.0); // 1:1:2

  final String label;

  /// The sum of the ratio parts. e.g., M20 is 1:1.5:3 so the sum is 5.5
  final double customRatioSum;

  const ConcreteGrade({required this.label, required this.customRatioSum});
}



