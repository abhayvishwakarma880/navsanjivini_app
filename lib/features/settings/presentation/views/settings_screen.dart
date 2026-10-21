import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Settings & Accessibility'),
          ),
          body: SafeArea(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
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
