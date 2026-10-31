import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../viewmodels/progress_viewmodel.dart';
import '../widgets/growth_summary_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ProgressViewModel();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Growth & Well-being'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            Text('Reflective Milestones', style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Gentle insights into your daily pauses and mindful reflections.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            GrowthSummaryCard(
              title: 'Check-ins logged',
              value: '${viewModel.checkinsThisWeek} days this week',
              icon: Icons.favorite_border_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            GrowthSummaryCard(
              title: 'Mindful Breathing',
              value: '${viewModel.pauseMinutes} mins completed',
              icon: Icons.air_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            GrowthSummaryCard(
              title: 'Journal reflections',
              value: '${viewModel.journalEntriesCount} entries saved privately',
              icon: Icons.edit_note_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
