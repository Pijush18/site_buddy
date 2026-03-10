/// FILE HEADER
/// ----------------------------------------------
/// File: ai_service.dart
/// Feature: ai
/// Layer: application
///
/// PURPOSE:
/// Serves as the abstraction point for invoking external Large Language Models to parse natural language constraints.
///
/// RESPONSIBILITIES:
/// - Connects to the LLM (currently mocked but using standard REST protocol struct).
/// - Enforces strictly structured JSON output from raw text inputs.
/// - Catches mapping exceptions safely and returns an `AiResult` wrapper.
///
/// DEPENDENCIES:
/// - Current execution depends on local mocking to replicate production API flows.
/// - `dart:convert` for jsonDecode.
/// - `ai_result.dart` domain entity.
///
library;

/// - Inject standard `http.Client` for real API call implementations.
/// - Implement retry logic (e.g., exponential backoff) for failed JSON outputs from the AI.
/// ----------------------------------------------


import 'dart:convert';

import 'package:site_buddy/features/ai/domain/entities/ai_result.dart';
import 'package:site_buddy/shared/domain/models/concrete_grade.dart';

/// CLASS: AiService
/// PURPOSE: Executes complex NLP parsing by delegating to an LLM.
/// WHY: Protects the strict Riverpod controller from holding HTTP communication bounds directly.
class AiService {
  /// METHOD: parseInput
  /// PURPOSE: Sends user input to LLM, enforcing JSON syntax, and returning deterministic values.
  /// PARAMETERS: input (String) representing messy NLP text.
  /// RETURNS: `Future<AiResult>` indicating either success or a safe fallback failure string.
  Future<AiResult> parseInput(String input) async {
    // ----------------------------------------------------
    // PROMPT SYSTEM INSTRUCTION:
    // Extract construction parameters from this sentence:
    // Return JSON ONLY:
    // {
    //   "length": number (in meters),
    //   "width": number (in meters),
    //   "depth": number (in meters),
    //   "grade": "M15" | "M20" | "M25"
    // }
    // Rules:
    // - Convert feet/inches to meters internally
    // - Depth must be in meters
    // - If missing, return null
    // - DO NOT explain anything
    // ----------------------------------------------------

    // --- MOCKED API CALL DELAY ---
    // Simulating remote HTTP/API latency for production feel
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simulate an LLM attempting to parse the specific target test cases
      final String llmResponse = _mockLlmInference(input);

      // 1. Validate structural JSON form
      final Map<String, dynamic> jsonResponse = jsonDecode(llmResponse);

      // 2. Safely parse variables considering double/int conversion idiosyncrasies
      final length = _parseDouble(jsonResponse['length']);
      final width = _parseDouble(jsonResponse['width']);
      final depth = _parseDouble(jsonResponse['depth']);

      // 3. Map string exact bounds to Domain Enum
      ConcreteGrade? grade;
      final gradeStr = jsonResponse['grade']?.toString().toUpperCase();
      if (gradeStr != null) {
        if (gradeStr == 'M15') grade = ConcreteGrade.m15;
        if (gradeStr == 'M20') grade = ConcreteGrade.m20;
        if (gradeStr == 'M25') grade = ConcreteGrade.m25;
      }

      // Check for partial vs total failure
      if (length == null && width == null && depth == null && grade == null) {
        return const AiResult(
          isValid: false,
          message:
              'Could not understand structural dimensions. Try format like: 10m x 5m x 0.15m M20',
        );
      }

      return AiResult(
        length: length,
        width: width,
        depth: depth,
        grade: grade,
        isValid: true,
        message: 'Success',
      );
    } catch (e) {
      // JSON Parsing Exception or other general API failures
      return const AiResult(
        isValid: false,
        message:
            'AI proxy failed to construct parameter JSON. Try format like: 10m x 5m x 0.15m M20',
      );
    }
  }

  /// HELPER METHOD: _parseDouble
  /// safely converts num/int/string variations commonly emitted inconsistently by LLMs.
  double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }

  /// HELPER METHOD: _mockLlmInference
  /// Simulating deterministic "understanding" based on keywords.
  /// In reality, this would just be: `httpClient.post(AiConfig.endpoint, body: prompt + input)`
  String _mockLlmInference(String input) {
    final lower = input.toLowerCase();

    // Heuristics mocking an LLM specifically instructed on the test input format:
    // "20x15 ft slab, 6 inch thick, M20"
    if (lower.contains('ft') || lower.contains('inch')) {
      // Let's pretend the LLM smartly converted these to meters already.
      // 20 ft -> ~6.096 m
      // 15 ft -> ~4.572 m
      // 6 in  -> ~0.1524 m
      return '''
      {
        "length": 6.096,
        "width": 4.572,
        "depth": 0.1524,
        "grade": "M20"
      }
      ''';
    }

    if (lower.contains('10m x 5m slab m20')) {
      return '''
      {
        "length": 10.0,
        "width": 5.0,
        "depth": null,
        "grade": "M20"
      }
      ''';
    }

    // Default error mimic
    return '{ "error": "unrecognized input" }';
  }
}
