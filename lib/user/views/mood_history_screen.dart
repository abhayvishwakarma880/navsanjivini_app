import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundcolor: Appcolors.background,
      appBar: AppBar(
        title: const Text('Mood Log & History'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.dialogPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 48,
                  color: Appcolors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your Check-in History',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Track patterns and emotional awareness over time. Remember, feelings come and go.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: Appcolors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

