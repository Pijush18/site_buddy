/// Intermediate model holding the extracted payload from the NLP parser
/// before it is routed to the processing engines.
/// ----------------------------------------------
library;

import 'package:site_buddy/shared/domain/models/ai_intent.dart';
import 'package:site_buddy/shared/domain/models/ai_query.dart';
import 'package:site_buddy/core/models/prefill_data.dart';

class ParsedAiInput {
  final AiIntent intent;
  final String rawQuery;

  /// Holds conversion/calculation parsed parameters from the legacy parser.
  final AiQuery? legacyQuery;

  /// Holds prefill parameters for specialized quantity tools.
  final ToolPrefillData? prefillData;

  const ParsedAiInput({
    required this.intent,
    required this.rawQuery,
    this.legacyQuery,
    this.prefillData,
  });
}




