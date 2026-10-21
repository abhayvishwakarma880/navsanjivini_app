import 'package:flutter/material.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import '../widgets/language_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const LanguageSelectionScreen({super.key, required this.onContinue});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  AppLanguage _selected = AppLanguage.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Language'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apni bhasha chunein',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Select the language you feel most comfortable expressing yourself in.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...AppLanguage.values.map(
                (lang) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: LanguageCard(
                    language: lang,
                    isSelected: _selected == lang,
                    onTap: () {
                      setState(() {
                        _selected = lang;
                      });
                    },
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue / Aage Badhein',
                onPressed: widget.onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
