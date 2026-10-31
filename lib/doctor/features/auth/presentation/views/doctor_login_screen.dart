import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:app/core/widgets/custom_text_field.dart';
import '../viewmodels/doctor_auth_viewmodel.dart';

/// Doctor Login Screen (Email + Password only).
class DoctorLoginScreen extends StatefulWidget {
  final DoctorAuthViewModel viewModel;
  final VoidCallback onAuthSuccess;
  final VoidCallback? onNavigateToUserLogin;

  const DoctorLoginScreen({
    super.key,
    required this.viewModel,
    required this.onAuthSuccess,
    this.onNavigateToUserLogin,
  });

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  DoctorAuthViewModel get vm => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () {
                if (widget.onNavigateToUserLogin != null) {
                  widget.onNavigateToUserLogin!();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Doctor Medical Emblem Header
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0284C7).withAlpha(25),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: Color(0xFF0284C7),
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Doctor Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0284C7).withAlpha(40)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: Color(0xFF0284C7),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Practitioner Portal',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0369A1),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Title
                    Text(
                      strings.doctorLoginTitle,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Subtitle
                    Text(
                      strings.doctorLoginSubtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Error Banner
                    if (vm.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: AppColors.error.withAlpha(50)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                vm.errorMessage!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Email Field
                    CustomTextField(
                      controller: vm.emailController,
                      labelText: strings.doctorEmailLabel,
                      hintText: strings.doctorEmailHint,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => vm.clearError(),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Password Field
                    CustomTextField(
                      controller: vm.passwordController,
                      labelText: strings.passwordLabel,
                      hintText: strings.passwordHint,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      obscureText: vm.obscurePassword,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => vm.clearError(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          vm.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: vm.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Doctor Login Button
                    CustomButton(
                      text: strings.doctorLoginBtn,
                      isLoading: vm.isLoading,
                      onPressed: () async {
                        final ok = await vm.login();
                        if (ok && mounted) {
                          widget.onAuthSuccess();
                        }
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Switch to User Login Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          strings.areYouAUser,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            if (widget.onNavigateToUserLogin != null) {
                              widget.onNavigateToUserLogin!();
                            } else if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            strings.switchToUserLogin,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

