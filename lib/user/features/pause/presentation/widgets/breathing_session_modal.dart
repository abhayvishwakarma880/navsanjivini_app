import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import '../viewmodels/pause_viewmodel.dart';
import 'concentric_breathing_visual.dart';

class BreathingSessionModal extends StatelessWidget {
  final PauseViewModel viewModel;

  const BreathingSessionModal({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, PauseViewModel viewModel) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BreathingSessionModal(viewModel: viewModel),
    ).whenComplete(() {
      viewModel.stopSession();
    });
  }

  String _getPhaseLabel(BreathPhase phase, dynamic strings) {
    switch (phase) {
      case BreathPhase.inhale:
        return strings.pauseBreatheIn;
      case BreathPhase.hold:
        return strings.pauseHold;
      case BreathPhase.exhale:
        return strings.pauseBreatheOut;
      case BreathPhase.rest:
        return strings.pauseRest;
    }
  }

  double _computeScale(PauseViewModel vm) {
    if (!vm.isActive || vm.isPaused) return 1.0;
    final total = vm.currentPhase.durationSeconds;
    final remaining = vm.phaseSecondsRemaining;
    final progress = (total - remaining) / total;

    switch (vm.currentPhase) {
      case BreathPhase.inhale:
        return 1.0 + (0.30 * progress);
      case BreathPhase.hold:
        return 1.30;
      case BreathPhase.exhale:
        return 1.30 - (0.40 * progress);
      case BreathPhase.rest:
        return 0.90 + (0.10 * progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final vm = viewModel;
        final remainingTotal = vm.totalSessionSeconds - vm.elapsedSeconds;
        final minutes = (remainingTotal ~/ 60).toString().padLeft(2, '0');
        final seconds = (remainingTotal % 60).toString().padLeft(2, '0');

        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.78,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Top Bar with Close & Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF5E7369)),
                      onPressed: () {
                        vm.stopSession();
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F2EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$minutes:$seconds',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF165A47),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balance header
                  ],
                ),
                const Spacer(),

                if (vm.isSessionCompleted) ...[
                  // Completion Card
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5F2EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF165A47),
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    strings.pauseDone,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF123C32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Take one more normal breath and gently continue your day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF5E7369),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF165A47),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Complete session',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ] else if (!vm.isActive) ...[
                  // Pre-start Ready Screen
                  const ConcentricBreathingVisual(
                    size: 190,
                    scale: 1.0,
                    showShadow: true,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    strings.pauseMindfulBreathingTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF123C32),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Sit comfortably, relax your shoulders, and follow the rhythm of the gentle circle.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: Color(0xFF5E7369),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF165A47),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        vm.startBreathingSession();
                      },
                      child: const Text(
                        'Begin breathing',
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ] else ...[
                  // Active Guided Breathing with Concentric Visual
                  AnimatedScale(
                    scale: _computeScale(vm),
                    duration: const Duration(milliseconds: 950),
                    curve: Curves.easeInOut,
                    child: const ConcentricBreathingVisual(
                      size: 190,
                      showShadow: true,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Phase Title
                  Text(
                    _getPhaseLabel(vm.currentPhase, strings),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF123C32),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Seconds remaining in phase
                  Text(
                    '${vm.phaseSecondsRemaining}s',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF165A47),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Cycle tracking
                  Text(
                    'Cycle ${vm.currentCycle} of ${vm.totalCycles}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF7A8E85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),

                  // Controls Bar: Reset | Pause/Resume
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reset Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(110, 48),
                          foregroundColor: const Color(0xFF5E7369),
                          side: const BorderSide(color: Color(0xFFD2E6DC), width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          vm.resetSession();
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(strings.pauseReset),
                      ),
                      const SizedBox(width: 16),

                      // Pause / Resume Toggle
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 48),
                          backgroundColor: const Color(0xFF165A47),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          if (vm.isPaused) {
                            vm.resumeSession();
                          } else {
                            vm.pauseSession();
                          }
                        },
                        icon: Icon(
                          vm.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          size: 20,
                        ),
                        label: Text(
                          vm.isPaused ? strings.pauseResume : strings.pausePause,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
