import 'package:flutter/material.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';

/// Screen: Language Selection (Step 2: Welcome -> Language -> Eligibility)
class LanguageSelectionScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const LanguageSelectionScreen({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final activeLanguage = context.currentLanguage;
    final strings = context.tr;

    return Scaffold(
      backgroundcolor: Appcolors.background,
      appBar: AppBar(
        backgroundcolor: colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Appcolors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Header
              Text(
                strings.chooseLanguageTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Appcolors.primaryDark,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.welcomeTagline,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Appcolors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Language Cards (English, Hindi, Hinglish)
              Expanded(
                child: ListView(
                  children: AppLanguage.values.map((lang) {
                    final isSelected = activeLanguage == lang;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Material(
                        color: isSelected ? Appcolors.primaryContainer : Appcolors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.radiusLg,
                          side: BorderSide(
                            color: isSelected ? Appcolors.primary : Appcolors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            context.setLanguage(lang);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Appcolors.primary
                                        : Appcolors.surfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      lang == AppLanguage.english
                                          ? 'A'
                                          : (lang == AppLanguage.hindi ? 'à¤…' : 'Aa'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Appcolors.onPrimary
                                            : Appcolors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.nativeName,
                                        style: AppTextStyles.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        lang.displayName,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Appcolors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Appcolors.primary,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Continue Button
              CustomButton(
                text: strings.continueBtn,
                onPressed: onContinue,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

