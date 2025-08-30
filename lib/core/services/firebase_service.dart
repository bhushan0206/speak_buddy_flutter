import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../logging/app_logger.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static FirebaseAuth? get auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      AppLogger.warning('Firebase Auth not available: $e');
      return null;
    }
  }

  static FirebaseFirestore? get firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      AppLogger.warning('Firebase Firestore not available: $e');
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        AppLogger.info('Firebase already initialized');
        return;
      }

      // Use the existing firebase_options.dart configuration for all platforms
      AppLogger.info(
        'Initializing Firebase with firebase_options.dart configuration...',
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.info('Firebase initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase', e, stackTrace);
      // Don't rethrow - allow app to continue without Firebase
      AppLogger.info('Continuing without Firebase');
    }
  }

  static User? get currentUser {
    try {
      return auth?.currentUser;
    } catch (e) {
      AppLogger.warning('Could not get current user: $e');
      return null;
    }
  }

  static Stream<User?> get authStateChanges {
    try {
      return auth?.authStateChanges() ?? Stream.value(null);
    } catch (e) {
      AppLogger.warning('Could not get auth state changes: $e');
      return Stream.value(null);
    }
  }

  static Future<void> signOut() async {
    try {
      await auth?.signOut();
      AppLogger.info('User signed out successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to sign out', e, stackTrace);
      rethrow;
    }
  }
}
