import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import '../models/user_preferences.dart';
import '../../../core/theme/app_theme.dart';

class UserPreferencesPage extends StatefulWidget {
  final String userId;

  const UserPreferencesPage({super.key, required this.userId});

  @override
  State<UserPreferencesPage> createState() => _UserPreferencesPageState();
}

class _UserPreferencesPageState extends State<UserPreferencesPage> {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  UserPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      setState(() => _isLoading = true);
      final preferences = await _preferencesService.getUserPreferences(
        widget.userId,
      );
      setState(() {
        _preferences = preferences;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading preferences: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _updateAge(int newAge) async {
    try {
      await _preferencesService.updateUserAge(widget.userId, newAge);
      await _loadUserPreferences();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Age updated successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating age: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _updateDifficulty(String difficulty) async {
    try {
      await _preferencesService.updatePreferredDifficulty(
        widget.userId,
        difficulty,
      );
      await _loadUserPreferences();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Difficulty updated successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating difficulty: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _addInterest(String interest) async {
    if (interest.trim().isEmpty) return;

    try {
      await _preferencesService.addInterest(widget.userId, interest.trim());
      await _loadUserPreferences();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added interest: ${interest.trim()}'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding interest: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
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
        title: Text(
          'AI Content Preferences',
          style: AppTheme.heading4.copyWith(color: AppTheme.primaryCoral),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _preferences == null
          ? _buildErrorState()
          : _buildPreferencesContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppTheme.error, size: 64),
          const SizedBox(height: 16),
          Text(
            'Failed to load preferences',
            style: AppTheme.heading4.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserPreferences,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🎯 Speech Goals'),
          _buildSpeechGoalsSection(),

          const SizedBox(height: 24),

          _buildSectionHeader('👤 Personal Information'),
          _buildPersonalInfoSection(),

          const SizedBox(height: 24),

          _buildSectionHeader('🌟 Interests'),
          _buildInterestsSection(),

          const SizedBox(height: 24),

          _buildSectionHeader('📊 AI Content Settings'),
          _buildAISettingsSection(),

          const SizedBox(height: 32),

          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTheme.heading4.copyWith(
          color: AppTheme.primaryCoral,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSpeechGoalsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        children: [
          _buildGoalItem(
            'Pronunciation',
            _preferences!.speechGoals['pronunciation'] ?? false,
          ),
          _buildGoalItem(
            'Vocabulary',
            _preferences!.speechGoals['vocabulary'] ?? false,
          ),
          _buildGoalItem(
            'Fluency',
            _preferences!.speechGoals['fluency'] ?? false,
          ),
          _buildGoalItem(
            'Confidence',
            _preferences!.speechGoals['confidence'] ?? false,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String goal, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isEnabled ? AppTheme.success : AppTheme.textSecondary,
          ),
          const SizedBox(width: 12),
          Text(
            goal,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Column(
        children: [
          _buildAgeSelector(),
          const SizedBox(height: 16),
          _buildDifficultySelector(),
        ],
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Row(
      children: [
        Icon(Icons.person, color: AppTheme.primaryTeal),
        const SizedBox(width: 12),
        Text(
          'Age: ',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        DropdownButton<int>(
          value: _preferences!.age,
          onChanged: (int? newAge) {
            if (newAge != null) {
              _updateAge(newAge);
            }
          },
          items: List.generate(11, (index) => index + 2)
              .map(
                (age) => DropdownMenuItem<int>(value: age, child: Text('$age')),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: [
        Icon(Icons.speed, color: AppTheme.primaryTeal),
        const SizedBox(width: 12),
        Text(
          'Difficulty: ',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        DropdownButton<String>(
          value: _preferences!.preferredDifficulty,
          onChanged: (String? newDifficulty) {
            if (newDifficulty != null) {
              _updateDifficulty(newDifficulty);
            }
          },
          items: ['easy', 'medium', 'hard']
              .map(
                (difficulty) => DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty.toUpperCase()),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
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
          _buildAddInterestField(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _preferences!.interests
                .map((interest) => _buildInterestChip(interest))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddInterestField() {
    final textController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Add a new interest...',
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
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            _addInterest(textController.text);
            textController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String interest) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryCoral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryCoral, width: 1),
      ),
      child: Text(
        interest,
        style: AppTheme.bodyMedium.copyWith(
          color: AppTheme.primaryCoral,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAISettingsSection() {
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
          Text(
            'AI Content Generation',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your preferences, AI will generate personalized story content, characters, and responses.',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppTheme.primaryYellow),
              const SizedBox(width: 12),
              Text(
                'Personalized Content: Enabled',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
              const Text('💡 ', style: TextStyle(fontSize: 24)),
              Text(
                'How AI Content Works',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• AI generates unique stories based on your age and interests\n'
            '• Content adapts to your speech development progress\n'
            '• Characters respond personally to your messages\n'
            '• All content is stored for other users to enjoy\n'
            '• Your progress is tracked to avoid repetition',
            style: AppTheme.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
