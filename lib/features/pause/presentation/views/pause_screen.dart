import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import '../viewmodels/pause_viewmodel.dart';
import '../widgets/breathing_session_modal.dart';
import '../widgets/concentric_breathing_visual.dart';
import '../widgets/grounding_exercise_sheet.dart';
import '../widgets/relax_activity_sheet.dart';

/// Screen: Take a Pause (Tab 3)
/// Exact layout and design matching the reference image:
/// 1. Top Header: "Take a pause ðŸŒ¿", "A little space just for you.", sprout avatar badge.
/// 2. Featured Mint Card:
///    - Eyebrow: "YOUR MOMENT OF CALM"
///    - Heading: "Let's slow things down."
///    - Subtitle: "You don't have to solve everything right now."
///    - Concentric ripple breathing rings with central leaf
///    - "Mindful breathing" & "1 minute â€¢ Gentle breathing"
///    - Pill button: "Start breathing exercise â†’"
/// 3. Choose your pause:
///    - 3 Cards Row: Breathe, Ground, Relax
/// 4. A gentle reminder card:
///    - "It's okay to take things one moment at a time."
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

  void _startBreathing() {
    HapticFeedback.lightImpact();
    BreathingSessionModal.show(context, _viewModel);
  }

  void _startGrounding() {
    HapticFeedback.lightImpact();
    GroundingExerciseSheet.show(context);
  }

  void _startRelaxing() {
    HapticFeedback.lightImpact();
    RelaxActivitySheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Scaffold(
      backgroundcolor: const color(0xFFF7FCF9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. TOP HEADER
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.pauseHeaderTitle,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: color(0xFF123C32),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          strings.pauseHeaderSubtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: color(0xFF5E7369),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const color(0xFFE2EFE9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const color(0xFF165A47).withAlpha(25),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.eco_rounded,
                        color: color(0xFF165A47),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 2. FEATURED HERO MINT CARD
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: const color(0xFFE5F2EC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const color(0xFFD2E6DC),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  children: [
                    // Eyebrow
                    Text(
                      strings.pauseMomentOfCalm,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: color(0xFF165A47),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Heading
                    Text(
                      strings.pauseSlowDownTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF123C32),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      strings.pauseSlowDownSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.8,
                        fontWeight: FontWeight.w400,
                        color: color(0xFF4D6D63),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Concentric Breathing Visual Rings
                    const ConcentricBreathingVisual(
                      size: 146,
                      scale: 1.0,
                    ),
                    const SizedBox(height: 20),

                    // Exercise Title
                    Text(
                      strings.pauseMindfulBreathingTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF123C32),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Exercise Duration
                    Text(
                      strings.pauseMindfulBreathingSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: color(0xFF5E7369),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Start Breathing Pill Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundcolor: const color(0xFF165A47),
                          foregroundcolor: colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: _startBreathing,
                        child: Text(
                          strings.pauseStartBreathingButton,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ==========================================
              // 3. CHOOSE YOUR PAUSE SECTION
              // ==========================================
              Text(
                strings.pauseChooseTitle,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF123C32),
                ),
              ),
              const SizedBox(height: 12),

              // 3 Cards Row (Breathe | Ground | Relax)
              Row(
                children: [
                  // Breathe Card
                  Expanded(
                    child: _PauseOptionCard(
                      icon: Icons.air_rounded,
                      title: strings.pauseBreatheCardTitle,
                      subtitle: strings.pauseBreatheCardSubtitle,
                      onTap: _startBreathing,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Ground Card
                  Expanded(
                    child: _PauseOptionCard(
                      icon: Icons.eco_outlined,
                      title: strings.pauseGroundCardTitle,
                      subtitle: strings.pauseGroundCardSubtitle,
                      onTap: _startGrounding,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Relax Card
                  Expanded(
                    child: _PauseOptionCard(
                      icon: Icons.favorite_border_rounded,
                      title: strings.pauseRelaxCardTitle,
                      subtitle: strings.pauseRelaxCardSubtitle,
                      onTap: _startRelaxing,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 4. A GENTLE REMINDER CARD
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const color(0xFFE4EDE7),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.pauseReminderTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF165A47),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      strings.pauseReminderBody,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: color(0xFF4D6D63),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PauseOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: color(0xFFE4EDE7),
          width: 1.1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: const color(0xFF165A47),
                size: 22,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF123C32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: color(0xFF6E8078),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

