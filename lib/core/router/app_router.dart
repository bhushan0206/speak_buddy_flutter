import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/landing/pages/landing_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/story_adventure/pages/story_adventure_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case '/story-adventure':
        final args = settings.arguments as Map<String, dynamic>?;
        final storyId = args?['storyId'] ?? 'demo_story_1';
        final userId = args?['userId'];

        if (userId == null) {
          // Redirect to dashboard if no user ID provided
          return MaterialPageRoute(builder: (_) => const DashboardPage());
        }

        return MaterialPageRoute(
          builder: (_) => StoryAdventurePage(storyId: storyId, userId: userId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static Widget getInitialRoute(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const DashboardPage();
        }
        return const LandingPage();
      },
    );
  }
}
