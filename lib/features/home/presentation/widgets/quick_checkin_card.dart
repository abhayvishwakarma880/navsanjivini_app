import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class QuickCheckinCard extends StatelessWidget {
  final VoidCallback onStartCheckin;

  const QuickCheckinCard({super.key, required this.onStartCheckin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Appcolors.primaryContainer,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Appcolors.primary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'How are you feeling right now?',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Appcolors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Check in with yourself. No judgment, no scores â€” just a gentle pause.',
            style: AppTextStyles.bodySmall.copyWith(
              color: Appcolors.primaryDark.withAlpha(200),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: onStartCheckin,
            style: ElevatedButton.styleFrom(
              backgroundcolor: Appcolors.primary,
              foregroundcolor: Appcolors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.radiusMd,
              ),
            ),
            child: const Text('Start Daily Check-in'),
          ),
        ],
      ),
    );
  }
}

