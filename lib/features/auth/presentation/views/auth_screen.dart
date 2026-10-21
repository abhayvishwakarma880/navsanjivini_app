import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_radius.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:app/core/widgets/custom_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Screen 3: User Authentication (Login / Register flow)
class AuthScreen extends StatefulWidget {
  final AuthViewModel viewModel;
  final VoidCallback onAuthSuccess;

  const AuthScreen({
    super.key,
    required this.viewModel,
    required this.onAuthSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthViewModel get vm => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Branded Logo Header
                    Center(
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(20),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // App Title
                    Text(
                      strings.appName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Subtitle based on mode
                    Text(
                      vm.authMode == AuthMode.login
                          ? strings.loginSubtitle
                          : strings.registerSubtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Tab Segmented Control (Login vs Register)
                    _buildModeTabs(strings),
                    const SizedBox(height: AppSpacing.lg),

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

                    // Success Banner
                    if (vm.successMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: AppColors.primary.withAlpha(50)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                vm.successMessage!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Mode Form
                    if (vm.authMode == AuthMode.login)
                      _buildLoginForm(strings)
                    else
                      _buildRegisterFlow(strings),

                    const SizedBox(height: AppSpacing.xl),

                    // Switch Mode Footer
                    _buildSwitchModeFooter(strings),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Segmented Tab Switcher
  Widget _buildModeTabs(dynamic strings) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: strings.loginTab,
              isSelected: vm.authMode == AuthMode.login,
              onTap: () => vm.toggleAuthMode(AuthMode.login),
            ),
          ),
          Expanded(
            child: _TabButton(
              title: strings.registerTab,
              isSelected: vm.authMode == AuthMode.register,
              onTap: () => vm.toggleAuthMode(AuthMode.register),
            ),
          ),
        ],
      ),
    );
  }

  /// Existing User Login Form
  Widget _buildLoginForm(dynamic strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: vm.loginPhoneController,
          labelText: strings.mobileNumberLabel,
          hintText: strings.mobileNumberHint,
          prefixText: '+91 ',
          prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: vm.loginPasswordController,
          labelText: strings.passwordLabel,
          hintText: strings.passwordHint,
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
          obscureText: vm.obscureLoginPassword,
          suffixIcon: IconButton(
            icon: Icon(
              vm.obscureLoginPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: vm.toggleLoginPasswordVisibility,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          text: strings.loginBtn,
          isLoading: vm.isLoading,
          onPressed: () async {
            final ok = await vm.login();
            if (ok && mounted) {
              widget.onAuthSuccess();
            }
          },
        ),
      ],
    );
  }

  /// New User Register Flow (Step 1 -> Step 2 -> Step 3)
  Widget _buildRegisterFlow(dynamic strings) {
    return switch (vm.registerStep) {
      RegisterStep.enterPhone => _buildRegisterPhoneStep(strings),
      RegisterStep.verifyOtp => _buildRegisterOtpStep(strings),
      RegisterStep.createPassword => _buildRegisterPasswordStep(strings),
    };
  }

  /// Register Step 1: Name & Phone Number
  Widget _buildRegisterPhoneStep(dynamic strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: vm.registerNameController,
          labelText: strings.nameLabel,
          hintText: strings.nameHint,
          prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: vm.registerPhoneController,
          labelText: strings.mobileNumberLabel,
          hintText: strings.mobileNumberHint,
          prefixText: '+91 ',
          prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildDemoNoticeBadge(strings.demoOtpNotice),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          text: strings.sendOtpBtn,
          isLoading: vm.isLoading,
          onPressed: () => vm.requestRegistrationOtp(),
        ),
      ],
    );
  }

  /// Register Step 2: 6-Digit OTP Verification (Fixed 123456)
  Widget _buildRegisterOtpStep(dynamic strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${strings.otpScreenSubtitle}${vm.registerPhoneController.text}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => vm.setRegisterStep(RegisterStep.enterPhone),
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        CustomTextField(
          controller: vm.otpController,
          labelText: strings.otpScreenTitle,
          hintText: strings.enterOtpHint,
          prefixIcon: const Icon(Icons.pin_outlined, size: 20),
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildDemoNoticeBadge(strings.demoOtpNotice),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          text: strings.verifyOtpBtn,
          isLoading: vm.isLoading,
          onPressed: () => vm.verifyRegistrationOtp(),
        ),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(strings.resendOtpBtn),
            onPressed: vm.isLoading ? null : () => vm.requestRegistrationOtp(),
          ),
        ),
      ],
    );
  }

  /// Register Step 3: Password Creation
  Widget _buildRegisterPasswordStep(dynamic strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.createPasswordSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: vm.registerPasswordController,
          labelText: strings.passwordLabel,
          hintText: strings.passwordHint,
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
          obscureText: vm.obscureRegisterPassword,
          suffixIcon: IconButton(
            icon: Icon(
              vm.obscureRegisterPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: vm.toggleRegisterPasswordVisibility,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: vm.registerConfirmPasswordController,
          labelText: strings.confirmPasswordLabel,
          hintText: strings.confirmPasswordHint,
          prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
          obscureText: vm.obscureRegisterConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              vm.obscureRegisterConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: vm.toggleRegisterConfirmPasswordVisibility,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          text: strings.completeRegistrationBtn,
          isLoading: vm.isLoading,
          onPressed: () async {
            final ok = await vm.completeRegistration();
            if (ok && mounted) {
              widget.onAuthSuccess();
            }
          },
        ),
      ],
    );
  }

  Widget _buildDemoNoticeBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchModeFooter(dynamic strings) {
    final isLogin = vm.authMode == AuthMode.login;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? strings.dontHaveAccount : strings.alreadyHaveAccount,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => vm.toggleAuthMode(
            isLogin ? AuthMode.register : AuthMode.login,
          ),
          child: Text(
            isLogin ? strings.registerNow : strings.loginNow,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: AppRadius.radiusMd,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
