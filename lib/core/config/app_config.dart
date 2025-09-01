import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static String get firebaseApiKey => _getEnv('FIREBASE_API_KEY', '');
  static String get firebaseAppId => _getEnv('FIREBASE_APP_ID', '');
  static String get firebaseMessagingSenderId =>
      _getEnv('FIREBASE_MESSAGING_SENDER_ID', '');
  static String get firebaseProjectId => _getEnv('FIREBASE_PROJECT_ID', '');
  static String get firebaseStorageBucket =>
      _getEnv('FIREBASE_STORAGE_BUCKET', '');

  static String get googleClientIdAndroid =>
      _getEnv('GOOGLE_CLIENT_ID_ANDROID', '');
  static String get googleClientIdIos => _getEnv('GOOGLE_CLIENT_ID_IOS', '');
  static String get googleClientIdWeb => _getEnv('GOOGLE_CLIENT_ID_WEB', '');

  static String get appName => _getEnv('APP_NAME', 'SpeakBuddy');
  static String get appVersion => _getEnv('APP_VERSION', '1.0.0');
  static String get environment => _getEnv('ENVIRONMENT', 'development');

  // AI Configuration
  static String get aiProvider =>
      _getEnv('AI_PROVIDER', 'gemini'); // 'openai' or 'gemini'
  static String get openaiApiKey => _getEnv('OPENAI_API_KEY', '');
  static String get geminiApiKey => _getEnv('GEMINI_API_KEY', '');

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  static String _getEnv(String key, String defaultValue) {
    try {
      print('🔧 CONFIG: Getting environment variable: $key');

      if (kIsWeb) {
        print('🔧 CONFIG: Running on web platform');
        // For web, use hardcoded values for now
        print('🔧 CONFIG: Using hardcoded values for web');
        switch (key) {
          case 'FIREBASE_API_KEY':
            return 'AIzaSyDIBEULoXBPEgy4hKicAuOsENRQuyIPt2w';
          case 'FIREBASE_APP_ID':
            return '1:766247667208:web:87bbeef9fe4ab23049b3bd';
          case 'FIREBASE_PROJECT_ID':
            return 'speakbuddy-1da6d';
          case 'AI_PROVIDER':
            print('🔧 CONFIG: Using hardcoded AI_PROVIDER: gemini');
            return 'gemini'; // Default to Gemini
          case 'GEMINI_API_KEY':
            print('🔧 CONFIG: Using hardcoded GEMINI_API_KEY');
            return 'AIzaSyDTjbqN7JLJ9rCdJsi5nLSokBug5wdoZu8';
          case 'OPENAI_API_KEY':
            print('🔧 CONFIG: Using hardcoded OPENAI_API_KEY');
            return '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';
          default:
            return defaultValue;
        }
      } else {
        print('🔧 CONFIG: Running on mobile platform');
        // For mobile platforms, use dotenv
        try {
          final envValue = dotenv.env[key];
          if (envValue != null && envValue.isNotEmpty) {
            print(
              '🔧 CONFIG: Found $key in dotenv with length: ${envValue.length}',
            );
            return envValue;
          } else {
            print('⚠️ CONFIG: $key not found in dotenv or is empty');
          }
        } catch (e) {
          print('❌ CONFIG: Error reading from dotenv: $e');
        }

        // Fallback to hardcoded values for critical configs
        print('🔧 CONFIG: Using fallback values for mobile');
        switch (key) {
          case 'FIREBASE_API_KEY':
            return 'AIzaSyDIBEULoXBPEgy4hKicAuOsENRQuyIPt2w';
          case 'FIREBASE_APP_ID':
            return '1:766247667208:android:3c71aaa713efb8ba49b3bd';
          case 'FIREBASE_PROJECT_ID':
            return 'speakbuddy-1da6d';
          case 'AI_PROVIDER':
            return 'gemini';
          case 'GEMINI_API_KEY':
            return 'AIzaSyDTjbqN7JLJ9rCdJsi5nLSokBug5wdoZu8';
          case 'OPENAI_API_KEY':
            return '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';
          default:
            return defaultValue;
        }
      }
    } catch (e) {
      print('❌ CONFIG: Error getting $key: $e');
      return defaultValue;
    }
  }
}
