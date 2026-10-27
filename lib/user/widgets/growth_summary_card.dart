import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

class GrowthSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const GrowthSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Appcolors.surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: Appcolors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Appcolors.primaryContainer,
              borderRadius: AppRadius.radiusMd,
            ),
            child: Icon(icon, color: Appcolors.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.headlineSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

