import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import '../viewmodels/privacy_viewmodel.dart';
import '../widgets/consent_toggle_card.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final PrivacyViewModel _viewModel = PrivacyViewModel();

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
            title: const Text('Privacy & Consent'),
          ),
          body: SafeArea(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                Text('Data Control & Transparency', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You own your well-being data. You have full freedom to export or erase your data at any time.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ConsentToggleCard(
                  title: 'Store AI Conversations',
                  description: 'When disabled, conversation history is discarded immediately after closing the session.',
                  value: _viewModel.aiDataRetentionConsent,
                  onChanged: (val) => _viewModel.toggleAiDataRetention(val),
                ),
                const SizedBox(height: AppSpacing.xl),
                CustomButton(
                  text: 'Export My Data',
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Request Account & Data Deletion',
                  variant: ButtonVariant.secondary,
                  onPressed: () => _viewModel.requestAccountDeletion(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
