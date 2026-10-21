import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../widgets/action_card.dart';
import '../widgets/daily_thought_card.dart';
import '../widgets/quick_checkin_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToMood;
  final VoidCallback onNavigateToTalk;
  final VoidCallback onNavigateToPause;
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToHelp;

  const HomeScreen({
    super.key,
    required this.onNavigateToMood,
    required this.onNavigateToTalk,
    required this.onNavigateToPause,
    required this.onNavigateToExplore,
    required this.onNavigateToHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Namaste 🙏',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              'Navsanjivini',
              style: AppTextStyles.headlineSmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Safety & Help',
            onPressed: onNavigateToHelp,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Quick Check-in Card
              QuickCheckinCard(onStartCheckin: onNavigateToMood),
              const SizedBox(height: AppSpacing.lg),

              // 4 Core Action Cards (Talk, Pause, Explore, Help)
              Text(
                'Explore Support',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.15,
                children: [
                  ActionCard(
                    title: 'AI Talk',
                    subtitle: 'Safe, private chat',
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: AppColors.primary,
                    onTap: onNavigateToTalk,
                  ),
                  ActionCard(
                    title: 'Pause & Relax',
                    subtitle: 'Breathing & grounding',
                    icon: Icons.air_rounded,
                    iconColor: AppColors.info,
                    onTap: onNavigateToPause,
                  ),
                  ActionCard(
                    title: 'Explore',
                    subtitle: 'Self-help guides',
                    icon: Icons.menu_book_rounded,
                    iconColor: AppColors.warning,
                    onTap: onNavigateToExplore,
                  ),
                  ActionCard(
                    title: 'Help',
                    subtitle: 'Emergency helplines',
                    icon: Icons.support_agent_rounded,
                    iconColor: AppColors.error,
                    onTap: onNavigateToHelp,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Daily Thought
              const DailyThoughtCard(
                thought: 'You do not have to control your thoughts. You just have to stop letting them control you.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
