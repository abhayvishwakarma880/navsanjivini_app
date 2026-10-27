import 'package:flutter/material.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsViewModel _viewModel = SettingsViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeLanguage = context.currentLanguage;
    final strings = context.tr;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundcolor: Appcolors.background,
          appBar: AppBar(
            title: Text(strings.settingsTitle),
          ),
          body: SafeArea(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                // Language Selection Section
                Text(strings.languageSettingTitle, style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    color: Appcolors.surface,
                    borderRadius: AppRadius.radiusLg,
                    border: Border.all(color: Appcolors.border),
                  ),
                  child: Column(
                    children: AppLanguage.values.map((lang) {
                      final isSelected = activeLanguage == lang;
                      return ListTile(
                        onTap: () => context.setLanguage(lang),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundcolor: isSelected ? Appcolors.primary : Appcolors.surfaceVariant,
                          child: Text(
                            lang.code == 'hi' ? 'à¤…' : (lang.code == 'hi_en' ? 'à¤¹' : 'A'),
                            style: TextStyle(
                              color: isSelected ? colors.white : Appcolors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          lang.nativeName,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Appcolors.primaryDark : Appcolors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          lang.displayName,
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: Appcolors.primary)
                            : null,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text('Quiet Hours & Reminders', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                SettingsSwitchTile(
                  title: 'Daily Check-in Reminder',
                  subtitle: 'Gentle notification once a day',
                  value: _viewModel.dailyReminders,
                  onChanged: (val) => _viewModel.toggleDailyReminders(val),
                ),
                SettingsSwitchTile(
                  title: 'Quiet Hours (10 PM - 7 AM)',
                  subtitle: 'Mute all alerts and notifications during resting hours',
                  value: _viewModel.quietHoursEnabled,
                  onChanged: (val) => _viewModel.toggleQuietHours(val),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text('Accessibility', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                SettingsSwitchTile(
                  title: 'Haptic Feedback',
                  subtitle: 'Subtle vibrations during breathing and selections',
                  value: _viewModel.hapticFeedback,
                  onChanged: (val) => _viewModel.toggleHapticFeedback(val),
                ),
                SettingsSwitchTile(
                  title: 'High Contrast Mode',
                  subtitle: 'Enhance readability and visual boundaries',
                  value: _viewModel.highContrast,
                  onChanged: (val) => _viewModel.toggleHighContrast(val),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

