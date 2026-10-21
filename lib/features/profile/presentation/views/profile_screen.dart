import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/profile_item_tile.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onNavigateToPrivacy;
  final VoidCallback onNavigateToSettings;

  const ProfileScreen({
    super.key,
    required this.onNavigateToPrivacy,
    required this.onNavigateToSettings,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = ProfileViewModel();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile & Preferences'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  viewModel.displayName.substring(0, 1).toUpperCase(),
                  style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                viewModel.displayName,
                style: AppTextStyles.headlineMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ProfileItemTile(
              icon: Icons.shield_outlined,
              title: 'Privacy & Data Controls',
              subtitle: 'Consent status, export data, deletion',
              onTap: onNavigateToPrivacy,
            ),
            ProfileItemTile(
              icon: Icons.tune_rounded,
              title: 'Settings & Quiet Hours',
              subtitle: 'Notifications and accessibility',
              onTap: onNavigateToSettings,
            ),
          ],
        ),
      ),
    );
  }
}
