import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../models/story_models.dart';

class StoryProgressWidget extends StatelessWidget {
  final StoryProgress progress;
  final VoidCallback? onReset;

  const StoryProgressWidget({
    super.key,
    required this.progress,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: AppTheme.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onReset != null)
                IconButton(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'Reset Progress',
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress bar
          LinearProgressIndicator(
            value: progress.completedChapters.length / 10, // Assuming 10 total chapters
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
            minHeight: 12,
          ),
          
          const SizedBox(height: 12),
          
          // Progress details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.completedChapters.length} of 10 chapters',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${((progress.completedChapters.length / 10) * 100).round()}%',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.primaryYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Achievements
          if (progress.achievements.isNotEmpty) ...[
            Text(
              'Achievements',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: progress.achievements.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.primaryBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
