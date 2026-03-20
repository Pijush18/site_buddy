/// FILE HEADER
/// ----------------------------------------------
/// File: ai_config.dart
/// Feature: core
/// Layer: config
///
/// PURPOSE:
/// Global configuration variables specifically targeting AI/LLM interfaces.
///
/// RESPONSIBILITIES:
/// - Provides a safe namespace for API endpoints and placeholder keys.
///
/// DEPENDENCIES:
/// - None
///
/// FUTURE IMPROVEMENTS:
/// - Connect to `flutter_dotenv` to read from local .env files safely.
/// ----------------------------------------------
library;


/// CLASS: AiConfig
/// PURPOSE: Central environment variables for AI communication.
class AiConfig {
  /// The placeholder or staging endpoint for the LLM proxy.
  static const String endpoint =
      'https://api.openai.placeholder/v1/chat/completions';

  /// Placeholder API Key. Do not commit real keys.
  static const String apiKey = 'sk-placeholder-api-key-do-not-commit';

  /// Chosen model engine for extraction accuracy.
  static const String model = 'gpt-3.5-turbo';
}



