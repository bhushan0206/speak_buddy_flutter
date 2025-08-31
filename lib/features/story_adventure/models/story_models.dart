import 'package:cloud_firestore/cloud_firestore.dart';

class StoryChapter {
  final String id;
  final String title;
  final String description;
  final String content;
  final List<StoryChoice> choices;
  final List<String> targetWords;
  final int difficulty;
  final String characterId;
  final Map<String, dynamic> metadata;

  StoryChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.choices,
    required this.targetWords,
    required this.difficulty,
    required this.characterId,
    required this.metadata,
  });

  factory StoryChapter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryChapter(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      choices: (data['choices'] as List<dynamic>?)
              ?.map((choice) => StoryChoice.fromMap(choice))
              .toList() ??
          [],
      targetWords: List<String>.from(data['targetWords'] ?? []),
      difficulty: data['difficulty'] ?? 1,
      characterId: data['characterId'] ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'choices': choices.map((choice) => choice.toMap()).toList(),
      'targetWords': targetWords,
      'difficulty': difficulty,
      'characterId': characterId,
      'metadata': metadata,
    };
  }
}

class StoryChoice {
  final String id;
  final String text;
  final String nextChapterId;
  final List<String> requiredWords;
  final String response;

  StoryChoice({
    required this.id,
    required this.text,
    required this.nextChapterId,
    required this.requiredWords,
    required this.response,
  });

  factory StoryChoice.fromMap(Map<String, dynamic> map) {
    return StoryChoice(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      nextChapterId: map['nextChapterId'] ?? '',
      requiredWords: List<String>.from(map['requiredWords'] ?? []),
      response: map['response'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'nextChapterId': nextChapterId,
      'requiredWords': requiredWords,
      'response': response,
    };
  }
}

class AICharacter {
  final String id;
  final String name;
  final String description;
  final String personality;
  final String avatarUrl;
  final Map<String, dynamic> metadata;

  AICharacter({
    required this.id,
    required this.name,
    required this.description,
    required this.personality,
    required this.avatarUrl,
    required this.metadata,
  });

  factory AICharacter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AICharacter(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      personality: data['personality'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'personality': personality,
      'avatarUrl': avatarUrl,
      'metadata': metadata,
    };
  }
}

class StoryProgress {
  final String userId;
  final String storyId;
  final String currentChapterId;
  final List<String> completedChapters;
  final Map<String, double> wordAccuracy;
  final Map<String, String> choices;
  final DateTime lastPlayed;
  final int totalPlayTime;
  final Map<String, dynamic> achievements;

  StoryProgress({
    required this.userId,
    required this.storyId,
    required this.currentChapterId,
    required this.completedChapters,
    required this.wordAccuracy,
    required this.choices,
    required this.lastPlayed,
    required this.totalPlayTime,
    required this.achievements,
  });

  factory StoryProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryProgress(
      userId: data['userId'] ?? '',
      storyId: data['storyId'] ?? '',
      currentChapterId: data['currentChapterId'] ?? '',
      completedChapters: List<String>.from(data['completedChapters'] ?? []),
      wordAccuracy: Map<String, double>.from(data['wordAccuracy'] ?? {}),
      choices: Map<String, String>.from(data['choices'] ?? {}),
      lastPlayed: (data['lastPlayed'] as Timestamp).toDate(),
      totalPlayTime: data['totalPlayTime'] ?? 0,
      achievements: Map<String, dynamic>.from(data['achievements'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storyId': storyId,
      'currentChapterId': currentChapterId,
      'completedChapters': completedChapters,
      'wordAccuracy': wordAccuracy,
      'choices': choices,
      'lastPlayed': Timestamp.fromDate(lastPlayed),
      'totalPlayTime': totalPlayTime,
      'achievements': achievements,
    };
  }

  StoryProgress copyWith({
    String? currentChapterId,
    List<String>? completedChapters,
    Map<String, double>? wordAccuracy,
    Map<String, String>? choices,
    DateTime? lastPlayed,
    int? totalPlayTime,
    Map<String, dynamic>? achievements,
  }) {
    return StoryProgress(
      userId: userId,
      storyId: storyId,
      currentChapterId: currentChapterId ?? this.currentChapterId,
      completedChapters: completedChapters ?? this.completedChapters,
      wordAccuracy: wordAccuracy ?? this.wordAccuracy,
      choices: choices ?? this.choices,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      achievements: achievements ?? this.achievements,
    );
  }
}

class VoiceRecognitionResult {
  final String recognizedText;
  final double confidence;
  final List<String> targetWords;
  final Map<String, double> wordAccuracy;
  final bool isSuccess;

  VoiceRecognitionResult({
    required this.recognizedText,
    required this.confidence,
    required this.targetWords,
    required this.wordAccuracy,
    required this.isSuccess,
  });
}

class AIResponse {
  final String characterId;
  final String message;
  final String emotion;
  final List<String> suggestedResponses;
  final Map<String, dynamic> context;

  AIResponse({
    required this.characterId,
    required this.message,
    required this.emotion,
    required this.suggestedResponses,
    required this.context,
  });
}
