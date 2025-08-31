import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/pages/dashboard_page.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/logging/app_logger.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: AppTheme.primaryBackground,
          body: Stack(
            children: [
              // Animated background
              Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingM,
                      medium: AppTheme.spacingL,
                      large: AppTheme.spacingXL,
                    ),
                    vertical: AppTheme.spacingM,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      SizedBox(
                        height: AppTheme.getResponsiveSpacing(
                          context,
                          small: AppTheme.spacingL,
                          medium: AppTheme.spacingXL,
                          large: AppTheme.spacingXXL,
                        ),
                      ),
                      _buildFeatureCards(context),
                      SizedBox(
                        height: AppTheme.getResponsiveSpacing(
                          context,
                          small: AppTheme.spacingL,
                          medium: AppTheme.spacingXL,
                          large: AppTheme.spacingXXL,
                        ),
                      ),
                      _buildGoogleSignInSection(context, authProvider),
                      SizedBox(
                        height: AppTheme.getResponsiveSpacing(
                          context,
                          small: AppTheme.spacingL,
                          medium: AppTheme.spacingXL,
                          large: AppTheme.spacingXXL,
                        ),
                      ),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // App logo/icon
            Container(
              width: AppTheme.getResponsiveSpacing(
                context,
                small: 60,
                medium: 80,
                large: 100,
              ),
              height: AppTheme.getResponsiveSpacing(
                context,
                small: 60,
                medium: 80,
                large: 100,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: [AppTheme.elevatedShadow],
              ),
              child: Icon(
                Icons.record_voice_over,
                color: Colors.white,
                size: AppTheme.getResponsiveSpacing(
                  context,
                  small: 30,
                  medium: 40,
                  large: 50,
                ),
              ),
            ),

            SizedBox(
              height: AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingM,
                medium: AppTheme.spacingL,
                large: AppTheme.spacingXL,
              ),
            ),

            // App title
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'SpeakBuddy',
                style: AppTheme.heading1.copyWith(
                  fontSize: AppTheme.getResponsiveFontSize(
                    context,
                    small: 28,
                    medium: 32,
                    large: 36,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingS,
                medium: AppTheme.spacingM,
                large: AppTheme.spacingL,
              ),
            ),

            // App subtitle
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getResponsiveSpacing(
                  context,
                  small: AppTheme.spacingM,
                  medium: AppTheme.spacingL,
                  large: AppTheme.spacingXL,
                ),
              ),
              child: Text(
                'Your AI-powered speech therapy companion for children aged 2-12',
                style: AppTheme.bodyLarge.copyWith(
                  fontSize: AppTheme.getResponsiveFontSize(
                    context,
                    small: 14,
                    medium: 16,
                    large: 18,
                  ),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    final featureCards = [
      {
        'title': 'Child-Specific AI',
        'description':
            'Built exclusively for children\'s unique speech patterns and behaviors',
        'icon': Icons.psychology,
        'color': AppTheme.primaryCoral,
        'emoji': '🧠',
      },
      {
        'title': 'Gamified Learning',
        'description': 'Story-driven adventures and interactive challenges',
        'icon': Icons.games,
        'color': AppTheme.primaryTeal,
        'emoji': '🎮',
      },
      {
        'title': 'Professional Tools',
        'description': 'Seamless therapist-parent collaboration',
        'icon': Icons.people,
        'color': AppTheme.primaryBlue,
        'emoji': '👥',
      },
      {
        'title': 'Cultural Inclusivity',
        'description': 'Supports diverse accents, dialects, and languages',
        'icon': Icons.language,
        'color': AppTheme.primaryYellow,
        'emoji': '🌍',
      },
      {
        'title': 'Privacy First',
        'description': 'COPPA-compliant with local processing capabilities',
        'icon': Icons.security,
        'color': AppTheme.error,
        'emoji': '🔒',
      },
      {
        'title': 'Fun & Engaging',
        'description': 'Makes speech therapy enjoyable for children',
        'icon': Icons.celebration,
        'color': AppTheme.primaryPurple,
        'emoji': '🎉',
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🌟 ',
                      style: TextStyle(
                        fontSize: AppTheme.getResponsiveFontSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),
                    ),
                    Text(
                      'Why Choose SpeakBuddy?',
                      style: AppTheme.heading3.copyWith(
                        fontSize: AppTheme.getResponsiveFontSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),
                    ),
                    Text(
                      ' 🌟',
                      style: TextStyle(
                        fontSize: AppTheme.getResponsiveFontSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingM,
                medium: AppTheme.spacingL,
                large: AppTheme.spacingXL,
              ),
            ),

            // Responsive grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;
                final isMediumScreen = constraints.maxWidth < 900;

                final crossAxisCount = isSmallScreen
                    ? 1
                    : (isMediumScreen ? 2 : 3);
                final childAspectRatio = isSmallScreen
                    ? 1.1
                    : (isMediumScreen ? 1.0 : 0.9);
                final spacing = AppTheme.getResponsiveSpacing(
                  context,
                  small: AppTheme.spacingS,
                  medium: AppTheme.spacingM,
                  large: AppTheme.spacingL,
                );

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: featureCards.length,
                  itemBuilder: (context, index) {
                    final card = featureCards[index];
                    return _buildFeatureCard(
                      context,
                      title: card['title'] as String,
                      description: card['description'] as String,
                      icon: card['icon'] as IconData,
                      color: card['color'] as Color,
                      emoji: card['emoji'] as String,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String emoji,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.secondaryBackground,
                  color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
              boxShadow: [AppTheme.elevatedShadow],
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppTheme.getResponsiveSpacing(
                  context,
                  small: AppTheme.spacingS,
                  medium: AppTheme.spacingM,
                  large: AppTheme.spacingL,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emoji,
                        style: TextStyle(
                          fontSize: AppTheme.getResponsiveFontSize(
                            context,
                            small: 20,
                            medium: 24,
                            large: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppTheme.getResponsiveSpacing(
                          context,
                          small: AppTheme.spacingXS,
                          medium: AppTheme.spacingS,
                          large: AppTheme.spacingM,
                        ),
                      ),
                      Icon(
                        icon,
                        color: color,
                        size: AppTheme.getResponsiveFontSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingS,
                      medium: AppTheme.spacingM,
                      large: AppTheme.spacingL,
                    ),
                  ),

                  // Title
                  Text(
                    title,
                    style: AppTheme.heading4.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(
                        context,
                        small: 16,
                        medium: 18,
                        large: 20,
                      ),
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(
                    height: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingXS,
                      medium: AppTheme.spacingS,
                      large: AppTheme.spacingM,
                    ),
                  ),

                  // Description
                  Text(
                    description,
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(
                        context,
                        small: 12,
                        medium: 14,
                        large: 16,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleSignInSection(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    return Consumer<AuthProvider>(
      builder: (consumerContext, authProvider, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Section title
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Start Your Speech Journey',
                    style: AppTheme.heading4.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(
                        context,
                        small: 20,
                        medium: 22,
                        large: 24,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: AppTheme.getResponsiveSpacing(
                    context,
                    small: AppTheme.spacingM,
                    medium: AppTheme.spacingL,
                    large: AppTheme.spacingXL,
                  ),
                ),

                // Subtitle
                Text(
                  'Join thousands of families improving speech together',
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: AppTheme.getResponsiveFontSize(
                      context,
                      small: 14,
                      medium: 16,
                      large: 18,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(
                  height: AppTheme.getResponsiveSpacing(
                    context,
                    small: AppTheme.spacingXS,
                    medium: AppTheme.spacingS,
                    large: AppTheme.spacingM,
                  ),
                ),

                // Error display
                if (authProvider.error != null)
                  Container(
                    padding: EdgeInsets.all(
                      AppTheme.getResponsiveSpacing(
                        context,
                        small: AppTheme.spacingS,
                        medium: AppTheme.spacingM,
                        large: AppTheme.spacingL,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      bottom: AppTheme.getResponsiveSpacing(
                        context,
                        small: AppTheme.spacingM,
                        medium: AppTheme.spacingL,
                        large: AppTheme.spacingXL,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: AppTheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.error,
                          size: AppTheme.getResponsiveFontSize(
                            context,
                            small: 20,
                            medium: 22,
                            large: 24,
                          ),
                        ),
                        SizedBox(
                          width: AppTheme.getResponsiveSpacing(
                            context,
                            small: AppTheme.spacingXS,
                            medium: AppTheme.spacingS,
                            large: AppTheme.spacingM,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.error,
                              fontSize: AppTheme.getResponsiveFontSize(
                                context,
                                small: 12,
                                medium: 14,
                                large: 16,
                              ),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.error,
                            size: AppTheme.getResponsiveFontSize(
                              context,
                              small: 16,
                              medium: 18,
                              large: 20,
                            ),
                          ),
                          onPressed: authProvider.clearError,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: AppTheme.getResponsiveSpacing(
                              context,
                              small: 32,
                              medium: 36,
                              large: 40,
                            ),
                            minHeight: AppTheme.getResponsiveSpacing(
                              context,
                              small: 32,
                              medium: 36,
                              large: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Sign-in button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            final scaffoldContext = context;
                            try {
                              AppLogger.info(
                                'User clicked Google Sign-In button',
                              );
                              await consumerContext
                                  .read<AuthProvider>()
                                  .signInWithGoogle();
                              AppLogger.info(
                                'Google Sign-In process completed',
                              );
                            } catch (e) {
                              AppLogger.error('Google Sign-In error', e);
                              if (mounted) {
                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sign-in failed: ${e.toString()}',
                                    ),
                                    backgroundColor: AppTheme.error,
                                  ),
                                );
                              }
                            }
                          },
                    style: AppTheme.primaryButton.copyWith(
                      backgroundColor: WidgetStateProperty.all(
                        AppTheme.primaryTeal,
                      ),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: AppTheme.getResponsiveSpacing(
                            context,
                            small: AppTheme.spacingM,
                            medium: AppTheme.spacingL,
                            large: AppTheme.spacingXL,
                          ),
                          vertical: AppTheme.getResponsiveSpacing(
                            context,
                            small: AppTheme.spacingM,
                            medium: AppTheme.spacingL,
                            large: AppTheme.spacingXL,
                          ),
                        ),
                      ),
                    ),
                    icon: authProvider.isLoading
                        ? SizedBox(
                            width: AppTheme.getResponsiveSpacing(
                              context,
                              small: 20,
                              medium: 22,
                              large: 24,
                            ),
                            height: AppTheme.getResponsiveSpacing(
                              context,
                              small: 20,
                              medium: 22,
                              large: 24,
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.g_mobiledata,
                            size: AppTheme.getResponsiveFontSize(
                              context,
                              small: 20,
                              medium: 22,
                              large: 24,
                            ),
                            color: Colors.white,
                          ),
                    label: Text(
                      authProvider.isLoading
                          ? 'Signing In...'
                          : 'Continue with Google',
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: AppTheme.getResponsiveFontSize(
                          context,
                          small: 14,
                          medium: 16,
                          large: 18,
                        ),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getResponsiveSpacing(
                  context,
                  small: AppTheme.spacingM,
                  medium: AppTheme.spacingL,
                  large: AppTheme.spacingXL,
                ),
                vertical: AppTheme.getResponsiveSpacing(
                  context,
                  small: AppTheme.spacingM,
                  medium: AppTheme.spacingL,
                  large: AppTheme.spacingXL,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Empowering children to find their voice',
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(
                        context,
                        small: 12,
                        medium: 14,
                        large: 16,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(
                    height: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingXS,
                      medium: AppTheme.spacingS,
                      large: AppTheme.spacingM,
                    ),
                  ),

                  Text(
                    'SpeakBuddy v1.0.0',
                    style: AppTheme.caption.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(
                        context,
                        small: 10,
                        medium: 12,
                        large: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
