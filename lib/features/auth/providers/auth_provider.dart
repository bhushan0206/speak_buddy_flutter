import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/google_signin_service.dart';
import '../../../core/logging/app_logger.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final bool _isAuthenticated = false;
  User? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  User? get user => _user;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    try {
      // Check if Firebase is available
      if (FirebaseService.auth != null) {
        FirebaseService.authStateChanges.listen((User? user) {
          _user = user;
          _error = null;
          notifyListeners();
          AppLogger.info('Auth state changed: ${user?.email ?? 'No user'}');
        });
        AppLogger.info('AuthProvider initialized with Firebase');
      } else {
        AppLogger.warning(
          'Firebase Auth not available, running in offline mode',
        );
        _user = null;
        _error = 'Firebase authentication not available';
        notifyListeners();
      }
    } catch (e) {
      AppLogger.warning('Firebase auth not available: $e');
      _user = null;
      _error = 'Firebase authentication not available';
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      AppLogger.info('AuthProvider: Starting Google Sign-In process');
      _setLoading(true);
      _clearError();

      // Check if Firebase is available
      if (FirebaseService.auth == null) {
        AppLogger.error('AuthProvider: Firebase Auth is null');
        _setError(
          'Firebase is not available. Please check your configuration.',
        );
        return;
      }

      AppLogger.info(
        'AuthProvider: Firebase Auth is available, calling GoogleSignInService',
      );
      final userCredential = await GoogleSignInService.signInWithGoogle();

      if (userCredential != null) {
        _user = userCredential.user;
        AppLogger.info(
          'AuthProvider: User signed in successfully: ${_user?.email}',
        );
      } else {
        AppLogger.info(
          'AuthProvider: Google Sign-In returned null (user cancelled)',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('AuthProvider: Google Sign-In failed', e, stackTrace);
      _setError('Failed to sign in with Google: ${e.toString()}');
    } finally {
      _setLoading(false);
      AppLogger.info('AuthProvider: Google Sign-In process completed');
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);

      // Try to sign out from Google Sign-In
      try {
        await GoogleSignInService.signOut();
      } catch (e) {
        AppLogger.warning('Google Sign-Out failed: $e');
      }

      // Try to sign out from Firebase if available
      try {
        if (FirebaseService.auth != null) {
          await FirebaseService.signOut();
        }
      } catch (e) {
        AppLogger.warning('Firebase Sign-Out failed: $e');
      }

      _user = null;
      AppLogger.info('AuthProvider: User signed out successfully');
    } catch (e, stackTrace) {
      AppLogger.error('AuthProvider: Sign-Out failed', e, stackTrace);
      _setError('Failed to sign out: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
