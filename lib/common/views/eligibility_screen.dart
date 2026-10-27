import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';

/// Screen 2: 18+ Eligibility, Privacy Notice, AI Limitations & Consent
class EligibilityScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const EligibilityScreen({super.key, required this.onContinue});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  bool _is18Plus = false;
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    final canProceed = _is18Plus && _consentGiven;
    final strings = context.tr;

    return Scaffold(
      backgroundcolor: Appcolors.background,
      appBar: AppBar(
        title: Text(strings.safetyConsentTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text(
                strings.trustAndEligibilityHeader,
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.trustAndEligibilitySubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Appcolors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 18+ Confirmation Card
              Material(
                color: _is18Plus ? Appcolors.primaryContainer : Appcolors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.radiusLg,
                  side: BorderSide(
                    color: _is18Plus ? Appcolors.primary : Appcolors.border,
                    width: _is18Plus ? 1.8 : 1,
                  ),
                ),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  value: _is18Plus,
                  activecolor: Appcolors.primary,
                  title: Text(
                    strings.ageConfirmationTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _is18Plus ? Appcolors.primaryDark : Appcolors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    strings.ageConfirmationSubtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                  onChanged: (val) {
                    setState(() => _is18Plus = val ?? false);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Consent & AI Limitations Card
              Material(
                color: _consentGiven ? Appcolors.primaryContainer : Appcolors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.radiusLg,
                  side: BorderSide(
                    color: _consentGiven ? Appcolors.primary : Appcolors.border,
                    width: _consentGiven ? 1.8 : 1,
                  ),
                ),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  value: _consentGiven,
                  activecolor: Appcolors.primary,
                  title: Text(
                    strings.consentTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _consentGiven ? Appcolors.primaryDark : Appcolors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    strings.consentSubtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                  onChanged: (val) {
                    setState(() => _consentGiven = val ?? false);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Clinical Disclaimer Banner
              Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: Appcolors.surfaceVariant,
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(color: Appcolors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Appcolors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        strings.clinicalDisclaimer,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Appcolors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue Button
              CustomButton(
                text: strings.agreeAndContinue,
                onPressed: canProceed ? widget.onContinue : null,
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}

