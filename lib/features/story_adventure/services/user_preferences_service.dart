import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_preferences.dart';
import '../../../core/logging/app_logger.dart';

class UserPreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user preferences or create default ones
  Future<UserPreferences> getUserPreferences(String userId) async {
    try {
      final doc = await _firestore
          .collection('user_preferences')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserPreferences.fromFirestore(doc);
      } else {
        // Create default preferences for new user
        final defaultPreferences = UserPreferences.defaultFor(userId);
        await _firestore
            .collection('user_preferences')
            .doc(userId)
            .set(defaultPreferences.toMap());

        AppLogger.info('Created default preferences for user: $userId');
        return defaultPreferences;
      }
    } catch (e) {
      AppLogger.error('Error getting user preferences: $e');
      // Return default preferences if database access fails
      return UserPreferences.defaultFor(userId);
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      await _firestore
          .collection('user_preferences')
          .doc(preferences.userId)
          .set(preferences.toMap());

      AppLogger.info('Updated preferences for user: ${preferences.userId}');
    } catch (e) {
      AppLogger.error('Error updating user preferences: $e');
      rethrow;
    }
  }

  // Update specific preference fields
  Future<void> updatePreferenceField(
    String userId,
    String field,
    dynamic value,
  ) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        field: value,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Updated $field for user: $userId');
    } catch (e) {
      AppLogger.error('Error updating preference field: $e');
      rethrow;
    }
  }

  // Add a favorite character
  Future<void> addFavoriteCharacter(String userId, String characterId) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'favoriteCharacters': FieldValue.arrayUnion([characterId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Added favorite character $characterId for user: $userId');
    } catch (e) {
      AppLogger.error('Error adding favorite character: $e');
      rethrow;
    }
  }

  // Remove a favorite character
  Future<void> removeFavoriteCharacter(
    String userId,
    String characterId,
  ) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'favoriteCharacters': FieldValue.arrayRemove([characterId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info(
        'Removed favorite character $characterId for user: $userId',
      );
    } catch (e) {
      AppLogger.error('Error removing favorite character: $e');
      rethrow;
    }
  }

  // Add an interest
  Future<void> addInterest(String userId, String interest) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'interests': FieldValue.arrayUnion([interest]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Added interest $interest for user: $userId');
    } catch (e) {
      AppLogger.error('Error adding interest: $e');
      rethrow;
    }
  }

  // Update user age
  Future<void> updateUserAge(String userId, int age) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'age': age,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Updated age to $age for user: $userId');
    } catch (e) {
      AppLogger.error('Error updating user age: $e');
      rethrow;
    }
  }

  // Update preferred difficulty
  Future<void> updatePreferredDifficulty(
    String userId,
    String difficulty,
  ) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'preferredDifficulty': difficulty,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Updated difficulty to $difficulty for user: $userId');
    } catch (e) {
      AppLogger.error('Error updating preferred difficulty: $e');
      rethrow;
    }
  }

  // Mark story as completed
  Future<void> markStoryCompleted(String userId, String storyId) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'completedStories': FieldValue.arrayUnion([storyId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Marked story $storyId as completed for user: $userId');
    } catch (e) {
      AppLogger.error('Error marking story as completed: $e');
      rethrow;
    }
  }

  // Update speech goals
  Future<void> updateSpeechGoals(
    String userId,
    Map<String, dynamic> goals,
  ) async {
    try {
      await _firestore.collection('user_preferences').doc(userId).update({
        'speechGoals': goals,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Updated speech goals for user: $userId');
    } catch (e) {
      AppLogger.error('Error updating speech goals: $e');
      rethrow;
    }
  }

  // Get user analytics for content personalization
  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    try {
      final preferences = await getUserPreferences(userId);

      // Get user progress data
      final progressDoc = await _firestore
          .collection('story_progress')
          .doc(userId)
          .get();

      final totalChapters = progressDoc.exists
          ? ((progressDoc.data()?['completedChapters'] as List<dynamic>?)?.length ?? 0)
          : 0;

      final totalPlayTime = progressDoc.exists
          ? (progressDoc.data()?['totalPlayTime'] as int? ?? 0)
          : 0;

      // Get user interactions
      final interactionsSnapshot = await _firestore
          .collection('user_interactions')
          .where('userId', isEqualTo: userId)
          .get();

      final totalInteractions = interactionsSnapshot.docs.length;

      return {
        'totalChapters': totalChapters,
        'totalPlayTime': totalPlayTime,
        'totalInteractions': totalInteractions,
        'favoriteCharacters': preferences.favoriteCharacters,
        'interests': preferences.interests,
        'age': preferences.age,
        'preferredDifficulty': preferences.preferredDifficulty,
        'completedStories': preferences.completedStories,
        'speechGoals': preferences.speechGoals,
      };
    } catch (e) {
      AppLogger.error('Error getting user analytics: $e');
      return {};
    }
  }
}
