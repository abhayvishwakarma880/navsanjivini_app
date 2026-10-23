import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RelaxActivitySheet extends StatefulWidget {
  const RelaxActivitySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RelaxActivitySheet(),
    );
  }

  @override
  State<RelaxActivitySheet> createState() => _RelaxActivitySheetState();
}

class _RelaxActivitySheetState extends State<RelaxActivitySheet> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Drop your shoulders',
      'body': 'Lift your shoulders up towards your ears for 3 seconds, and then let them fall completely. Feel the immediate relief in your upper back.',
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'title': 'Unclench your jaw & face',
      'body': 'Part your teeth slightly and let your tongue rest behind your lower teeth. Smooth out any wrinkles in your forehead and eyebrows.',
      'icon': Icons.face_retouching_natural_rounded,
    },
    {
      'title': 'Open your palms & belly',
      'body': 'Unclench your hands and let your palms face upwards on your lap. Let your stomach expand softly without sucking it in.',
      'icon': Icons.pan_tool_outlined,
    },
    {
      'title': 'The calming sigh',
      'body': 'Take one full breath in through your nose, then open your mouth and let out a gentle, audible sigh. Feel your body sinking into calm.',
      'icon': Icons.air_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final isLast = _currentStep == _steps.length - 1;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
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

            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Body Relaxation',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF123C32),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF5E7369)),
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
                        ? const Color(0xFF165A47)
                        : (isDone ? const Color(0xFF76BCA3) : const Color(0xFFE5EDE8)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const Spacer(),

            // Icon circle
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE5F2EC),
              ),
              child: Center(
                child: Icon(
                  step['icon'] as IconData,
                  color: const Color(0xFF165A47),
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              step['title'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF123C32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                step['body'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF4D6D63),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),

            // Actions
            Row(
              children: [
                if (_currentStep > 0) ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(80, 48),
                      foregroundColor: const Color(0xFF5E7369),
                      side: const BorderSide(color: Color(0xFFD2E6DC), width: 1.2),
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
                        backgroundColor: const Color(0xFF165A47),
                        foregroundColor: Colors.white,
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
                        isLast ? 'Complete relaxation' : 'Next →',
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
