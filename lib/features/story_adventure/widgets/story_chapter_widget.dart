import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../models/story_models.dart';

class StoryChapterWidget extends StatelessWidget {
  final StoryChapter chapter;
  final Function(String) onChoiceSelected;
  final bool isCompleted;

  const StoryChapterWidget({
    super.key,
    required this.chapter,
    required this.onChoiceSelected,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: isCompleted ? AppTheme.success : AppTheme.primaryTeal,
          width: 2,
        ),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCompleted ? AppTheme.success : AppTheme.primaryTeal,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Text(
                  'Chapter ${chapter.id}',
                  style: AppTheme.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Text(
                  chapter.title,
                  style: AppTheme.heading3.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isCompleted)
                Icon(Icons.check_circle, color: AppTheme.success, size: 24),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Chapter Description
          if (chapter.description.isNotEmpty) ...[
            Text(
              chapter.description,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],

          // Chapter Content
          Text(
            chapter.content,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Target Words
          if (chapter.targetWords.isNotEmpty) ...[
            Text(
              '🎯 Target Words to Practice:',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chapter.targetWords.map((word) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(color: AppTheme.primaryYellow, width: 1),
                  ),
                  child: Text(
                    word,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],

          // Story Choices
          if (chapter.choices.isNotEmpty) ...[
            Text(
              'What would you like to do?',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...chapter.choices.map((choice) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                child: ElevatedButton(
                  onPressed: () => onChoiceSelected(choice.id),
                  style: AppTheme.primaryButton.copyWith(
                    backgroundColor: WidgetStateProperty.all(
                      AppTheme.primaryTeal.withValues(alpha: 0.8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Text(
                      choice.text,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
