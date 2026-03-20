import 'package:site_buddy/shared/domain/models/ai_intent.dart';

/// ABSTRACT CLASS: AssistantRepository
/// PURPOSE: Defines the contract for processing user assistant queries.
abstract class AssistantRepository {
  /// METHOD: query
  /// PURPOSE: Sends a user prompt to the AI and returns the text response and detected intent.
  Future<({String text, AiIntent intent})?> query(String prompt);
}



