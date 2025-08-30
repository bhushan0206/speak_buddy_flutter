import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/pages/dashboard_page.dart';
import '../widgets/template_card.dart';
import '../widgets/animated_background.dart';
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

    // Start animations after a short delay to ensure proper initialization
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
        // Navigate to dashboard if user is authenticated
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
          body: Stack(
            children: [
              // Animated background
              const AnimatedBackground(),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      // Header section
                      _buildHeader(),
                      const SizedBox(height: 32),

                      // Template cards section
                      _buildTemplateCards(),
                      const SizedBox(height: 32),

                      // Google Sign-In section
                      _buildGoogleSignInSection(),
                      const SizedBox(height: 32),

                      // Footer
                      _buildFooter(),
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

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // App logo/icon with enhanced styling
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 35,
              ),
            ),

            const SizedBox(height: 20),

            // App title with enhanced typography
            Text(
              'My Template App',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 10),

            // App subtitle with better styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your comprehensive Flutter template for building amazing apps',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCards() {
    final templateCards = [
      {
        'title': 'Firebase Integration',
        'description':
            'Ready-to-use Firebase services with authentication and database',
        'icon': Icons.cloud,
        'color': Colors.orange,
      },
      {
        'title': 'Google Sign-In',
        'description':
            'Seamless Google authentication with proper error handling',
        'icon': Icons.login,
        'color': Colors.blue,
      },
      {
        'title': 'Modern UI/UX',
        'description': 'Beautiful animations and responsive design patterns',
        'icon': Icons.brush,
        'color': Colors.purple,
      },
      {
        'title': 'Production Ready',
        'description': 'Logging, error handling, and best practices included',
        'icon': Icons.verified,
        'color': Colors.green,
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced section title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Template Features',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Compact grid with smaller cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0, // Make cards more square
              ),
              itemCount: templateCards.length,
              itemBuilder: (context, index) {
                final card = templateCards[index];
                return _buildCompactCard(
                  title: card['title'] as String,
                  description: card['description'] as String,
                  icon: card['icon'] as IconData,
                  color: card['color'] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Description
                Flexible(
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Enhanced section title
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (authProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[300],
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: authProvider.clearError,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Enhanced sign-in button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            try {
                              AppLogger.info(
                                'User clicked Google Sign-In button',
                              );
                              await context
                                  .read<AuthProvider>()
                                  .signInWithGoogle();
                              AppLogger.info(
                                'Google Sign-In process completed',
                              );
                            } catch (e) {
                              AppLogger.error('Google Sign-In error', e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Sign-in failed: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withValues(alpha: 0.2),
                    ),
                    icon: authProvider.isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey[600]!,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.g_mobiledata,
                            size: 18,
                            color: Colors.blue[600],
                          ),
                    label: Text(
                      authProvider.isLoading
                          ? 'Signing In...'
                          : 'Continue with Google',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Enhanced footer with better styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Text(
                    'Built with ❤️ using Flutter',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Version 1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.5),
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
