import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../logging/app_logger.dart';

// Abstract interface for AI services
abstract class AIService {
  Future<String> generateContent(String prompt, String systemPrompt);
  Future<String> generateStoryChapter(String prompt);
  Future<String> generateCharacter(String prompt);
  Future<String> generateResponse(String prompt);
}

// Gemini AI implementation
class GeminiAIService implements AIService {
  late final GenerativeModel _model;

  GeminiAIService() {
    print('🔧 GeminiAIService: Constructor called');
    final apiKey = AppConfig.geminiApiKey;
    print('🔧 GeminiAIService: API Key length: ${apiKey.length}');
    if (apiKey.isEmpty) {
      print('❌ GeminiAIService: API Key is empty!');
      throw Exception('Gemini API key not configured');
    }

    print('🔧 GeminiAIService: Creating GenerativeModel...');
    AppLogger.info('🤖 Initializing Gemini AI Service');
    AppLogger.info('🔑 Gemini API Key length: ${apiKey.length}');
    AppLogger.info(
      '🔑 Gemini API Key starts with: ${apiKey.substring(0, 10)}...',
    );

    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
      );
      print('🔧 GeminiAIService: GenerativeModel created successfully');
    } catch (e) {
      print('❌ GeminiAIService: Error creating GenerativeModel: $e');
      rethrow;
    }
  }

  @override
  Future<String> generateContent(String prompt, String systemPrompt) async {
    try {
      AppLogger.info('🤖 Gemini: Generating content');
      AppLogger.info('🤖 Gemini: Prompt length: ${prompt.length}');
      AppLogger.info('🤖 Gemini: System prompt length: ${systemPrompt.length}');

      final fullPrompt = '$systemPrompt\n\n$prompt';

      final response = await _model.generateContent([Content.text(fullPrompt)]);
      final content = response.text ?? 'No response generated';

      AppLogger.info('🤖 Gemini: Response received');
      AppLogger.info('🤖 Gemini: Response length: ${content.length}');

      return content;
    } catch (e) {
      AppLogger.error('❌ Gemini AI Error: $e');
      throw Exception('Gemini AI request failed: $e');
    }
  }

  // Test method to verify API key is working
  Future<bool> testConnection() async {
    try {
      AppLogger.info('🧪 Testing Gemini API connection...');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash', // Use a stable model for testing
        apiKey: AppConfig.geminiApiKey,
      );

      final response = await model.generateContent([
        Content.text('Say "Hello, Gemini is working!" in exactly those words.'),
      ]);

      final content = response.text ?? '';
      AppLogger.info('🧪 Gemini test response: $content');

      return content.contains('Hello, Gemini is working!');
    } catch (e) {
      AppLogger.error('🧪 Gemini connection test failed: $e');
      return false;
    }
  }

  @override
  Future<String> generateStoryChapter(String prompt) async {
    const systemPrompt = '''
You are a creative storyteller and speech therapy expert. Create engaging, educational content for children aged 2-12. Focus on speech development, vocabulary building, and fun learning experiences.

You must generate content in JSON format.

Generate a JSON response with the following structure:
{
  "title": "Chapter Title",
  "description": "Brief description of the chapter",
  "content": "The story content...",
  "targetWords": ["word1", "word2", "word3", "word4"],
  "choices": [
    {
      "id": "choice_1",
      "text": "First choice description",
      "nextChapterId": "chapter_2",
      "requiredWords": ["word1"],
      "response": "Response to first choice"
    },
    {
      "id": "choice_2",
      "text": "Second choice description", 
      "nextChapterId": "chapter_2",
      "requiredWords": ["word2"],
      "response": "Response to second choice"
    }
  ],
  "difficulty": 1,
  "characterId": "character_id"
}
''';

    return generateContent(prompt, systemPrompt);
  }

  @override
  Future<String> generateCharacter(String prompt) async {
    const systemPrompt = '''
You are a creative character designer for a speech therapy app for children aged 2-12.

Generate a JSON response with the following structure:
{
  "name": "Character Name",
  "description": "Character description",
  "personality": "Character personality traits",
  "avatarUrl": "https://example.com/avatar.jpg",
  "metadata": {
    "userInterests": ["adventure", "learning", "fun"],
    "age": 8,
    "difficulty": "medium"
  }
}
''';

    return generateContent(prompt, systemPrompt);
  }

  @override
  Future<String> generateResponse(String prompt) async {
    const systemPrompt = '''
You are a character in a speech therapy story for children.

Generate a JSON response with the following structure:
{
  "message": "Your character's response to the user",
  "emotion": "happy/sad/excited/calm",
  "suggestedResponses": ["Response 1", "Response 2"],
  "context": {"interactionType": "conversation"}
}

Respond as your character would, being:
- Engaging and supportive for speech development
- Age-appropriate for children 2-12
- Encouraging and positive
- Focused on speech practice and learning
''';

    return generateContent(prompt, systemPrompt);
  }
}

// OpenAI implementation (kept for future use)
class OpenAIAService implements AIService {
  final String _apiKey;

  OpenAIAService() : _apiKey = AppConfig.openaiApiKey {
    if (_apiKey.isEmpty) {
      throw Exception('OpenAI API key not configured');
    }
    AppLogger.info('🤖 Initializing OpenAI AI Service');
  }

  @override
  Future<String> generateContent(String prompt, String systemPrompt) async {
    try {
      AppLogger.info('🤖 OpenAI: Generating content');

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'No response content';
      } else {
        throw Exception('OpenAI API request failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('❌ OpenAI AI Error: $e');
      throw Exception('OpenAI AI request failed: $e');
    }
  }

  @override
  Future<String> generateStoryChapter(String prompt) async {
    const systemPrompt = '''
You are a creative storyteller and speech therapy expert. Create engaging, educational content for children aged 2-12. Focus on speech development, vocabulary building, and fun learning experiences.

You must generate content in JSON format.
''';

    return generateContent(prompt, systemPrompt);
  }

  @override
  Future<String> generateCharacter(String prompt) async {
    const systemPrompt = '''
You are a creative character designer for a speech therapy app for children aged 2-12.
''';

    return generateContent(prompt, systemPrompt);
  }

  @override
  Future<String> generateResponse(String prompt) async {
    const systemPrompt = '''
You are a character in a speech therapy story for children.
''';

    return generateContent(prompt, systemPrompt);
  }
}

// AI Service Factory
class AIServiceFactory {
  static AIService createService() {
    final provider = AppConfig.aiProvider.toLowerCase();
    print('🤖 FACTORY: Creating AI service for provider: $provider');
    AppLogger.info('🤖 Creating AI service for provider: $provider');

    switch (provider) {
      case 'gemini':
        print('🤖 FACTORY: Creating Gemini AI Service');
        return GeminiAIService();
      case 'openai':
        print('🤖 FACTORY: Creating OpenAI AI Service');
        return OpenAIAService();
      default:
        print(
          '⚠️ FACTORY: Unknown AI provider: $provider, defaulting to Gemini',
        );
        AppLogger.warning(
          '⚠️ Unknown AI provider: $provider, defaulting to Gemini',
        );
        return GeminiAIService();
    }
  }
}
