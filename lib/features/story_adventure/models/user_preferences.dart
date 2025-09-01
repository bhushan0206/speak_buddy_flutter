import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final String userId;
  final List<String> favoriteCharacters;
  final List<String> interests;
  final int age;
  final String preferredDifficulty;
  final List<String> completedStories;
  final Map<String, dynamic> speechGoals;
  final DateTime lastUpdated;

  UserPreferences({
    required this.userId,
    required this.favoriteCharacters,
    required this.interests,
    required this.age,
    required this.preferredDifficulty,
    required this.completedStories,
    required this.speechGoals,
    required this.lastUpdated,
  });

  factory UserPreferences.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserPreferences(
      userId: data['userId'] ?? '',
      favoriteCharacters: List<String>.from(data['favoriteCharacters'] ?? []),
      interests: List<String>.from(data['interests'] ?? []),
      age: data['age'] ?? 8,
      preferredDifficulty: data['preferredDifficulty'] ?? 'medium',
      completedStories: List<String>.from(data['completedStories'] ?? []),
      speechGoals: Map<String, dynamic>.from(data['speechGoals'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'favoriteCharacters': favoriteCharacters,
      'interests': interests,
      'age': age,
      'preferredDifficulty': preferredDifficulty,
      'completedStories': completedStories,
      'speechGoals': speechGoals,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserPreferences copyWith({
    List<String>? favoriteCharacters,
    List<String>? interests,
    int? age,
    String? preferredDifficulty,
    List<String>? completedStories,
    Map<String, dynamic>? speechGoals,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      userId: userId,
      favoriteCharacters: favoriteCharacters ?? this.favoriteCharacters,
      interests: interests ?? this.interests,
      age: age ?? this.age,
      preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
      completedStories: completedStories ?? this.completedStories,
      speechGoals: speechGoals ?? this.speechGoals,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Create default preferences for new users
  factory UserPreferences.defaultFor(String userId) {
    return UserPreferences(
      userId: userId,
      favoriteCharacters: [],
      interests: ['speech', 'learning', 'adventure', 'stories'],
      age: 8,
      preferredDifficulty: 'medium',
      completedStories: [],
      speechGoals: {
        'pronunciation': true,
        'vocabulary': true,
        'fluency': true,
        'confidence': true,
      },
      lastUpdated: DateTime.now(),
    );
  }
}
