import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../models/story_models.dart';

class VoiceInteractionWidget extends StatefulWidget {
  final List<String> targetWords;
  final Function(VoiceRecognitionResult) onVoiceResult;
  final bool isRecording;

  const VoiceInteractionWidget({
    super.key,
    required this.targetWords,
    required this.onVoiceResult,
    this.isRecording = false,
  });

  @override
  State<VoiceInteractionWidget> createState() => _VoiceInteractionWidgetState();
}

class _VoiceInteractionWidgetState extends State<VoiceInteractionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _animationController.repeat(reverse: true);

    // Simulate voice recognition after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _stopListening();
        _simulateVoiceResult();
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
    _animationController.reset();
  }

  void _simulateVoiceResult() {
    // Simulate a voice recognition result
    final result = VoiceRecognitionResult(
      recognizedText: widget.targetWords.first,
      targetWords: widget.targetWords,
      confidence: 0.9,
      wordAccuracy: {widget.targetWords.first: 0.85},
      isSuccess: true,
    );
    widget.onVoiceResult(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: _isListening ? AppTheme.primaryTeal : AppTheme.primaryPurple,
          width: 2,
        ),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.mic,
                color: _isListening
                    ? AppTheme.primaryTeal
                    : AppTheme.primaryPurple,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Voice Practice',
                style: AppTheme.heading4.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Target Words Display
          Text(
            'Practice these words:',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.targetWords.map((word) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(color: AppTheme.primaryPurple, width: 1),
                ),
                child: Text(
                  word,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Recording Button
          Center(
            child: GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _isListening
                            ? AppTheme.primaryGradient
                            : LinearGradient(
                                colors: [
                                  AppTheme.primaryPurple,
                                  AppTheme.primaryTeal,
                                ],
                              ),
                        boxShadow: [AppTheme.elevatedShadow],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Status Text
          Center(
            child: Text(
              _isListening
                  ? 'Listening... Speak now!'
                  : 'Tap to start recording',
              style: AppTheme.bodyMedium.copyWith(
                color: _isListening
                    ? AppTheme.primaryTeal
                    : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (_isListening) ...[
            const SizedBox(height: AppTheme.spacingM),
            Center(
              child: Text(
                '🎤 Recording in progress...',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.primaryTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
