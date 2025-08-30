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
          backgroundColor: const Color(0xFFF7FAFC),
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

                      // Feature cards section
                      _buildFeatureCards(),
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
            // App logo/icon with child-friendly styling
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withValues(alpha: 0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.record_voice_over,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            // App title with child-friendly typography
            Text(
              'SpeakBuddy',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D3748),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            // App subtitle with child-friendly messaging
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your AI-powered speech therapy companion for children aged 2-12',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF4A5568),
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

  Widget _buildFeatureCards() {
    final featureCards = [
      {
        'title': 'Child-Specific AI',
        'description':
            'Built exclusively for children\'s unique speech patterns and behaviors',
        'icon': Icons.psychology,
        'color': const Color(0xFFFF6B6B), // Bright coral
        'emoji': '🧠',
      },
      {
        'title': 'Gamified Learning',
        'description': 'Story-driven adventures and interactive challenges',
        'icon': Icons.games,
        'color': const Color(0xFF4ECDC4), // Bright teal
        'emoji': '🎮',
      },
      {
        'title': 'Professional Tools',
        'description': 'Seamless therapist-parent collaboration',
        'icon': Icons.people,
        'color': const Color(0xFF45B7D1), // Bright blue
        'emoji': '👥',
      },
      {
        'title': 'Cultural Inclusivity',
        'description': 'Supports diverse accents, dialects, and languages',
        'icon': Icons.language,
        'color': const Color(0xFFFFD93D), // Bright yellow
        'emoji': '🌍',
      },
      {
        'title': 'Privacy First',
        'description': 'COPPA-compliant with local processing capabilities',
        'icon': Icons.security,
        'color': const Color(0xFFFF8A80), // Bright red
        'emoji': '🔒',
      },
      {
        'title': 'Fun & Engaging',
        'description': 'Makes speech therapy enjoyable for children',
        'icon': Icons.celebration,
        'color': const Color(0xFFDDA0DD), // Bright plum
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
            // Enhanced section title with cartoon styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌟 ', style: TextStyle(fontSize: 28)),
                  Text(
                    'Why Choose SpeakBuddy?',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3748),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Text(' 🌟', style: TextStyle(fontSize: 28)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Responsive grid with enhanced cartoon-style cards
            LayoutBuilder(
              builder: (context, constraints) {
                // Use more columns on wider screens
                final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
                final childAspectRatio = constraints.maxWidth > 800
                    ? 1.2
                    : 0.85;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: featureCards.length,
                  itemBuilder: (context, index) {
                    final card = featureCards[index];
                    return _buildFeatureCard(
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

  Widget _buildFeatureCard({
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
                colors: [Colors.white, color.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji decoration
                      Text(emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),

                      // Icon container with enhanced styling
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.15),
                              color.withValues(alpha: 0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(icon, color: color, size: 26),
                      ),

                      const SizedBox(height: 14),

                      // Title
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Description
                      Flexible(
                        child: Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF4A5568),
                            height: 1.3,
                            fontWeight: FontWeight.w500,
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
          ),
        );
      },
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
                    'Start Your Speech Journey',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Join thousands of families improving speech together',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF4A5568),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                if (authProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[600],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: authProvider.clearError,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Enhanced sign-in button
                SizedBox(
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
                      backgroundColor: const Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: const Color(
                        0xFF6B73FF,
                      ).withValues(alpha: 0.3),
                    ),
                    icon: authProvider.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.g_mobiledata,
                            size: 20,
                            color: Colors.white,
                          ),
                    label: Text(
                      authProvider.isLoading
                          ? 'Signing In...'
                          : 'Continue with Google',
                      style: GoogleFonts.inter(
                        fontSize: 16,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Empowering children to find their voice',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF4A5568),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'SpeakBuddy v1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF718096),
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
