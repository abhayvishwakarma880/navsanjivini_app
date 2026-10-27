import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class IntensitySelector extends StatelessWidget {
  final int intensity;
  final ValueChanged<int> onIntensityChanged;

  const IntensitySelector({
    super.key,
    required this.intensity,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Intensity', style: AppTextStyles.titleMedium),
            Text(
              _getIntensityLabel(intensity),
              style: AppTextStyles.labelMedium.copyWith(color: Appcolors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final level = index + 1;
            final isSelected = level <= intensity;
            return Expanded(
              child: GestureDetector(
                onTap: () => onIntensityChanged(level),
                child: Container(
                  height: 38,
                  margin: EdgeInsets.only(
                    right: index < 4 ? AppSpacing.xs : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Appcolors.primary : Appcolors.surfaceVariant,
                    borderRadius: AppRadius.radiusSm,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$level',
                    style: TextStyle(
                      color: isSelected ? colors.white : Appcolors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  String _getIntensityLabel(int level) {
    return switch (level) {
      1 => 'Gentle',
      2 => 'Mild',
      3 => 'Moderate',
      4 => 'Noticeable',
      5 => 'Intense',
      _ => '',
    };
  }
}

