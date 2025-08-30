import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../logging/app_logger.dart';
import 'firebase_service.dart';

class GoogleSignInService {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      AppLogger.info('Starting Google Sign-In process');

      // Check if Firebase is available
      if (FirebaseService.auth == null) {
        throw Exception('Firebase Auth is not available');
      }

      // Initialize Google Sign-In with platform-specific configuration
      final GoogleSignIn googleSignIn = kIsWeb
          ? GoogleSignIn(
              scopes: ['email', 'profile'],
              clientId:
                  '766247667208-atjphklfothfqg6gtks6ffpfmncafirv.apps.googleusercontent.com',
            )
          : GoogleSignIn(scopes: ['email', 'profile']);

      AppLogger.info('Starting Google Sign-In...');

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        AppLogger.info('Google Sign-In was cancelled by user');
        return null;
      }

      AppLogger.info('Google Sign-In successful, getting auth details...');

      // Obtain the auth details from the request
      GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleUser.authentication;
      } catch (e) {
        AppLogger.info(
          'Failed to get full profile, but authentication succeeded. Error: $e',
        );
        // If we can't get full auth details, we can't proceed with Firebase
        AppLogger.error('Cannot proceed without authentication details');
        return null;
      }

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AppLogger.info('Signing in to Firebase with Google credentials...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await FirebaseService.auth!
          .signInWithCredential(credential);

      AppLogger.info(
        'Firebase Google Sign-In completed successfully for user: ${userCredential.user?.email}',
      );
      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Google Sign-In failed', e, stackTrace);
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      // Sign out from Google Sign-In
      final GoogleSignIn googleSignIn = kIsWeb
          ? GoogleSignIn(
              clientId:
                  '766247667208-atjphklfothfqg6gtks6ffpfmncafirv.apps.googleusercontent.com',
            )
          : GoogleSignIn();
      await googleSignIn.signOut();

      // Sign out from Firebase
      if (FirebaseService.auth != null) {
        await FirebaseService.auth!.signOut();
        AppLogger.info('Firebase Sign-Out successful');
      }

      AppLogger.info('Google Sign-Out successful');
    } catch (e, stackTrace) {
      AppLogger.error('Sign-Out failed', e, stackTrace);
      rethrow;
    }
  }

  static Future<bool> isSignedIn() async {
    try {
      return FirebaseService.auth?.currentUser != null;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check Firebase Sign-In status', e, stackTrace);
      return false;
    }
  }

  static User? get currentUser => FirebaseService.auth?.currentUser;
}
