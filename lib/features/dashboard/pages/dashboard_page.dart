import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🗣️ ',
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
                'SpeakBuddy',
                style: AppTheme.heading3.copyWith(
                  fontSize: AppTheme.getResponsiveFontSize(
                    context,
                    small: 20,
                    medium: 24,
                    large: 28,
                  ),
                  color: AppTheme.primaryTeal,
                ),
              ),
              Text(
                ' ✨',
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
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingM,
                medium: AppTheme.spacingL,
                large: AppTheme.spacingXL,
              ),
            ),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: Border.all(color: AppTheme.error, width: 2),
            ),
            child: IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: AppTheme.error,
                size: AppTheme.getResponsiveFontSize(
                  context,
                  small: 20,
                  medium: 24,
                  large: 28,
                ),
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
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.error),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(
              AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingM,
                medium: AppTheme.spacingL,
                large: AppTheme.spacingXL,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      AppTheme.getResponsiveSpacing(
                        context,
                        small: AppTheme.spacingL,
                        medium: AppTheme.spacingXL,
                        large: AppTheme.spacingXXL,
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                      boxShadow: [AppTheme.elevatedShadow],
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
                                      boxShadow: [AppTheme.subtleShadow],
                                    ),
                                    child: CircleAvatar(
                                      radius: AppTheme.getResponsiveSpacing(
                                        context,
                                        small: 30,
                                        medium: 35,
                                        large: 40,
                                      ),
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
                                              style: AppTheme.heading4.copyWith(
                                                fontSize:
                                                    AppTheme.getResponsiveFontSize(
                                                      context,
                                                      small: 24,
                                                      medium: 28,
                                                      large: 32,
                                                    ),
                                                color: AppTheme.primaryCoral,
                                              ),
                                            )
                                          : null,
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
                                  // Welcome text centered
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '🎉 ',
                                            style: TextStyle(
                                              fontSize:
                                                  AppTheme.getResponsiveFontSize(
                                                    context,
                                                    small: 16,
                                                    medium: 18,
                                                    large: 20,
                                                  ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Welcome to your speech journey!',
                                              style: AppTheme.bodyMedium.copyWith(
                                                fontSize:
                                                    AppTheme.getResponsiveFontSize(
                                                      context,
                                                      small: 14,
                                                      medium: 16,
                                                      large: 18,
                                                    ),
                                                color: Colors.white.withValues(
                                                  alpha: 0.95,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                                      Text(
                                        user.displayName ?? 'Speech Buddy',
                                        style: AppTheme.heading2.copyWith(
                                          fontSize:
                                              AppTheme.getResponsiveFontSize(
                                                context,
                                                small: 24,
                                                medium: 28,
                                                large: 32,
                                              ),
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (user.email != null) ...[
                                        SizedBox(
                                          height: AppTheme.getResponsiveSpacing(
                                            context,
                                            small: 4,
                                            medium: 6,
                                            large: 8,
                                          ),
                                        ),
                                        Text(
                                          user.email!,
                                          style: AppTheme.bodySmall.copyWith(
                                            fontSize:
                                                AppTheme.getResponsiveFontSize(
                                                  context,
                                                  small: 12,
                                                  medium: 14,
                                                  large: 16,
                                                ),
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                  // Avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [AppTheme.subtleShadow],
                                    ),
                                    child: CircleAvatar(
                                      radius: AppTheme.getResponsiveSpacing(
                                        context,
                                        small: 30,
                                        medium: 35,
                                        large: 40,
                                      ),
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
                                              style: AppTheme.heading4.copyWith(
                                                fontSize:
                                                    AppTheme.getResponsiveFontSize(
                                                      context,
                                                      small: 24,
                                                      medium: 28,
                                                      large: 32,
                                                    ),
                                                color: AppTheme.primaryCoral,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppTheme.getResponsiveSpacing(
                                      context,
                                      small: AppTheme.spacingM,
                                      medium: AppTheme.spacingL,
                                      large: AppTheme.spacingXL,
                                    ),
                                  ),
                                  // Welcome text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '🎉 ',
                                              style: TextStyle(
                                                fontSize:
                                                    AppTheme.getResponsiveFontSize(
                                                      context,
                                                      small: 16,
                                                      medium: 18,
                                                      large: 20,
                                                    ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Welcome to your speech journey!',
                                                style: AppTheme.bodyMedium.copyWith(
                                                  fontSize:
                                                      AppTheme.getResponsiveFontSize(
                                                        context,
                                                        small: 14,
                                                        medium: 16,
                                                        large: 18,
                                                      ),
                                                  color: Colors.white
                                                      .withValues(alpha: 0.95),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
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
                                        Text(
                                          user.displayName ?? 'Speech Buddy',
                                          style: AppTheme.heading2.copyWith(
                                            fontSize:
                                                AppTheme.getResponsiveFontSize(
                                                  context,
                                                  small: 24,
                                                  medium: 28,
                                                  large: 32,
                                                ),
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (user.email != null) ...[
                                          SizedBox(
                                            height:
                                                AppTheme.getResponsiveSpacing(
                                                  context,
                                                  small: 4,
                                                  medium: 6,
                                                  large: 8,
                                                ),
                                          ),
                                          Text(
                                            user.email!,
                                            style: AppTheme.bodySmall.copyWith(
                                              fontSize:
                                                  AppTheme.getResponsiveFontSize(
                                                    context,
                                                    small: 12,
                                                    medium: 14,
                                                    large: 16,
                                                  ),
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                      ],
                    ),
                  ),

                  SizedBox(
                    height: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingL,
                      medium: AppTheme.spacingXL,
                      large: AppTheme.spacingXXL,
                    ),
                  ),

                  // Speech Activities section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '🎯 ',
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
                                'Speech Activities',
                                style: AppTheme.heading3.copyWith(
                                  fontSize: AppTheme.getResponsiveFontSize(
                                    context,
                                    small: 20,
                                    medium: 24,
                                    large: 28,
                                  ),
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                ' 🎯',
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
                          SizedBox(
                            height: AppTheme.getResponsiveSpacing(
                              context,
                              small: AppTheme.spacingM,
                              medium: AppTheme.spacingL,
                              large: AppTheme.spacingXL,
                            ),
                          ),

                          // Action cards grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmallScreen = constraints.maxWidth < 600;
                              final crossAxisCount = isSmallScreen ? 1 : 2;
                              final childAspectRatio = isSmallScreen
                                  ? 1.2
                                  : 1.0;
                              final spacing = AppTheme.getResponsiveSpacing(
                                context,
                                small: AppTheme.spacingM,
                                medium: AppTheme.spacingL,
                                large: AppTheme.spacingXL,
                              );

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
                                    title: 'Story Adventure',
                                    description:
                                        'Embark on interactive storytelling with AI companions',
                                    icon: Icons.auto_stories,
                                    color: AppTheme.primaryCoral,
                                    emoji: '📚',
                                    onTap: () {
                                      final authProvider = context
                                          .read<AuthProvider>();
                                      if (authProvider.isAuthenticated &&
                                          authProvider.user != null) {
                                        Navigator.of(context).pushNamed(
                                          '/story-adventure',
                                          arguments: {
                                            'storyId': 'demo_story_1',
                                            'userId': authProvider.user!.uid,
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please sign in to access Story Adventure',
                                            ),
                                            backgroundColor: AppTheme.error,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  _buildActionCard(
                                    context,
                                    title: 'Voice Practice',
                                    description:
                                        'Practice pronunciation with real-time feedback',
                                    icon: Icons.mic,
                                    color: AppTheme.primaryTeal,
                                    emoji: '🎤',
                                    onTap: () {
                                      // TODO: Implement voice practice
                                    },
                                  ),
                                  _buildActionCard(
                                    context,
                                    title: 'Progress Tracker',
                                    description:
                                        'Monitor your speech development journey',
                                    icon: Icons.trending_up,
                                    color: AppTheme.primaryBlue,
                                    emoji: '📊',
                                    onTap: () {
                                      // TODO: Implement progress tracking
                                    },
                                  ),
                                  _buildActionCard(
                                    context,
                                    title: 'Fun Games',
                                    description:
                                        'Learn through engaging speech games',
                                    icon: Icons.games,
                                    color: AppTheme.primaryYellow,
                                    emoji: '🎮',
                                    onTap: () {
                                      // TODO: Implement speech games
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: AppTheme.getResponsiveSpacing(
                      context,
                      small: AppTheme.spacingL,
                      medium: AppTheme.spacingXL,
                      large: AppTheme.spacingXXL,
                    ),
                  ),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Ready to improve your speech?',
                          style: AppTheme.bodyMedium.copyWith(
                            fontSize: AppTheme.getResponsiveFontSize(
                              context,
                              small: 14,
                              medium: 16,
                              large: 18,
                            ),
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: AppTheme.getResponsiveSpacing(
                            context,
                            small: AppTheme.spacingS,
                            medium: AppTheme.spacingM,
                            large: AppTheme.spacingL,
                          ),
                        ),
                        Text(
                          'Start with Story Adventure! 🚀',
                          style: AppTheme.bodySmall.copyWith(
                            fontSize: AppTheme.getResponsiveFontSize(
                              context,
                              small: 12,
                              medium: 14,
                              large: 16,
                            ),
                            color: AppTheme.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: AppTheme.actionCardDecoration.copyWith(
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          child: Padding(
            padding: EdgeInsets.all(
              AppTheme.getResponsiveSpacing(
                context,
                small: AppTheme.spacingM,
                medium: AppTheme.spacingL,
                large: AppTheme.spacingXL,
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
                        small: AppTheme.spacingS,
                        medium: AppTheme.spacingM,
                        large: AppTheme.spacingL,
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
                    small: AppTheme.spacingM,
                    medium: AppTheme.spacingL,
                    large: AppTheme.spacingXL,
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
                    small: AppTheme.spacingS,
                    medium: AppTheme.spacingM,
                    large: AppTheme.spacingL,
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
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBackground,
          title: Text(
            'Sign Out',
            style: AppTheme.heading4.copyWith(color: AppTheme.textPrimary),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryTeal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthProvider>().signOut();
              },
              style: AppTheme.primaryButton.copyWith(
                backgroundColor: MaterialStateProperty.all(AppTheme.error),
              ),
              child: Text(
                'Sign Out',
                style: AppTheme.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
