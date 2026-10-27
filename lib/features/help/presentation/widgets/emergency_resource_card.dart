import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../../domain/entities/help_resource.dart';

class EmergencyResourceCard extends StatelessWidget {
  final HelpResource resource;
  final VoidCallback onCall;

  const EmergencyResourceCard({
    super.key,
    required this.resource,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Appcolors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
        side: const BorderSide(color: Appcolors.border),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resource.name,
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                if (resource.isTollFree)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Appcolors.successContainer,
                      borderRadius: AppRadius.radiusSm,
                    ),
                    child: Text(
                      'Toll Free',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Appcolors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              resource.description,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hours: ${resource.operatingHours}',
                  style: AppTextStyles.labelSmall.copyWith(color: Appcolors.textTertiary),
                ),
                TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: Text(resource.contactNumber),
                  style: TextButton.styleFrom(
                    foregroundcolor: Appcolors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

