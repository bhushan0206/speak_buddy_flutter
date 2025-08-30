import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static String get appName => _getEnv('APP_NAME', 'My Template App');
  static String get appVersion => _getEnv('APP_VERSION', '1.0.0');
  static String get environment => _getEnv('ENVIRONMENT', 'development');

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  static String _getEnv(String key, String defaultValue) {
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
