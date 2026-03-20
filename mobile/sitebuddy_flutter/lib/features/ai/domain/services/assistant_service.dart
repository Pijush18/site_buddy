

/// FILE HEADER
/// ----------------------------------------------
/// File: assistant_service.dart
/// Feature: ai_assistant
/// Layer: domain/services
///
/// PURPOSE:
/// Provides deterministic engineering guidance and explanations.
/// ----------------------------------------------
library;

import 'package:site_buddy/features/ai/domain/entities/assistant_response.dart';

class AssistantService {
  /// Explains the calculation results in plain engineering terms.
  static AssistantResponse explainResult(
    String moduleType,
    Map<String, dynamic> resultData,
  ) {
    if (moduleType.toLowerCase() == 'beam') {
      final isSafe = resultData['isSafe'] ?? true;
      return AssistantResponse(
        title: 'Beam Analysis Explanation',
        message: isSafe
            ? 'The beam section is adequate for the applied loads. The moment capacity exceeds the factored moment and shear reinforcement meets IS 456 requirements.'
            : 'The beam section has failed one or more safety checks. Either the moment of resistance is less than the applied moment, or shear reinforcement is insufficient.',
        suggestions: isSafe
            ? ['Consider optimizing concrete grade for economy.']
            : [
                'Increase depth (D) or width (b).',
                'Check shear stirrups spacing.',
              ],
      );
    }

    // Default fallback
    return const AssistantResponse(
      title: 'Design Summary',
      message:
          'Analysis complete based on provided input parameters and IS 456:2000 standards.',
    );
  }

  /// Suggests improvements for the design based on inputs and results.
  static AssistantResponse suggestImprovements(
    Map<String, dynamic> inputData,
    Map<String, dynamic> resultData,
  ) {
    final List<String> suggestions = [];
    final double? width = double.tryParse(inputData['width']?.toString() ?? '');
    final double? depth = double.tryParse(inputData['depth']?.toString() ?? '');

    if (width != null && depth != null && depth / width > 3) {
      suggestions.add(
        'Aspect ratio (D/b) is quite high. Consider a wider section for lateral stability.',
      );
    }

    if (inputData['concreteGrade'] == 'M20') {
      suggestions.add(
        'Using M25 or higher is recommended for better durability in structural members.',
      );
    }

    return AssistantResponse(
      title: 'Optimization Suggestions',
      message: suggestions.isEmpty
          ? 'The current parameters are within standard engineering ranges.'
          : 'Based on your inputs, here are some optimization opportunities:',
      suggestions: suggestions,
    );
  }

  /// Validates inputs for realism and standard limits.
  static List<String> validateInputs(Map<String, dynamic> inputData) {
    final List<String> warnings = [];

    final double? load = double.tryParse(inputData['load']?.toString() ?? '');
    if (load != null && load > 500) {
      warnings.add(
        'Unusually high load detected (>500kN). Please verify your load calculations.',
      );
    }

    final double? depth = double.tryParse(inputData['depth']?.toString() ?? '');
    if (depth != null && depth < 150) {
      warnings.add(
        'Section depth is very shallow (<150mm). Verify if this meets deflection requirements.',
      );
    }

    return warnings;
  }
}



