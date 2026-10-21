import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:app/core/widgets/custom_text_field.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/profile_item_tile.dart';

/// Screen: Profile & Settings (Accessible from Home top-right icon)
/// Conforms to the Navsanjivini Blueprint specification.
class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onNavigateToPrivacy;
  final VoidCallback onNavigateToSettings;

  const ProfileScreen({
    super.key,
    required this.onLogout,
    required this.onNavigateToPrivacy,
    required this.onNavigateToSettings,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(text: _viewModel.displayName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.tr.editProfileTitle,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.tr.personalInfoSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                controller: nameController,
                labelText: context.tr.nameLabel,
                hintText: context.tr.nameHint,
                prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomButton(
                text: context.tr.saveBtn,
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    _viewModel.updateName(newName);
                  }
                  Navigator.of(sheetCtx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: Row(
          children: [
            const Icon(Icons.file_download_outlined, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(context.tr.downloadDataTitle)),
          ],
        ),
        content: const Text(
          'Your data privacy is guaranteed. An encrypted archive of your journal, mood history, and settings will be prepared and exported to your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(context.tr.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export request submitted securely.'),
                ),
              );
            },
            child: const Text('Export Now'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                context.tr.deleteAccountTitle,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
        content: Text(context.tr.confirmDeleteAccountDialog),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(context.tr.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              widget.onLogout();
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: Text(context.tr.logOutTitle),
        content: Text(context.tr.confirmLogOutDialog),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(context.tr.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              widget.onLogout();
            },
            child: Text(context.tr.logOutTitle),
          ),
        ],
      ),
    );
  }

  void _showHelpAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: context.tr.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 36),
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(context.tr.clinicalDisclaimer),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(strings.yourProfileTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                // User Info Summary Card
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusLg,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(
                          _viewModel.displayName.isNotEmpty
                              ? _viewModel.displayName[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _viewModel.displayName,
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              strings.manageAccountSubtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                        tooltip: strings.editProfileTitle,
                        onPressed: () => _showEditProfileSheet(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Section 1: Account & Profile
                _buildSectionHeader('Account & Details'),
                Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusLg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ProfileItemTile(
                        icon: Icons.person_outline_rounded,
                        title: strings.personalInfoTitle,
                        subtitle: strings.personalInfoSubtitle,
                        onTap: () => _showEditProfileSheet(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Section 2: Preferences & Notifications
                _buildSectionHeader('Preferences & Notifications'),
                Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusLg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ProfileItemTile(
                        icon: Icons.translate_rounded,
                        title: strings.preferencesTitle,
                        subtitle: strings.preferencesSubtitle,
                        onTap: widget.onNavigateToSettings,
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.notifications_none_rounded,
                        title: strings.notificationsTitle,
                        subtitle: strings.notificationsSubtitle,
                        onTap: widget.onNavigateToSettings,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Section 3: Privacy, Data & Rights
                _buildSectionHeader('Privacy & Data Rights'),
                Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusLg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ProfileItemTile(
                        icon: Icons.shield_outlined,
                        title: strings.privacyConsentTitle,
                        subtitle: strings.privacyConsentSubtitle,
                        onTap: widget.onNavigateToPrivacy,
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.file_download_outlined,
                        title: strings.downloadDataTitle,
                        subtitle: strings.downloadDataSubtitle,
                        onTap: () => _showDownloadDataDialog(context),
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.delete_outline_rounded,
                        title: strings.deleteAccountTitle,
                        subtitle: strings.deleteAccountSubtitle,
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Section 4: Help, About & Logout
                _buildSectionHeader('Support & Session'),
                Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusLg,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ProfileItemTile(
                        icon: Icons.info_outline_rounded,
                        title: strings.helpAboutTitle,
                        subtitle: strings.helpAboutSubtitle,
                        onTap: () => _showHelpAboutDialog(context),
                      ),
                      const Divider(height: 1, indent: 56),
                      ProfileItemTile(
                        icon: Icons.logout_rounded,
                        title: strings.logOutTitle,
                        subtitle: strings.logOutSubtitle,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
