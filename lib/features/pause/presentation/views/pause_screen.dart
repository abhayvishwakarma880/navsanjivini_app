import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/widgets/custom_button.dart';
import '../viewmodels/pause_viewmodel.dart';
import '../widgets/breathing_circle.dart';

class PauseScreen extends StatefulWidget {
  const PauseScreen({super.key});

  @override
  State<PauseScreen> createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  final PauseViewModel _viewModel = PauseViewModel();

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
            title: const Text('Pause & Relax'),
          ),
          body: SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  Text(
                    'Box Breathing (4-4-4-4)',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Regulate your nervous system with equal rhythm breathing.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  BreathingCircle(
                    phase: _viewModel.currentPhase,
                    isActive: _viewModel.isActive,
                  ),
                  const Spacer(),
                  CustomButton(
                    text: _viewModel.isActive ? 'Pause Exercise' : 'Begin Breathing',
                    onPressed: () {
                      _viewModel.toggleActive();
                    },
                    variant: _viewModel.isActive
                        ? ButtonVariant.secondary
                        : ButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
