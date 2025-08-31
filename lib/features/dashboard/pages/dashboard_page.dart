import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F9FF,
      ), // Brighter light blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🗣️ ', style: TextStyle(fontSize: 24)),
            Text(
              'SpeakBuddy',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E40AF),
              ),
            ),
            const Text(' ✨', style: TextStyle(fontSize: 24)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF6B6B), width: 2),
            ),
            child: IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: const Color(0xFFFF6B6B),
                size: 24,
              ),
              onPressed: () => _showSignOutDialog(context),
            ),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section with enhanced vibrant cartoon styling
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B), // Bright coral
                          Color(0xFF4ECDC4), // Bright teal
                          Color(0xFFFFD93D), // Bright yellow
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 35,
                          offset: const Offset(0, 18),
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                          blurRadius: 25,
                          offset: const Offset(8, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen = constraints.maxWidth < 400;
                            
                            if (isSmallScreen) {
                              // Stack layout for small screens
                              return Column(
                                children: [
                                  // Avatar centered
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      backgroundImage: user.photoURL != null
                                          ? NetworkImage(user.photoURL!)
                                          : null,
                                      child: user.photoURL == null
                                          ? Text(
                                              user.displayName
                                                      ?.substring(0, 1)
                                                      .toUpperCase() ??
                                                  user.email
                                                      ?.substring(0, 1)
                                                      .toUpperCase() ??
                                                  'U',
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF6B6B),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Welcome text centered
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '🎉 ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Welcome to your speech journey!',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: Colors.white.withValues(
                                                  alpha: 0.95,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        user.displayName ?? 'Speech Buddy',
                                        style: GoogleFonts.inter(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (user.email != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          user.email!,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              // Row layout for larger screens
                              return Row(
                                children: [
                                  // Enhanced avatar with cartoon styling
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      backgroundImage: user.photoURL != null
                                          ? NetworkImage(user.photoURL!)
                                          : null,
                                      child: user.photoURL == null
                                          ? Text(
                                              user.displayName
                                                      ?.substring(0, 1)
                                                      .toUpperCase() ??
                                                  user.email
                                                      ?.substring(0, 1)
                                                      .toUpperCase() ??
                                                  'U',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF6B6B),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              '🎉 ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Welcome to your speech journey!',
                                                style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  color: Colors.white.withValues(
                                                    alpha: 0.95,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          user.displayName ?? 'Speech Buddy',
                                          style: GoogleFonts.inter(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.1,
                                          ),
                                        ),
                                        if (user.email != null) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            user.email!,
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 28),
                        // Status indicator with cartoon styling
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ECDC4),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4ECDC4,
                                      ).withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Ready to practice! 🚀',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Speech therapy actions section with cartoon styling
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;
                      final titleSize = isSmallScreen ? 22.0 : 28.0;
                      final emojiSize = isSmallScreen ? 22.0 : 28.0;
                      
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🎯 ', style: TextStyle(fontSize: emojiSize)),
                          Flexible(
                            child: Text(
                              'Speech Activities',
                              style: GoogleFonts.inter(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E40AF),
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(' 🎯', style: TextStyle(fontSize: emojiSize)),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;
                      final crossAxisCount = isSmallScreen ? 1 : 2;
                      final spacing = isSmallScreen ? 16.0 : 24.0;
                      final childAspectRatio = isSmallScreen ? 1.3 : 1.1;
                      
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                        children: [
                      _buildActionCard(
                        context,
                        'Story Adventure',
                        Icons.auto_stories,
                        const Color(0xFFFF6B6B), // Bright coral
                        '📚',
                        () => Navigator.pushNamed(
                          context,
                          '/story-adventure',
                          arguments: {
                            'storyId': 'demo_story_1',
                            'userId': 'demo_user',
                          },
                        ),
                      ),
                      _buildActionCard(
                        context,
                        'Speech Games',
                        Icons.games,
                        const Color(0xFF4ECDC4), // Bright teal
                        '🎮',
                        () => _showComingSoon(context),
                      ),
                      _buildActionCard(
                        context,
                        'Progress',
                        Icons.trending_up,
                        const Color(0xFF45B7D1), // Bright blue
                        '📈',
                        () => _showComingSoon(context),
                      ),
                      _buildActionCard(
                        context,
                        'Parent Portal',
                        Icons.family_restroom,
                        const Color(0xFFFFD93D), // Bright yellow
                        '👨‍👩‍👧‍👦',
                        () => _showComingSoon(context),
                      ),
                    ],
                  );
                },

                  const SizedBox(height: 48),

                  // Enhanced footer with cartoon styling
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFF3E0).withValues(alpha: 0.9),
                          const Color(0xFFFFE0B2).withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFFB74D),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB74D).withValues(alpha: 0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen = constraints.maxWidth < 400;
                            final emojiSize1 = isSmallScreen ? 22.0 : 28.0;
                            final emojiSize2 = isSmallScreen ? 18.0 : 20.0;
                            final titleSize = isSmallScreen ? 16.0 : 18.0;
                            final subtitleSize = isSmallScreen ? 14.0 : 16.0;
                            
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('💫 ', style: TextStyle(fontSize: emojiSize1)),
                                    Flexible(
                                      child: Text(
                                        'Ready to start your speech adventure?',
                                        style: GoogleFonts.inter(
                                          fontSize: titleSize,
                                          color: const Color(0xFFE65100),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(' 💫', style: TextStyle(fontSize: emojiSize1)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('🎉 ', style: TextStyle(fontSize: emojiSize2)),
                                    Flexible(
                                      child: Text(
                                        'Choose an activity to begin practicing!',
                                        style: GoogleFonts.inter(
                                          fontSize: subtitleSize,
                                          color: const Color(0xFFBF360C),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(' 🎉', style: TextStyle(fontSize: emojiSize2)),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String emoji,
    VoidCallback onTap,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color.withValues(alpha: 0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji decoration
                      Text(emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 12),

                      // Icon container with enhanced styling
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.15),
                              color.withValues(alpha: 0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: color.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Icon(icon, color: color, size: 30),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Tap to start',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF4A5568),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text('🚪 ', style: TextStyle(fontSize: 24)),
            Text(
              'Sign Out',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF4A5568),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF4A5568),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            child: Text(
              'Sign Out',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🚧 ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                'This feature is coming soon!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
