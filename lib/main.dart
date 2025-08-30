import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/app_config.dart';
import 'core/services/firebase_service.dart';
import 'core/logging/app_logger.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase using firebase_options.dart
    AppLogger.info('Initializing Firebase...');
    await FirebaseService.initialize();
    AppLogger.info('Firebase initialized successfully');
  } catch (e) {
    AppLogger.warning('Firebase initialization failed: $e');
    AppLogger.info('App will run in offline mode');
  }
  
  AppLogger.info('App starting...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        home: Builder(builder: (context) => AppRouter.getInitialRoute(context)),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
