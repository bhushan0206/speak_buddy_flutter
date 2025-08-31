import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../models/story_models.dart';

class AICharacterWidget extends StatelessWidget {
  final AICharacter character;
  final bool isActive;
  final VoidCallback? onTap;

  const AICharacterWidget({
    super.key,
    required this.character,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryTeal.withValues(alpha: 0.2) : AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: isActive ? AppTheme.primaryTeal : Colors.transparent,
            width: 2,
          ),
          boxShadow: [AppTheme.subtleShadow],
        ),
        child: Row(
          children: [
            // Character Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
                boxShadow: [AppTheme.elevatedShadow],
              ),
              child: character.avatarUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        character.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 30,
                            color: AppTheme.textPrimary,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 30,
                      color: AppTheme.textPrimary,
                    ),
            ),
            
            const SizedBox(width: AppTheme.spacingM),
            
            // Character Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: AppTheme.heading4.copyWith(
                      color: isActive ? AppTheme.primaryTeal : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      character.personality,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Active indicator
            if (isActive)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryTeal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
