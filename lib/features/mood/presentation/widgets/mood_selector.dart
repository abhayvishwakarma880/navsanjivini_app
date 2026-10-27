import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../../domain/entities/mood_entry.dart';

class MoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final ValueChanged<MoodType> onSelectMood;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onSelectMood,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: MoodType.values.map((mood) {
        final isSelected = selectedMood == mood;
        return Material(
          color: isSelected ? Appcolors.primaryContainer : Appcolors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusLg,
            side: BorderSide(
              color: isSelected ? Appcolors.primary : Appcolors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => onSelectMood(mood),
            borderRadius: AppRadius.radiusLg,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Appcolors.primaryDark : Appcolors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

