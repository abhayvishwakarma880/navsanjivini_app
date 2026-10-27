import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroundingExerciseSheet extends StatefulWidget {
  const GroundingExerciseSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundcolor: colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const GroundingExerciseSheet(),
    );
  }

  @override
  State<GroundingExerciseSheet> createState() => _GroundingExerciseSheetState();
}

class _GroundingExerciseSheetState extends State<GroundingExerciseSheet> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'number': '5',
      'sense': 'SEE',
      'icon': Icons.visibility_outlined,
      'title': '5 things you can see',
      'instruction': 'Look around the room or wherever you are. Notice 5 distinct things you see â€” colors, shadows, a clock, or an object on your desk.',
      'hint': 'e.g. A pattern on the wall, a window frame, light reflection',
    },
    {
      'number': '4',
      'sense': 'TOUCH',
      'icon': Icons.touch_app_outlined,
      'title': '4 things you can physically feel',
      'instruction': 'Bring attention to your physical body. Notice the texture of your clothes, your feet firmly touching the floor, or the surface of your chair.',
      'hint': 'e.g. Feet on the ground, cool air on skin, phone texture',
    },
    {
      'number': '3',
      'sense': 'HEAR',
      'icon': Icons.hearing_outlined,
      'title': '3 sounds you can hear',
      'instruction': 'Close your eyes for a moment. Listen carefully for 3 subtle sounds in your background.',
      'hint': 'e.g. Hum of a fan, distant birds, your own slow breathing',
    },
    {
      'number': '2',
      'sense': 'SMELL',
      'icon': Icons.air_outlined,
      'title': '2 scents you can smell',
      'instruction': 'Breathe in through your nose. Try to notice two subtle scents in the air around you, or simply imagine your favorite calming aroma.',
      'hint': 'e.g. Fresh air, cup of tea, laundry scent',
    },
    {
      'number': '1',
      'sense': 'TASTE & AFFIRM',
      'icon': Icons.favorite_outline_rounded,
      'title': '1 positive truth about right now',
      'instruction': 'Notice any taste in your mouth, take a small sip of water, and repeat softly to yourself: "I am safe and grounded in this moment."',
      'hint': 'e.g. "I am doing the best I can, one step at a time."',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final isLast = _currentStep == _steps.length - 1;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Column(
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '5-4-3-2-1 Grounding',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: color(0xFF123C32),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: color(0xFF5E7369)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Step Progress Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_steps.length, (idx) {
                final isActive = idx == _currentStep;
                final isDone = idx < _currentStep;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const color(0xFF165A47)
                        : (isDone ? const color(0xFF76BCA3) : const color(0xFFE5EDE8)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const Spacer(),

            // Large Circular Step Emblem
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const color(0xFFE5F2EC),
                border: Border.all(color: const color(0xFFC7E8DC), width: 2),
              ),
              child: Center(
                child: Icon(
                  step['icon'] as IconData,
                  color: const color(0xFF165A47),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sense Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const color(0xFFE5F2EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                step['sense'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: color(0xFF165A47),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              step['title'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color(0xFF123C32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Instruction
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                step['instruction'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: color(0xFF4D6D63),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const color(0xFFF7FCF9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const color(0xFFE4EDE7)),
              ),
              child: Text(
                step['hint'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: color(0xFF5E7369),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),

            // Navigation Buttons: Previous / Next
            Row(
              children: [
                if (_currentStep > 0) ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(80, 48),
                      foregroundcolor: const color(0xFF5E7369),
                      side: const BorderSide(color: color(0xFFD2E6DC), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() => _currentStep--);
                    },
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundcolor: const color(0xFF165A47),
                        foregroundcolor: colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        if (isLast) {
                          Navigator.of(context).pop();
                        } else {
                          setState(() => _currentStep++);
                        }
                      },
                      child: Text(
                        isLast ? 'Complete grounding' : 'Next step â†’',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

