import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/backend/backend_client.dart';
import 'package:site_buddy/features/ai/domain/repositories/assistant_repository.dart';
import 'package:site_buddy/shared/domain/models/ai_intent.dart';

/// PROVIDER: assistantRepositoryProvider
final assistantRepositoryProvider = Provider<AssistantRepository>((ref) {
  final backendClient = ref.watch(backendClientProvider);
  return AssistantRepositoryImpl(backendClient);
});

/// CLASS: AssistantRepositoryImpl
/// PURPOSE: Concrete implementation of AssistantRepository that communicates with the backend.
class AssistantRepositoryImpl implements AssistantRepository {
  final BackendClient _backendClient;

  AssistantRepositoryImpl(this._backendClient);

  @override
  Future<({String text, AiIntent intent})?> query(String prompt) async {
    try {
      final result = await _backendClient.queryAssistant(prompt);
      
      if (result.containsKey('text') && result.containsKey('intent')) {
        return (
          text: result['text'] as String,
          intent: _mapIntent(result['intent'] as String),
        );
      }
    } catch (_) {
      // Return null to allow fallback to local parser
      return null;
    }
    return null;
  }

  AiIntent _mapIntent(String intentStr) {
    return AiIntent.values.firstWhere(
      (e) => e.name == intentStr,
      orElse: () => AiIntent.unknown,
    );
  }
}



