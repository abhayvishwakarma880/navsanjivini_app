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

                    // Subtitle based on mode with smooth cross-fade
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        vm.authMode == AuthMode.login
                            ? strings.loginSubtitle
                            : strings.registerSubtitle,
                        key: ValueKey<AuthMode>(vm.authMode),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

                    // Mode Form with smooth animated transitions
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              ...previousChildren,
                              ?currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          final isLoginChild = (child.key as ValueKey<AuthMode>?)?.value == AuthMode.login;
                          final offset = Tween<Offset>(
                            begin: Offset(isLoginChild ? -0.06 : 0.06, 0.0),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: offset,
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<AuthMode>(vm.authMode),
                          child: vm.authMode == AuthMode.login
                              ? _buildLoginForm(strings)
                              : _buildRegisterFlow(strings),
                        ),
                      ),
                    ),

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

  /// Segmented Tab Switcher with Silky Smooth Sliding Indicator
  Widget _buildModeTabs(dynamic strings) {
    final isLogin = vm.authMode == AuthMode.login;
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Gliding pill indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                left: isLogin ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withAlpha(20),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab labels
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          vm.toggleAuthMode(AuthMode.login);
                        },
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: AppTextStyles.titleMedium.copyWith(
                              color: isLogin
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                              fontWeight:
                                  isLogin ? FontWeight.w700 : FontWeight.w500,
                            ),
                            child: Text(strings.loginTab),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          vm.toggleAuthMode(AuthMode.register);
                        },
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: AppTextStyles.titleMedium.copyWith(
                              color: !isLogin
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                              fontWeight:
                                  !isLogin ? FontWeight.w700 : FontWeight.w500,
                            ),
                            child: Text(strings.registerTab),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<RegisterStep>(vm.registerStep),
        child: switch (vm.registerStep) {
          RegisterStep.enterPhone => _buildRegisterPhoneStep(strings),
          RegisterStep.verifyOtp => _buildRegisterOtpStep(strings),
          RegisterStep.createPassword => _buildRegisterPasswordStep(strings),
        },
      ),
    );
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

