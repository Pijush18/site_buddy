/// Encapsulates the classification intent and any extracted prefill data 
/// from a user's natural language query.
/// ----------------------------------------------
library;

import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/prefill_data.dart';

class AiIntentResult {
  final AiIntent intent;
  final ToolPrefillData? parameters;

  const AiIntentResult({
    required this.intent,
    this.parameters,
  });

  @override
  String toString() => 'AiIntentResult(intent: $intent, params: $parameters)';
}



