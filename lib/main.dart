import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'core/config/app_config.dart';
import 'core/services/firebase_service.dart';
import 'core/logging/app_logger.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/story_adventure/providers/story_adventure_provider.dart';

void main() async {
  print('🚀 MAIN: Starting SpeakBuddy application...');
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 APP: Starting SpeakBuddy application...');

  try {
    // Load environment variables based on platform
    print('🔧 APP: Loading environment variables...');
    AppLogger.info('Loading environment variables...');

    if (kIsWeb) {
      // For web, environment variables are loaded from window.flutterEnvironment in index.html
      print('🔧 APP: Running on web - using web environment configuration');
      AppLogger.info('Running on web - using web environment configuration');

      // Test configuration loading
      print('🔧 APP: Testing configuration loading...');
      print('🔧 APP: AI Provider: ${AppConfig.aiProvider}');
      print('🔧 APP: Gemini API Key length: ${AppConfig.geminiApiKey.length}');
      print(
        '🔧 APP: Gemini API Key starts with: ${AppConfig.geminiApiKey.isNotEmpty ? AppConfig.geminiApiKey.substring(0, 10) : "EMPTY"}',
      );
    } else {
      // For mobile platforms, load from .env file
      print('🔧 APP: Running on mobile - loading from .env file');
      try {
        await dotenv.load(fileName: '.env');
        print('🔧 APP: Environment variables loaded successfully from .env');
        AppLogger.info('Environment variables loaded successfully from .env');
      } catch (e) {
        print('⚠️ APP: Could not load .env file: $e');
        print('🔧 APP: Will use fallback configuration values');
        AppLogger.warning(
          'Could not load .env file, using fallback configuration',
        );
      }
    }

    // Initialize Firebase using firebase_options.dart
    print('🔧 APP: Initializing Firebase...');
    AppLogger.info('Initializing Firebase...');
    await FirebaseService.initialize();
    print('🔧 APP: Firebase initialized successfully');
    AppLogger.info('Firebase initialized successfully');
  } catch (e) {
    print('❌ APP: Initialization failed: $e');
    AppLogger.warning('Initialization failed: $e');
    AppLogger.info('App will run in offline mode');
  }

  print('🚀 APP: App starting...');
  AppLogger.info('App starting...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StoryAdventureProvider()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B73FF), // Child-friendly blue
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ),
        home: Builder(builder: (context) => AppRouter.getInitialRoute(context)),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
