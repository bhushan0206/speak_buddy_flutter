import 'package:flutter/foundation.dart';
import '../models/story_models.dart';
import '../services/story_adventure_service.dart';
import '../../../core/logging/app_logger.dart';

class StoryAdventureProvider extends ChangeNotifier {
  final StoryAdventureService _service = StoryAdventureService();

  // State variables
  StoryChapter? _currentChapter;
  AICharacter? _currentCharacter;
  StoryProgress? _userProgress;
  AIResponse? _lastAIResponse;
  VoiceRecognitionResult? _lastVoiceResult;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  StoryChapter? get currentChapter => _currentChapter;
  AICharacter? get currentCharacter => _currentCharacter;
  StoryProgress? get userProgress => _userProgress;
  AIResponse? get lastAIResponse => _lastAIResponse;
  VoiceRecognitionResult? get lastVoiceResult => _lastVoiceResult;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Initialize the provider
  Future<void> initialize() async {
    try {
      await _service.initialize();
    } catch (e) {
      AppLogger.error('Error initializing Story Adventure Provider: $e');
      _errorMessage = 'Failed to initialize story adventure';
      notifyListeners();
    }
  }

  // Start a story adventure
  Future<void> startStoryAdventure(String storyId, String userId) async {
    try {
      _setLoading(true);
      _errorMessage = '';

      // Get user progress
      _userProgress = await _service.getUserProgress(userId, storyId);

      // Get the first chapter
      _currentChapter = await _service.getStoryChapter('chapter_1');
      if (_currentChapter == null) {
        throw Exception('Could not load story chapter');
      }

      // Get the AI character for this chapter
      _currentCharacter = await _service.getAICharacter(_currentChapter!.characterId);
      if (_currentCharacter == null) {
        throw Exception('Could not load AI character');
      }

      AppLogger.info('Story adventure started successfully');
    } catch (e) {
      AppLogger.error('Error starting story adventure: $e');
      _errorMessage = 'Failed to start story adventure: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Make a story choice
  Future<void> makeStoryChoice(StoryChoice choice) async {
    try {
      _setLoading(true);

      // Update user progress
      if (_userProgress != null) {
        final updatedProgress = _userProgress!.copyWith(
          currentChapterId: choice.nextChapterId,
          choices: {
            ..._userProgress!.choices,
            _currentChapter!.id: choice.id,
          },
          lastPlayed: DateTime.now(),
        );

        _userProgress = updatedProgress;
        await _service.updateUserProgress(updatedProgress);
      }

      // Load the next chapter
      _currentChapter = await _service.getStoryChapter(choice.nextChapterId);
      if (_currentChapter == null) {
        throw Exception('Could not load next chapter');
      }

      // Update AI character if needed
      if (_currentChapter!.characterId != _currentCharacter?.id) {
        _currentCharacter = await _service.getAICharacter(_currentChapter!.characterId);
      }

      notifyListeners();
    } catch (e) {
      AppLogger.error('Error making story choice: $e');
      _errorMessage = 'Failed to make choice: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Get AI response
  Future<void> getAIResponse(String message) async {
    try {
      _setLoading(true);

      if (_currentChapter == null || _currentCharacter == null) {
        throw Exception('No active story or character');
      }

      _lastAIResponse = await _service.getAICharacterResponse(
        characterId: _currentCharacter!.id,
        userMessage: message,
        context: 'story_interaction',
        targetWords: _currentChapter!.targetWords,
        storyContext: {
          'chapterId': _currentChapter!.id,
          'chapterTitle': _currentChapter!.title,
          'targetWords': _currentChapter!.targetWords,
        },
      );

      notifyListeners();
    } catch (e) {
      AppLogger.error('Error getting AI response: $e');
      _errorMessage = 'Failed to get AI response: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Process voice input
  Future<void> processVoiceInput(String audioFile) async {
    try {
      _setLoading(true);

      if (_currentChapter == null) {
        throw Exception('No active story');
      }

      _lastVoiceResult = await _service.processVoiceInput(
        audioFile,
        _currentChapter!.targetWords,
      );

      // Update word accuracy in progress
      if (_userProgress != null && _lastVoiceResult != null) {
        final updatedProgress = _userProgress!.copyWith(
          wordAccuracy: {
            ..._userProgress!.wordAccuracy,
            ..._lastVoiceResult!.wordAccuracy,
          },
        );

        _userProgress = updatedProgress;
        await _service.updateUserProgress(updatedProgress);
      }

      notifyListeners();
    } catch (e) {
      AppLogger.error('Error processing voice input: $e');
      _errorMessage = 'Failed to process voice input: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Reset story progress
  Future<void> resetStoryProgress() async {
    try {
      _setLoading(true);

      if (_userProgress != null) {
        final resetProgress = _userProgress!.copyWith(
          currentChapterId: 'chapter_1',
          completedChapters: [],
          wordAccuracy: {},
          choices: {},
          lastPlayed: DateTime.now(),
          totalPlayTime: 0,
          achievements: {},
        );

        _userProgress = resetProgress;
        await _service.updateUserProgress(resetProgress);
      }

      // Reload first chapter
      _currentChapter = await _service.getStoryChapter('chapter_1');
      if (_currentChapter != null) {
        _currentCharacter = await _service.getAICharacter(_currentChapter!.characterId);
      }

      _lastAIResponse = null;
      _lastVoiceResult = null;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      AppLogger.error('Error resetting story progress: $e');
      _errorMessage = 'Failed to reset progress: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Get story statistics
  Map<String, dynamic> getStoryStatistics() {
    if (_userProgress == null) return {};

    final totalChapters = _userProgress!.completedChapters.length;
    final totalWords = _userProgress!.wordAccuracy.length;
    final averageAccuracy = totalWords > 0
        ? (_userProgress!.wordAccuracy.values.reduce((a, b) => a + b) / totalWords * 100).round()
        : 0;

    return {
      'totalChapters': totalChapters,
      'totalWords': totalWords,
      'averageAccuracy': averageAccuracy,
      'totalPlayTime': _userProgress!.totalPlayTime,
    };
  }

  // Check achievements
  List<String> checkAchievements() {
    if (_userProgress == null) return [];

    final achievements = <String>[];
    final wordAccuracy = _userProgress!.wordAccuracy;
    final completedChapters = _userProgress!.completedChapters;

    // First word achievement
    if (wordAccuracy.isNotEmpty) {
      achievements.add('🎯 First Word Master');
    }

    // Perfect pronunciation achievement
    if (wordAccuracy.values.any((accuracy) => accuracy >= 0.9)) {
      achievements.add('🌟 Perfect Pronunciation');
    }

    // Chapter completion achievements
    if (completedChapters.isNotEmpty) {
      achievements.add('📚 Story Explorer');
    }
    if (completedChapters.length >= 3) {
      achievements.add('🏆 Story Champion');
    }

    // Word variety achievement
    if (wordAccuracy.length >= 5) {
      achievements.add('📖 Vocabulary Builder');
    }

    return achievements;
  }

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
