import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';

/// Screen: Home / Today Dashboard (Tab 1)
/// Follows the Navsanjivini Blueprint layout.
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToMood;
  final VoidCallback onNavigateToTalk;
  final VoidCallback onNavigateToPause;
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToHelp;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.onNavigateToMood,
    required this.onNavigateToTalk,
    required this.onNavigateToPause,
    required this.onNavigateToExplore,
    required this.onNavigateToHelp,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xs),

              // Top Bar: Greeting & How are you feeling + Top-Right Circular Profile Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.helloThere,
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          strings.howAreYouFeeling,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Top-Right Circular Profile Button
                  InkWell(
                    onTap: onNavigateToProfile,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withAlpha(40),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Mood Check-in Card (Take a moment for yourself)
              _buildMoodCheckinCard(strings),
              const SizedBox(height: AppSpacing.xl),

              // Section: What would help right now?
              Text(
                strings.whatWouldHelpRightNow,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4 Action Prompt Cards (Talk, Pause, Explore, Find Support)
              _buildActionGrid(strings),
              const SizedBox(height: AppSpacing.xl),

              // A gentle thought (Reflection Card)
              _buildGentleThoughtCard(strings),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// Mood Check-in Card
  Widget _buildMoodCheckinCard(dynamic strings) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.primary.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  strings.takeMomentForYourself,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            strings.noRightOrWrongWay,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryDark.withAlpha(200),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: onNavigateToMood,
            borderRadius: AppRadius.radiusMd,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.radiusMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    strings.checkInWithMood,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4 Action Grid Cards
  Widget _buildActionGrid(dynamic strings) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.15,
      children: [
        _ActionPromptCard(
          title: strings.talkItOutTitle,
          subtitle: strings.talkItOutSubtitle,
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: AppColors.primary,
          onTap: onNavigateToTalk,
        ),
        _ActionPromptCard(
          title: strings.takePauseTitle,
          subtitle: strings.takePauseSubtitle,
          icon: Icons.air_rounded,
          iconColor: AppColors.info,
          onTap: onNavigateToPause,
        ),
        _ActionPromptCard(
          title: strings.exploreTitle,
          subtitle: strings.exploreSubtitle,
          icon: Icons.menu_book_rounded,
          iconColor: AppColors.warning,
          onTap: onNavigateToExplore,
        ),
        _ActionPromptCard(
          title: strings.findSupportTitle,
          subtitle: strings.findSupportSubtitle,
          icon: Icons.support_agent_rounded,
          iconColor: AppColors.error,
          onTap: onNavigateToHelp,
        ),
      ],
    );
  }

  /// A gentle thought card
  Widget _buildGentleThoughtCard(dynamic strings) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.gentleThoughtTitle,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.gentleThoughtQuote,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPromptCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionPromptCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
