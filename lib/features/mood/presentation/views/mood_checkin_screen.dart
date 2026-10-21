import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import '../../domain/entities/mood_entry.dart';
import '../widgets/intensity_selector.dart';
import '../widgets/mood_selector.dart';

class MoodCheckinScreen extends StatefulWidget {
  final VoidCallback onSaved;

  const MoodCheckinScreen({super.key, required this.onSaved});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  MoodType? _selectedMood;
  int _intensity = 3;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mood Check-in'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are you feeling right now?',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Acknowledge what is present without trying to fix or evaluate it.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Mood Selector
              MoodSelector(
                selectedMood: _selectedMood,
                onSelectMood: (mood) {
                  setState(() => _selectedMood = mood);
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Intensity Selector
              if (_selectedMood != null) ...[
                IntensitySelector(
                  intensity: _intensity,
                  onIntensityChanged: (val) {
                    setState(() => _intensity = val);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Optional note / context
              Text('Add a note (optional)', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What is bringing this feeling today?',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Save button
              CustomButton(
                text: 'Save Check-in',
                onPressed: _selectedMood != null ? widget.onSaved : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
