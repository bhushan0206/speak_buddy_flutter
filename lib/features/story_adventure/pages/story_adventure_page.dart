import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_adventure_provider.dart';
import '../models/story_models.dart';
import '../../../core/theme/app_theme.dart';

class StoryAdventurePage extends StatefulWidget {
  final String storyId;
  final String userId;

  const StoryAdventurePage({
    super.key,
    required this.storyId,
    required this.userId,
  });

  @override
  State<StoryAdventurePage> createState() => _StoryAdventurePageState();
}

class _StoryAdventurePageState extends State<StoryAdventurePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeStoryAdventure();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _initializeStoryAdventure() async {
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<StoryAdventureProvider>();
      await provider.startStoryAdventure(widget.storyId, widget.userId);
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
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: Consumer<StoryAdventureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.currentChapter == null) {
            return _buildLoadingScreen();
          }

          if (provider.errorMessage.isNotEmpty) {
            return _buildErrorScreen(provider);
          }

          if (provider.currentChapter == null) {
            return _buildNoChapterScreen();
          }

          return _buildStoryContent(provider);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryCoral.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryCoral, width: 2),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primaryCoral,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Use shorter title on small screens
          if (constraints.maxWidth < 300) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📚', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  'Story',
                  style: AppTheme.heading4.copyWith(
                    color: AppTheme.primaryCoral,
                  ),
                ),
              ],
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📚 ', style: TextStyle(fontSize: 24)),
              Text(
                'Story Adventure',
                style: AppTheme.heading4.copyWith(
                  color: AppTheme.primaryCoral,
                ),
              ),
              const Text(' ✨', style: TextStyle(fontSize: 24)),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryTeal, width: 2),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: AppTheme.primaryTeal,
              size: 20,
            ),
          ),
          onPressed: () => _showProgressDialog(context),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCoral.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Loading your story adventure...',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryCoral),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(StoryAdventureProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppTheme.error, width: 3),
              ),
              child: Icon(
                Icons.error_outline,
                color: AppTheme.error,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: AppTheme.heading3.copyWith(
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _initializeStoryAdventure(),
              icon: const Icon(Icons.refresh),
              label: Text(
                'Try Again',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryCoral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoChapterScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppTheme.primaryTeal, width: 3),
              ),
              child: Icon(
                Icons.book_outlined,
                color: AppTheme.primaryTeal,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No story chapter available',
              style: AppTheme.heading3.copyWith(
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please check back later or contact support.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(StoryAdventureProvider provider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Story Progress Section
              if (provider.userProgress != null) _buildProgressSection(provider),

              const SizedBox(height: 24),

              // Story Chapter Section
              if (provider.currentChapter != null) _buildChapterSection(provider),

              const SizedBox(height: 24),

              // AI Character Section
              if (provider.currentCharacter != null) _buildCharacterSection(provider),

              const SizedBox(height: 24),

              // Voice Practice Section
              if (provider.currentChapter != null) _buildVoiceSection(provider),

              const SizedBox(height: 32),

              // Story Navigation
              _buildStoryNavigation(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(StoryAdventureProvider provider) {
    final statistics = provider.getStoryStatistics();
    final achievements = provider.checkAchievements();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊 ', style: TextStyle(fontSize: 24)),
              Text(
                'Your Progress',
                style: AppTheme.heading4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem('Chapters', '${statistics['totalChapters'] ?? 0}'),
              _buildProgressItem('Words', '${statistics['totalWords'] ?? 0}'),
              _buildProgressItem('Accuracy', '${statistics['averageAccuracy'] ?? 0}%'),
            ],
          ),
          if (achievements.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '🏆 Achievements',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: achievements
                  .map((achievement) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          achievement,
                          style: AppTheme.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterSection(StoryAdventureProvider provider) {
    final chapter = provider.currentChapter!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📖 ', style: TextStyle(fontSize: 24)),
              Expanded(
                child: Text(
                  chapter.title,
                  style: AppTheme.heading4.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            chapter.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            chapter.content,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Target Words:',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: chapter.targetWords
                .map((word) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCoral.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primaryCoral,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        word,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryCoral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'What would you like to do?',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...chapter.choices.map((choice) => _buildChoiceButton(choice, provider)),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(StoryChoice choice, StoryAdventureProvider provider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () => provider.makeStoryChoice(choice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryTeal.withValues(alpha: 0.1),
          foregroundColor: AppTheme.primaryTeal,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: AppTheme.primaryTeal, width: 2),
        ),
        child: Text(
          choice.text,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCharacterSection(StoryAdventureProvider provider) {
    final character = provider.currentCharacter!;
    final lastResponse = provider.lastAIResponse;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤖 ', style: TextStyle(fontSize: 24)),
              Expanded(
                child: Text(
                  character.name,
                  style: AppTheme.heading4.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            character.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          if (lastResponse != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryCoral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryCoral,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${character.name} says:',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryCoral,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lastResponse.message,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildMessageInput(provider),
        ],
      ),
    );
  }

  Widget _buildMessageInput(StoryAdventureProvider provider) {
    final textController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Type a message to ${provider.currentCharacter?.name ?? 'your friend'}...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.primaryTeal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.primaryTeal, width: 2),
              ),
            ),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            if (textController.text.trim().isNotEmpty) {
              provider.getAIResponse(textController.text.trim());
              textController.clear();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
          child: const Icon(Icons.send, size: 20),
        ),
      ],
    );
  }

  Widget _buildVoiceSection(StoryAdventureProvider provider) {
    final lastResult = provider.lastVoiceResult;
    final targetWords = provider.currentChapter!.targetWords;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎤 ', style: TextStyle(fontSize: 24)),
              Text(
                'Voice Practice',
                style: AppTheme.heading4.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Practice saying these words: ${targetWords.join(', ')}',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => provider.processVoiceInput('demo_audio'),
            icon: const Icon(Icons.mic),
            label: Text(
              'Start Voice Practice',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCoral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (lastResult != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lastResult.isSuccess
                    ? AppTheme.primaryTeal.withValues(alpha: 0.1)
                    : AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: lastResult.isSuccess
                      ? AppTheme.primaryTeal
                      : AppTheme.error,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Recognition Result:',
                    style: AppTheme.bodyMedium.copyWith(
                      color: lastResult.isSuccess
                          ? AppTheme.primaryTeal
                          : AppTheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recognized: "${lastResult.recognizedText}"',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Confidence: ${(lastResult.confidence * 100).round()}%',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (lastResult.wordAccuracy.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Word Accuracy:',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...lastResult.wordAccuracy.entries.map(
                      (entry) => Text(
                        '${entry.key}: ${(entry.value * 100).round()}%',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoryNavigation(StoryAdventureProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Wrap for very small screens to prevent overflow
          if (constraints.maxWidth < 280) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildNavigationButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  color: AppTheme.primaryCoral,
                  onTap: () => _showResetDialog(context, provider),
                ),
                _buildNavigationButton(
                  icon: Icons.home,
                  label: 'Home',
                  color: AppTheme.primaryTeal,
                  onTap: () => Navigator.of(context).pop(),
                ),
                _buildNavigationButton(
                  icon: Icons.analytics,
                  label: 'Progress',
                  color: AppTheme.primaryTeal,
                  onTap: () => _showProgressDialog(context),
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavigationButton(
                icon: Icons.refresh,
                label: 'Reset',
                color: AppTheme.primaryCoral,
                onTap: () => _showResetDialog(context, provider),
              ),
              _buildNavigationButton(
                icon: Icons.home,
                label: 'Home',
                color: AppTheme.primaryTeal,
                onTap: () => Navigator.of(context).pop(),
              ),
              _buildNavigationButton(
                icon: Icons.analytics,
                label: 'Progress',
                color: AppTheme.primaryTeal,
                onTap: () => _showProgressDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust padding based on available width
        final isSmallScreen = constraints.maxWidth < 300;
        final horizontalPadding = isSmallScreen ? 8.0 : 16.0;
        final iconSize = isSmallScreen ? 20.0 : 24.0;
        final fontSize = isSmallScreen ? 12.0 : 14.0;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: iconSize),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context, StoryAdventureProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text('🔄 ', style: TextStyle(fontSize: 24)),
            Text(
              'Reset Story Progress',
              style: AppTheme.heading4.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to reset your story progress? This will start the story from the beginning.',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
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
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.resetStoryProgress();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryCoral,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Reset',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressDialog(BuildContext context) {
    final provider = context.read<StoryAdventureProvider>();
    final statistics = provider.getStoryStatistics();
    final achievements = provider.checkAchievements();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text('📊 ', style: TextStyle(fontSize: 24)),
            Text(
              'Story Progress',
              style: AppTheme.heading4.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressItem(
                'Chapters Completed',
                '${statistics['totalChapters'] ?? 0}',
              ),
              _buildProgressItem(
                'Words Practiced',
                '${statistics['totalWords'] ?? 0}',
              ),
              _buildProgressItem(
                'Average Accuracy',
                '${statistics['averageAccuracy'] ?? 0}%',
              ),
              _buildProgressItem(
                'Total Play Time',
                '${statistics['totalPlayTime'] ?? 0} min',
              ),
              if (achievements.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '🏆 Achievements',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...achievements.map(
                  (achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      achievement,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Close',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
