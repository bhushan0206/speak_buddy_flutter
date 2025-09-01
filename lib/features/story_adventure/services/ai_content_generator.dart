import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../core/logging/app_logger.dart';
import '../../../core/services/ai_service.dart';
import '../data/demo_story_data.dart';
import '../models/story_models.dart';

class AIContentGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AIService _aiService; // Use the abstract service

  AIContentGenerator() : _aiService = AIServiceFactory.createService() {
    print('🔧 AIContentGenerator: Constructor called');
    try {
      print('🔧 AIContentGenerator: Creating AI service...');
      // The service is already created in the initializer list
      print('🔧 AIContentGenerator: AI service created successfully');
    } catch (e) {
      print('❌ AIContentGenerator: Error creating AI service: $e');
      rethrow;
    }
  }

  // Test AI service connection
  Future<bool> testAIConnection() async {
    try {
      print('🔍 DEBUG: Testing AI connection...');
      if (_aiService is GeminiAIService) {
        print('🔍 DEBUG: Using Gemini AI Service');
        final result = await (_aiService as GeminiAIService).testConnection();
        print('🔍 DEBUG: AI connection test result: $result');
        return result;
      }
      print('🔍 DEBUG: Using other AI service, assuming connection is good');
      return true; // For other services, assume connection is good
    } catch (e) {
      print('❌ DEBUG: AI connection test failed: $e');
      AppLogger.error('❌ AI connection test failed: $e');
      return false;
    }
  }

  // Generate a new story chapter based on user progress and preferences
  Future<StoryChapter> generateStoryChapter({
    required String userId,
    required String storyId,
    required int chapterNumber,
    required List<String> previousChapters,
    required Map<String, double> userWordAccuracy,
    required String characterId,
  }) async {
    try {
      print('🔍 DEBUG: Starting story chapter generation...');

      // Test AI connection first
      print('🔍 DEBUG: Testing AI connection before generation...');
      final isConnected = await testAIConnection();
      print('🔍 DEBUG: AI connection test result: $isConnected');

      if (!isConnected) {
        print('⚠️ DEBUG: AI service not connected, using fallback');
        AppLogger.warning('⚠️ AI service not connected, using fallback');
        return _createFallbackChapter(chapterNumber, characterId);
      }

      print(
        '🔍 DEBUG: AI connection successful, proceeding with generation...',
      );

      // Create the prompt for AI generation
      final prompt = _buildChapterPrompt(
        chapterNumber: chapterNumber,
        previousChapters: previousChapters,
        userWordAccuracy: userWordAccuracy,
        characterId: characterId,
      );

      print('🔍 DEBUG: Prompt created, calling AI service...');

      // Generate content using AI service
      final generatedContent = await _aiService.generateStoryChapter(prompt);

      print('🔍 DEBUG: AI content generated successfully');

      // Parse the AI response
      final chapter = _parseGeneratedChapter(
        generatedContent,
        chapterNumber: chapterNumber,
        characterId: characterId,
      );

      print('🔍 DEBUG: Chapter parsed successfully');

      // Store the generated chapter in Firestore
      await _storeGeneratedChapter(chapter, storyId);

      // Update user progress to mark this chapter as seen
      await _updateUserProgress(userId, storyId, chapter.id);

      AppLogger.info('Generated new story chapter: ${chapter.id}');
      print('✅ DEBUG: Story chapter generation completed successfully');
      return chapter;
    } catch (e) {
      print('❌ DEBUG: Error generating story chapter: $e');
      AppLogger.error('Error generating story chapter: $e');
      // Return a fallback chapter if AI generation fails
      return _createFallbackChapter(chapterNumber, characterId);
    }
  }

  // Generate a new AI character based on user preferences
  Future<AICharacter> generateAICharacter({
    required String userId,
    required String characterId,
    required List<String> userInterests,
    required int userAge,
  }) async {
    try {
      final prompt = _buildCharacterPrompt(
        characterId: characterId,
        userInterests: userInterests,
        userAge: userAge,
      );

      final generatedContent = await _aiService.generateCharacter(prompt);
      final character = _parseGeneratedCharacter(generatedContent, characterId);

      // Store the generated character
      await _storeGeneratedCharacter(character);

      // Update user character preferences
      await _updateUserCharacterPreferences(userId, characterId);

      AppLogger.info('Generated new AI character: ${character.id}');
      return character;
    } catch (e) {
      AppLogger.error('Error generating AI character: $e');
      return _createFallbackCharacter(characterId);
    }
  }

  // Get or generate content based on user progress
  Future<StoryChapter> getOrGenerateChapter({
    required String userId,
    required String storyId,
    required String chapterId,
    required String characterId,
  }) async {
    try {
      // First, check if the chapter exists in Firestore
      final existingChapter = await _getExistingChapter(chapterId);
      if (existingChapter != null) {
        // Check if user has already seen this chapter
        final hasSeen = await _hasUserSeenChapter(userId, storyId, chapterId);
        if (!hasSeen) {
          // Mark as seen and return
          await _updateUserProgress(userId, storyId, chapterId);
          return existingChapter;
        }
      }

      // If chapter doesn't exist or user has seen it, generate a new one
      final userProgress = await _getUserProgress(userId, storyId);
      final previousChapters = userProgress.completedChapters;
      final chapterNumber = previousChapters.length + 1;

      return await generateStoryChapter(
        userId: userId,
        storyId: storyId,
        chapterNumber: chapterNumber,
        previousChapters: previousChapters,
        userWordAccuracy: userProgress.wordAccuracy,
        characterId: characterId,
      );
    } catch (e) {
      AppLogger.error('Error getting or generating chapter: $e');
      rethrow;
    }
  }

  // Generate AI response for character interaction
  Future<AIResponse> generateCharacterResponse({
    required String characterId,
    required String userMessage,
    required String context,
    required List<String> targetWords,
    required Map<String, dynamic> storyContext,
    required String userId,
  }) async {
    try {
      final prompt = _buildResponsePrompt(
        characterId: characterId,
        userMessage: userMessage,
        context: context,
        targetWords: targetWords,
        storyContext: storyContext,
      );

      final generatedContent = await _aiService.generateResponse(prompt);
      final response = _parseGeneratedResponse(generatedContent, characterId);

      // Store the interaction for learning
      await _storeUserInteraction(
        userId: userId,
        characterId: characterId,
        userMessage: userMessage,
        aiResponse: response,
        context: context,
      );

      return response;
    } catch (e) {
      AppLogger.error('Error generating character response: $e');
      return _createFallbackResponse(characterId, targetWords);
    }
  }

  // Private methods for AI generation
  String _buildChapterPrompt({
    required int chapterNumber,
    required List<String> previousChapters,
    required Map<String, double> userWordAccuracy,
    required String characterId,
  }) {
    final previousContent = previousChapters.isNotEmpty
        ? 'Previous chapters covered: ${previousChapters.join(', ')}'
        : 'This is the beginning of the story';

    final wordFocus = userWordAccuracy.isNotEmpty
        ? 'Focus on words the user needs practice with: ${userWordAccuracy.keys.join(', ')}'
        : 'Introduce new vocabulary words suitable for children';

    return '''
Create a story chapter for children aged 2-12 with speech therapy focus.

Chapter Number: $chapterNumber
Character: $characterId
$previousContent
$wordFocus

Requirements:
- Title: Engaging and descriptive
- Description: Brief summary of what happens
- Content: 3-4 paragraphs of story content
- Target Words: 4-6 words for speech practice
- Choices: 2 story choices that lead to different outcomes
- Difficulty: Appropriate for chapter $chapterNumber
- Make it fun, educational, and speech-focused

Format the response as JSON:
{
  "title": "Chapter Title",
  "description": "Brief description",
  "content": "Story content...",
  "targetWords": ["word1", "word2", "word3", "word4"],
  "choices": [
    {
      "id": "choice_1",
      "text": "First choice description",
      "nextChapterId": "chapter_${chapterNumber + 1}",
      "requiredWords": ["word1"],
      "response": "Response to first choice"
    },
    {
      "id": "choice_2", 
      "text": "Second choice description",
      "nextChapterId": "chapter_${chapterNumber + 1}",
      "requiredWords": ["word2"],
      "response": "Response to second choice"
    }
  ],
  "difficulty": $chapterNumber,
  "characterId": "$characterId"
}
''';
  }

  String _buildCharacterPrompt({
    required String characterId,
    required List<String> userInterests,
    required int userAge,
  }) {
    return '''
Create an AI character for a speech therapy app for children aged $userAge.

Character ID: $characterId
User Interests: ${userInterests.join(', ')}

Requirements:
- Name: Fun and memorable
- Description: Brief character description
- Personality: Engaging and supportive for speech development
- Avatar URL: Suggest a character type (wizard, robot, fairy, etc.)

Format as JSON:
{
  "name": "Character Name",
  "description": "Character description...",
  "personality": "Personality traits...",
  "avatarUrl": "character_type"
}
''';
  }

  String _buildResponsePrompt({
    required String characterId,
    required String userMessage,
    required String context,
    required List<String> targetWords,
    required Map<String, dynamic> storyContext,
  }) {
    return '''
You are the character $characterId in a speech therapy story for children.

User Message: "$userMessage"
Context: $context
Target Words to Practice: ${targetWords.join(', ')}
Story Context: ${storyContext.toString()}

Respond as your character would, being:
- Encouraging and supportive
- Focused on speech development
- Fun and engaging for children
- Suggesting activities related to target words

Keep response under 100 words and include 2-3 suggested activities.
''';
  }

  // Helper method to clean markdown formatting from AI responses
  String _cleanMarkdownResponse(String response) {
    // Remove markdown code blocks
    String cleaned = response.replaceAll(RegExp(r'```json\s*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'```\s*$'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*```\s*'), '');

    // Remove any leading/trailing whitespace
    cleaned = cleaned.trim();

    return cleaned;
  }

  // Parse AI-generated content
  StoryChapter _parseGeneratedChapter(
    String aiResponse, {
    required int chapterNumber,
    required String characterId,
  }) {
    try {
      // Clean the response from markdown formatting
      final cleanedResponse = _cleanMarkdownResponse(aiResponse);
      print(
        '🔍 DEBUG: Cleaned AI response: ${cleanedResponse.substring(0, 100)}...',
      );

      final data = jsonDecode(cleanedResponse);

      return StoryChapter(
        id: 'chapter_$chapterNumber',
        title: data['title'] ?? 'Chapter $chapterNumber',
        description: data['description'] ?? '',
        content: data['content'] ?? '',
        choices:
            (data['choices'] as List<dynamic>?)
                ?.map((choice) => StoryChoice.fromMap(choice))
                .toList() ??
            [],
        targetWords: List<String>.from(data['targetWords'] ?? []),
        difficulty: data['difficulty'] ?? chapterNumber,
        characterId: data['characterId'] ?? characterId,
        metadata: {
          'generatedBy': 'AI',
          'generatedAt': DateTime.now().toIso8601String(),
          'chapterNumber': chapterNumber,
        },
      );
    } catch (e) {
      AppLogger.error('Error parsing generated chapter: $e');
      print('❌ DEBUG: Failed to parse AI response: $aiResponse');
      return _createFallbackChapter(chapterNumber, characterId);
    }
  }

  AICharacter _parseGeneratedCharacter(String aiResponse, String characterId) {
    try {
      // Clean the response from markdown formatting
      final cleanedResponse = _cleanMarkdownResponse(aiResponse);
      final data = jsonDecode(cleanedResponse);

      return AICharacter(
        id: characterId,
        name: data['name'] ?? 'AI Character',
        description: data['description'] ?? '',
        personality: data['personality'] ?? '',
        avatarUrl: data['avatarUrl'] ?? 'default',
        metadata: {
          'generatedBy': 'AI',
          'generatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      AppLogger.error('Error parsing generated character: $e');
      return _createFallbackCharacter(characterId);
    }
  }

  AIResponse _parseGeneratedResponse(String aiResponse, String characterId) {
    return AIResponse(
      characterId: characterId,
      message: aiResponse,
      emotion: 'happy',
      suggestedResponses: ['Continue', 'Practice Words', 'Tell Story'],
      context: {'generatedBy': 'AI'},
    );
  }

  // Database operations
  Future<void> _storeGeneratedChapter(
    StoryChapter chapter,
    String storyId,
  ) async {
    await _firestore
        .collection('story_chapters')
        .doc(chapter.id)
        .set(chapter.toMap());
  }

  Future<void> _storeGeneratedCharacter(AICharacter character) async {
    await _firestore
        .collection('ai_characters')
        .doc(character.id)
        .set(character.toMap());
  }

  Future<void> _storeUserInteraction({
    required String userId,
    required String characterId,
    required String userMessage,
    required AIResponse aiResponse,
    required String context,
  }) async {
    await _firestore.collection('user_interactions').add({
      'userId': userId,
      'characterId': characterId,
      'userMessage': userMessage,
      'aiResponse': aiResponse.toMap(),
      'context': context,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateUserProgress(
    String userId,
    String storyId,
    String chapterId,
  ) async {
    try {
      final docRef = _firestore.collection('story_progress').doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        final currentData = doc.data();
        final completedChapters = List<String>.from(
          currentData?['completedChapters'] ?? [],
        );

        if (!completedChapters.contains(chapterId)) {
          completedChapters.add(chapterId);
          await docRef.update({
            'completedChapters': completedChapters,
            'lastPlayed': FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Create new progress document
        await docRef.set({
          'userId': userId,
          'storyId': storyId,
          'completedChapters': [chapterId],
          'lastPlayed': FieldValue.serverTimestamp(),
          'currentChapterId': 'chapter_1',
          'wordAccuracy': {},
          'choices': {},
          'totalPlayTime': 0,
          'achievements': {},
        });
      }
    } catch (e) {
      AppLogger.error('Error updating user progress: $e');
    }
  }

  Future<void> _updateUserCharacterPreferences(
    String userId,
    String characterId,
  ) async {
    await _firestore.collection('user_preferences').doc(userId).set({
      'favoriteCharacters': FieldValue.arrayUnion([characterId]),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Helper methods
  Future<StoryChapter?> _getExistingChapter(String chapterId) async {
    final doc = await _firestore
        .collection('story_chapters')
        .doc(chapterId)
        .get();
    if (doc.exists) {
      return StoryChapter.fromFirestore(doc);
    }
    return null;
  }

  Future<bool> _hasUserSeenChapter(
    String userId,
    String storyId,
    String chapterId,
  ) async {
    try {
      final doc = await _firestore
          .collection('story_progress')
          .doc(userId)
          .get();

      if (doc.exists) {
        final completedChapters = List<String>.from(
          doc.data()?['completedChapters'] ?? [],
        );
        return completedChapters.contains(chapterId);
      }
      return false;
    } catch (e) {
      AppLogger.error('Error checking if user has seen chapter: $e');
      return false;
    }
  }

  Future<StoryProgress> _getUserProgress(String userId, String storyId) async {
    try {
      final doc = await _firestore
          .collection('story_progress')
          .doc(userId)
          .get();

      if (doc.exists) {
        return StoryProgress.fromFirestore(doc);
      }

      // Return empty progress if none exists
      return StoryProgress(
        userId: userId,
        storyId: storyId,
        currentChapterId: 'chapter_1',
        completedChapters: [],
        wordAccuracy: {},
        choices: {},
        lastPlayed: DateTime.now(),
        totalPlayTime: 0,
        achievements: {},
      );
    } catch (e) {
      AppLogger.error('Error getting user progress: $e');
      // Return empty progress if error occurs
      return StoryProgress(
        userId: userId,
        storyId: storyId,
        currentChapterId: 'chapter_1',
        completedChapters: [],
        wordAccuracy: {},
        choices: {},
        lastPlayed: DateTime.now(),
        totalPlayTime: 0,
        achievements: {},
      );
    }
  }

  // Fallback content creation
  StoryChapter _createFallbackChapter(int chapterNumber, String characterId) {
    return StoryChapter(
      id: 'chapter_$chapterNumber',
      title: 'Adventure Chapter $chapterNumber',
      description: 'An exciting chapter in your speech journey!',
      content: 'This is a fallback chapter. Please try again later.',
      choices: [
        StoryChoice(
          id: 'choice_1',
          text: 'Continue the adventure',
          nextChapterId: 'chapter_${chapterNumber + 1}',
          requiredWords: ['continue'],
          response: 'Great choice! Let\'s keep going!',
        ),
      ],
      targetWords: ['continue', 'adventure', 'story', 'fun'],
      difficulty: chapterNumber,
      characterId: characterId,
      metadata: {'fallback': true},
    );
  }

  AICharacter _createFallbackCharacter(String characterId) {
    return AICharacter(
      id: characterId,
      name: 'Friendly Helper',
      description: 'A helpful character for your speech journey',
      personality: 'Kind and encouraging',
      avatarUrl: 'default',
      metadata: {'fallback': true},
    );
  }

  AIResponse _createFallbackResponse(
    String characterId,
    List<String> targetWords,
  ) {
    return AIResponse(
      characterId: characterId,
      message: 'Great job! Let\'s practice some words together.',
      emotion: 'happy',
      suggestedResponses: ['Practice Words', 'Continue Story', 'Play Game'],
      context: {'fallback': true, 'targetWords': targetWords},
    );
  }
}
