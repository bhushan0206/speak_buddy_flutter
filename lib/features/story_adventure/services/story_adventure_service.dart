import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_models.dart';
import '../data/demo_story_data.dart';
import '../../../core/logging/app_logger.dart';

class StoryAdventureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize the service
  Future<void> initialize() async {
    // Service is ready to use with demo data
    AppLogger.info('Story Adventure Service initialized with demo data');
  }

  // Get story chapter from Firestore or fallback to demo data
  Future<StoryChapter?> getStoryChapter(String chapterId) async {
    try {
      // Check if Firestore is available
      if (!_isFirestoreAvailable()) {
        AppLogger.warning('Firestore not available, using demo story data');
        return _getDemoStoryChapter(chapterId);
      }

      final doc =
          await _firestore.collection('story_chapters').doc(chapterId).get();
      if (doc.exists) {
        return StoryChapter.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      AppLogger.warning(
          'Error getting story chapter from Firestore, using demo data: $e');
      return _getDemoStoryChapter(chapterId);
    }
  }

  // Get AI character from Firestore or fallback to demo data
  Future<AICharacter?> getAICharacter(String characterId) async {
    try {
      // Check if Firestore is available
      if (!_isFirestoreAvailable()) {
        AppLogger.warning(
            'Firestore not available, using demo AI character data');
        return _getDemoAICharacter(characterId);
      }

      final doc =
          await _firestore.collection('ai_characters').doc(characterId).get();
      if (doc.exists) {
        return AICharacter.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      AppLogger.warning(
          'Error getting AI character from Firestore, using demo data: $e');
      return _getDemoAICharacter(characterId);
    }
  }

  // Get or create user progress
  Future<StoryProgress> getUserProgress(String userId, String storyId) async {
    try {
      // Check if Firestore is available
      if (!_isFirestoreAvailable()) {
        AppLogger.warning('Firestore not available, using fallback progress');
        return _createFallbackProgress(userId, storyId);
      }

      final doc = await _firestore
          .collection('story_progress')
          .where('userId', isEqualTo: userId)
          .where('storyId', isEqualTo: storyId)
          .limit(1)
          .get();

      if (doc.docs.isNotEmpty) {
        return StoryProgress.fromFirestore(doc.docs.first);
      } else {
        // Create new progress
        final newProgress = _createFallbackProgress(userId, storyId);

        try {
          await _firestore
              .collection('story_progress')
              .add(newProgress.toMap());
        } catch (e) {
          AppLogger.warning(
              'Could not save to Firestore, using local progress: $e');
        }

        return newProgress;
      }
    } catch (e) {
      AppLogger.warning('Error getting user progress, using fallback: $e');
      return _createFallbackProgress(userId, storyId);
    }
  }

  // Check if Firestore is available
  bool _isFirestoreAvailable() {
    try {
      // Simple check - in production you might want more sophisticated detection
      return _firestore != null;
    } catch (e) {
      return false;
    }
  }

  // Create fallback progress when Firestore is not available
  StoryProgress _createFallbackProgress(String userId, String storyId) {
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

  // Get demo story chapter data
  StoryChapter? _getDemoStoryChapter(String chapterId) {
    final demoChapters = DemoStoryData.getDemoChapters();
    try {
      return demoChapters.firstWhere((chapter) => chapter.id == chapterId);
    } catch (e) {
      AppLogger.warning('Demo chapter not found: $chapterId');
      return demoChapters.isNotEmpty ? demoChapters.first : null;
    }
  }

  // Get demo AI character data
  AICharacter? _getDemoAICharacter(String characterId) {
    final demoCharacters = DemoStoryData.getDemoCharacters();
    try {
      return demoCharacters
          .firstWhere((character) => character.id == characterId);
    } catch (e) {
      AppLogger.warning('Demo character not found: $characterId');
      return demoCharacters.isNotEmpty ? demoCharacters.first : null;
    }
  }

  // Update user progress
  Future<void> updateUserProgress(StoryProgress progress) async {
    try {
      // Check if Firestore is available
      if (!_isFirestoreAvailable()) {
        AppLogger.warning('Firestore not available, skipping progress update');
        return;
      }

      final docRef = await _firestore
          .collection('story_progress')
          .where('userId', isEqualTo: progress.userId)
          .where('storyId', isEqualTo: progress.storyId)
          .limit(1)
          .get();

      if (docRef.docs.isNotEmpty) {
        await docRef.docs.first.reference.update(progress.toMap());
      }
    } catch (e) {
      AppLogger.error('Error updating user progress: $e');
      // Don't throw - just log the error to prevent app crashes
    }
  }

  // Simulate voice recognition (in a real app, you'd integrate with speech-to-text)
  Future<VoiceRecognitionResult> processVoiceInput(
    String audioFile,
    List<String> targetWords,
  ) async {
    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, return a simulated result
      // In production, this would use actual speech recognition
      final recognizedText = _simulateVoiceRecognition(targetWords);
      final wordAccuracy = _calculateWordAccuracy(recognizedText, targetWords);
      final isSuccess = wordAccuracy.values.any((accuracy) => accuracy > 0.7);

      return VoiceRecognitionResult(
        recognizedText: recognizedText,
        confidence: 0.85,
        targetWords: targetWords,
        wordAccuracy: wordAccuracy,
        isSuccess: isSuccess,
      );
    } catch (e) {
      AppLogger.error('Error processing voice input: $e');
      return VoiceRecognitionResult(
        recognizedText: '',
        confidence: 0.0,
        targetWords: targetWords,
        wordAccuracy: {},
        isSuccess: false,
      );
    }
  }

  // Simulate voice recognition for demo
  String _simulateVoiceRecognition(List<String> targetWords) {
    if (targetWords.isEmpty) return 'Hello';

    // Randomly select some target words and add some noise
    final random = DateTime.now().millisecondsSinceEpoch % targetWords.length;
    final selectedWord = targetWords[random];

    // Simulate common speech recognition errors
    final variations = {
      'hello': ['hello', 'helo', 'hallo', 'hi'],
      'world': ['world', 'word', 'wold', 'woild'],
      'friend': ['friend', 'frend', 'frien', 'frend'],
      'magic': ['magic', 'majic', 'magik', 'magick'],
    };

    final word = selectedWord.toLowerCase();
    if (variations.containsKey(word)) {
      final variationList = variations[word]!;
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % variationList.length;
      return variationList[randomIndex];
    }

    return selectedWord;
  }

  // Calculate word accuracy
  Map<String, double> _calculateWordAccuracy(
    String recognizedText,
    List<String> targetWords,
  ) {
    final accuracy = <String, double>{};

    for (final targetWord in targetWords) {
      final lowerTarget = targetWord.toLowerCase();
      final lowerRecognized = recognizedText.toLowerCase();

      if (lowerRecognized.contains(lowerTarget)) {
        accuracy[targetWord] = 1.0;
      } else {
        // Calculate similarity score
        final similarity = _calculateSimilarity(lowerTarget, lowerRecognized);
        accuracy[targetWord] = similarity;
      }
    }

    return accuracy;
  }

  // Calculate string similarity (Levenshtein distance)
  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty) return s2.isEmpty ? 1.0 : 0.0;
    if (s2.isEmpty) return 0.0;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return maxLength == 0
        ? 1.0
        : (maxLength - matrix[s1.length][s2.length]) / maxLength;
  }

  // Get available stories
  Future<List<Map<String, dynamic>>> getAvailableStories() async {
    try {
      if (!_isFirestoreAvailable()) {
        AppLogger.warning('Firestore not available, using demo stories');
        return DemoStoryData.getAvailableStories();
      }

      final querySnapshot = await _firestore.collection('stories').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'difficulty': data['difficulty'] ?? 1,
          'characterId': data['characterId'] ?? '',
          'thumbnailUrl': data['thumbnailUrl'] ?? '',
        };
      }).toList();
    } catch (e) {
      AppLogger.warning('Error getting available stories, using demo data: $e');
      return DemoStoryData.getAvailableStories();
    }
  }

  // Get AI character response (simplified for demo)
  Future<AIResponse> getAICharacterResponse({
    required String characterId,
    required String userMessage,
    required String context,
    required List<String> targetWords,
    required Map<String, dynamic> storyContext,
  }) async {
    // For demo purposes, return a predefined response
    // In production, this would integrate with OpenAI or similar service
    final responses = {
      'wizard':
          'Great job speaking! Let\'s continue our magical adventure together. What would you like to do next?',
      'robot':
          'Excellent communication! Your words are getting clearer. Shall we explore more of our robot world?',
      'fairy':
          'Wonderful speaking! Your voice is like music. Where shall we fly to next in our fairy tale?',
    };

    final characterResponses = {
      'wizard': ['Cast a spell', 'Read a book', 'Make potions'],
      'robot': ['Fix machines', 'Learn codes', 'Build things'],
      'fairy': ['Fly to flowers', 'Help animals', 'Make wishes'],
    };

    return AIResponse(
      characterId: characterId,
      message:
          responses[characterId] ?? 'Great job! Let\'s continue our adventure!',
      emotion: 'happy',
      suggestedResponses:
          characterResponses[characterId] ?? ['Continue', 'Explore', 'Learn'],
      context: {'targetWords': targetWords},
    );
  }
}
