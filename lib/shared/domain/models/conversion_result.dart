/// FILE HEADER
/// ----------------------------------------------
/// File: conversion_result.dart
/// Feature: unit_converter
/// Layer: domain
///
/// PURPOSE:
/// Represents the output of a deterministic conversion calculation.
///
/// RESPONSIBILITIES:
/// - Holds the primary requested conversion target.
/// - Includes secondary values (like converting m to ft also gives inches for free).
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Include formatting extensions.
/// ----------------------------------------------
library;


/// CLASS: ConversionResult
/// PURPOSE: Structured container ensuring the UI receives both direct and related conversion context.
class ConversionResult {
  final double mainValue;
  final Map<String, double> secondaryValues;

  const ConversionResult({
    required this.mainValue,
    this.secondaryValues = const {},
  });
}
