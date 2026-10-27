import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import '../viewmodels/pause_viewmodel.dart';

class BreathingCircle extends StatelessWidget {
  final BreathPhase phase;
  final bool isActive;

  const BreathingCircle({
    super.key,
    required this.phase,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final phaseText = switch (phase) {
      BreathPhase.inhale => 'Inhale deeply...',
      BreathPhase.hold => 'Hold gently...',
      BreathPhase.exhale => 'Exhale slowly...',
      BreathPhase.rest => 'Rest...',
    };

    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 4),
        width: phase == BreathPhase.inhale ? 220 : 160,
        height: phase == BreathPhase.inhale ? 220 : 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Appcolors.primaryContainer.withAlpha(200),
          border: Border.all(
            color: Appcolors.primary,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          isActive ? phaseText : 'Tap to start',
          style: const TextStyle(
            color: Appcolors.primaryDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

