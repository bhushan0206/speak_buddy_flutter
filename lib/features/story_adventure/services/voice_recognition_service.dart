import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/story_models.dart';
import '../../../core/logging/app_logger.dart';

// Web-specific imports
import 'dart:js' as js;

class VoiceRecognitionService {
  bool _isInitialized = false;
  bool _isListening = false;
  Timer? _listeningTimer;
  StreamSubscription? _permissionSubscription;

  // Mobile speech recognition
  static const MethodChannel _channel = MethodChannel('voice_recognition');
  static const EventChannel _speechEventChannel = EventChannel('speech_events');
  StreamSubscription? _speechSubscription;

  // Web Speech API timer
  Timer? _webSpeechTimer;

  // Initialize voice recognition
  Future<bool> initialize() async {
    try {
      AppLogger.info('Initializing real voice recognition service...');

      if (kIsWeb) {
        AppLogger.info('Running on web - initializing Web Speech API');
        _isInitialized = await _initializeWebSpeech();
      } else {
        AppLogger.info(
          'Running on mobile - initializing native speech recognition',
        );
        _isInitialized = await _initializeMobileSpeech();
      }

      AppLogger.info('Voice recognition initialized: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      AppLogger.error('Error initializing voice recognition: $e');
      return false;
    }
  }

  // Initialize Web Speech API
  Future<bool> _initializeWebSpeech() async {
    try {
      // Check if Web Speech API is available via JavaScript
      final isAvailable =
          js.context.hasProperty('webkitSpeechRecognition') ||
          js.context.hasProperty('SpeechRecognition');

      if (isAvailable) {
        AppLogger.info('Web Speech API is available');
        return true;
      } else {
        AppLogger.warning('Web Speech API not supported in this browser');
        return false;
      }
    } catch (e) {
      AppLogger.warning('Web Speech API not available: $e');
      return false;
    }
  }

  // Initialize mobile speech recognition
  Future<bool> _initializeMobileSpeech() async {
    try {
      // Check if speech recognition is available on the device
      final result = await _channel.invokeMethod(
        'checkSpeechRecognitionAvailability',
      );
      return result == true;
    } catch (e) {
      AppLogger.warning('Mobile speech recognition not available: $e');
      return false;
    }
  }

  // Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    try {
      AppLogger.info('Checking microphone permission...');

      if (kIsWeb) {
        // On web, we'll request permission when starting speech recognition
        AppLogger.info('Web: Will request microphone permission when starting');
        return true;
      }

      final status = await Permission.microphone.status;
      AppLogger.info('Microphone permission status: $status');

      if (status.isGranted) {
        AppLogger.info('Microphone permission already granted');
        return true;
      }

      if (status.isDenied) {
        AppLogger.info('Requesting microphone permission...');
        final result = await Permission.microphone.request();
        AppLogger.info('Microphone permission result: $result');
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        AppLogger.warning('Microphone permission permanently denied');
        // Open app settings
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      AppLogger.error('Error requesting microphone permission: $e');
      return false;
    }
  }

  // Start listening for speech
  Future<bool> startListening({
    required Function(String text) onResult,
    required Function() onComplete,
  }) async {
    if (!_isInitialized) {
      AppLogger.warning('Voice recognition not initialized');
      return false;
    }

    if (_isListening) {
      AppLogger.warning('Already listening');
      return false;
    }

    // Request microphone permission
    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      AppLogger.error('Microphone permission denied');
      return false;
    }

    try {
      _isListening = true;
      AppLogger.info('Starting real voice recognition...');

      if (kIsWeb) {
        return await _startWebSpeechRecognition(onResult, onComplete);
      } else {
        return await _startMobileSpeechRecognition(onResult, onComplete);
      }
    } catch (e) {
      AppLogger.error('Error starting voice recognition: $e');
      _isListening = false;
      return false;
    }
  }

  // Web Speech API implementation
  Future<bool> _startWebSpeechRecognition(
    Function(String text) onResult,
    Function() onComplete,
  ) async {
    try {
      AppLogger.info('Starting Web Speech API recognition...');

      // Create Web Speech API instance via JavaScript
      final webSpeech = _createWebSpeechRecognition();
      if (webSpeech == null) {
        AppLogger.error('Failed to create Web Speech API instance');
        return false;
      }

      // Set up event handlers
      _setupWebSpeechHandlers(webSpeech, onResult, onComplete);

      // Start listening
      final success = _startWebSpeechListening(webSpeech);
      if (success) {
        AppLogger.info('Web Speech API started successfully');
        return true;
      } else {
        AppLogger.error('Failed to start Web Speech API');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error in Web Speech API: $e');
      return false;
    }
  }

  // Create Web Speech API instance
  js.JsObject? _createWebSpeechRecognition() {
    try {
      if (js.context.hasProperty('webkitSpeechRecognition')) {
        return js.JsObject(js.context['webkitSpeechRecognition']);
      } else if (js.context.hasProperty('SpeechRecognition')) {
        return js.JsObject(js.context['SpeechRecognition']);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error creating Web Speech API instance: $e');
      return null;
    }
  }

  // Set up Web Speech API event handlers
  void _setupWebSpeechHandlers(
    js.JsObject webSpeech,
    Function(String text) onResult,
    Function() onComplete,
  ) {
    try {
      // Configure recognition settings
      webSpeech['continuous'] = false;
      webSpeech['interimResults'] = true;
      webSpeech['lang'] = 'en-US';
      webSpeech['maxAlternatives'] = 3;

      // Set up event handlers
      webSpeech['onstart'] = () {
        AppLogger.info('Web Speech API started');
        _isListening = true;
      };

      webSpeech['onresult'] = (event) {
        try {
          // Convert JavaScript event to Dart Map
          final eventMap = js.JsObject.fromBrowserObject(event);
          final results = eventMap['results'];

          if (results != null) {
            final resultsLength = results['length'];
            for (int i = 0; i < resultsLength; i++) {
              final result = results[i];
              final transcript = result[0]['transcript'];
              final isFinal = result['isFinal'];

              if (transcript != null && transcript.isNotEmpty) {
                AppLogger.info(
                  'Web Speech API result: $transcript (final: $isFinal)',
                );
                onResult(transcript);

                if (isFinal == true) {
                  _isListening = false;
                  onComplete();
                }
              }
            }
          }
        } catch (e) {
          AppLogger.error('Error processing Web Speech API result: $e');
        }
      };

      webSpeech['onerror'] = (event) {
        try {
          final eventMap = js.JsObject.fromBrowserObject(event);
          AppLogger.error('Web Speech API error: ${eventMap['error']}');
        } catch (e) {
          AppLogger.error('Web Speech API error: $e');
        }
        _isListening = false;
        onComplete();
      };

      webSpeech['onend'] = () {
        AppLogger.info('Web Speech API ended');
        _isListening = false;
        onComplete();
      };
    } catch (e) {
      AppLogger.error('Error setting up Web Speech API handlers: $e');
    }
  }

  // Start Web Speech API listening
  bool _startWebSpeechListening(js.JsObject webSpeech) {
    try {
      webSpeech.callMethod('start');
      return true;
    } catch (e) {
      AppLogger.error('Error starting Web Speech API listening: $e');
      return false;
    }
  }

  // Mobile speech recognition implementation
  Future<bool> _startMobileSpeechRecognition(
    Function(String text) onResult,
    Function() onComplete,
  ) async {
    try {
      AppLogger.info('Starting mobile speech recognition...');

      // Start listening via native speech recognition
      final result = await _channel.invokeMethod('startListening');

      if (result == true) {
        // Listen for speech results
        _speechSubscription = _speechEventChannel.receiveBroadcastStream().listen(
          (dynamic event) {
            if (event is Map) {
              final text = event['text'] as String?;
              final isFinal = event['isFinal'] as bool? ?? false;
              final confidence = event['confidence'] as double? ?? 0.0;

              if (text != null && text.isNotEmpty) {
                AppLogger.info(
                  'Mobile speech result: $text (confidence: $confidence, final: $isFinal)',
                );
                onResult(text);

                if (isFinal) {
                  _isListening = false;
                  onComplete();
                }
              }
            }
          },
          onError: (error) {
            AppLogger.error('Mobile speech recognition error: $error');
            _isListening = false;
            onComplete();
          },
        );

        return true;
      } else {
        AppLogger.error('Failed to start mobile speech recognition');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error in mobile speech recognition: $e');
      return false;
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    try {
      AppLogger.info('Stopping voice recognition...');

      _speechSubscription?.cancel();
      _listeningTimer?.cancel();
      _webSpeechTimer?.cancel();
      _isListening = false;

      // Stop listening on the native side
      if (_isInitialized) {
        try {
          if (kIsWeb) {
            // Stop Web Speech API
            _stopWebSpeechListening();
          } else {
            await _channel.invokeMethod('stopListening');
          }
        } catch (e) {
          AppLogger.warning('Error stopping recognition: $e');
        }
      }

      AppLogger.info('Stopped listening for speech');
    } catch (e) {
      AppLogger.error('Error stopping speech recognition: $e');
    }
  }

  // Stop Web Speech API listening
  void _stopWebSpeechListening() {
    try {
      // This will be handled by the onend event
      AppLogger.info('Web Speech API stopping...');
    } catch (e) {
      AppLogger.error('Error stopping Web Speech API: $e');
    }
  }

  // Check if currently listening
  bool get isListening => _isListening;

  // Check if available
  bool get isAvailable => _isInitialized;

  // Process voice input and calculate word accuracy
  Future<VoiceRecognitionResult> processVoiceInput(
    String recognizedText,
    List<String> targetWords,
  ) async {
    try {
      AppLogger.info('Processing real voice input: "$recognizedText"');
      AppLogger.info('Target words: $targetWords');

      // Calculate word accuracy
      final wordAccuracy = <String, double>{};
      final lowerRecognized = recognizedText.toLowerCase();

      for (final targetWord in targetWords) {
        final lowerTarget = targetWord.toLowerCase();

        if (lowerRecognized.contains(lowerTarget)) {
          wordAccuracy[targetWord] = 1.0; // Perfect match
          AppLogger.info('Perfect match found for: $targetWord');
        } else {
          // Calculate similarity score using Levenshtein distance
          final similarity = _calculateSimilarity(lowerTarget, lowerRecognized);
          wordAccuracy[targetWord] = similarity;
          AppLogger.info(
            'Similarity for $targetWord: ${(similarity * 100).round()}%',
          );
        }
      }

      // Determine if any word was successfully recognized
      final isSuccess = wordAccuracy.values.any((accuracy) => accuracy > 0.7);
      final confidence = wordAccuracy.values.isNotEmpty
          ? wordAccuracy.values.reduce((a, b) => a + b) / wordAccuracy.length
          : 0.0;

      AppLogger.info('Overall confidence: ${(confidence * 100).round()}%');
      AppLogger.info('Success: $isSuccess');

      return VoiceRecognitionResult(
        recognizedText: recognizedText,
        confidence: confidence,
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

  // Dispose resources
  void dispose() {
    _listeningTimer?.cancel();
    _permissionSubscription?.cancel();
    _speechSubscription?.cancel();
    _webSpeechTimer?.cancel();
  }
}
