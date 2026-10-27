import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';

class UrgentHelpModal extends StatelessWidget {
  const UrgentHelpModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundcolor: colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const UrgentHelpModal(),
    );
  }

  void _onCallService(BuildContext context, String name, String number) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: number));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundcolor: colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.call_rounded, color: color(0xFF165A47), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Connect to $name',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF123C32),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Helpline Number: $number',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color(0xFF165A47),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The number has been copied to your clipboard. You can dial it immediately from your phone app.',
              style: TextStyle(
                fontSize: 13,
                color: color(0xFF5E7369),
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: color(0xFF5E7369), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundcolor: const color(0xFF165A47),
              foregroundcolor: colors.white,
              minimumSize: const Size(100, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dialing $number... Number copied to clipboard.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Dial Number'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    final emergencyServices = [
      {
        'number': '112',
        'name': 'National Emergency Helpline',
        'badge': 'Police, Ambulance & Fire â€¢ 24/7',
        'desc': 'Single emergency number across India for immediate rescue and disaster intervention.',
        'isNational': true,
      },
      {
        'number': '14416',
        'name': 'Tele-MANAS (Govt. of India)',
        'badge': 'Toll-free â€¢ 24/7 â€¢ 20+ Languages',
        'desc': 'National tele-mental health programme by Ministry of Health & Family Welfare.',
        'isNational': false,
      },
      {
        'number': '1800-599-0019',
        'name': 'KIRAN Helpline',
        'badge': 'Toll-free â€¢ 24/7 Mental Health',
        'desc': 'Official helpline by Dept. of Empowerment of Persons with Disabilities for crisis support.',
        'isNational': false,
      },
      {
        'number': '1098',
        'name': 'Childline & Youth Care',
        'badge': 'Toll-free â€¢ 24/7 Youth Support',
        'desc': 'Dedicated nationwide emergency phone outreach service for students and young people.',
        'isNational': false,
      },
    ];

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            const SizedBox(height: 14),

            // Top Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: color(0xFFFEF7EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: color(0xFFA15D08),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      strings.helpUrgentModalTitle,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF123C32),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: color(0xFF5E7369)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Subtitle
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                strings.helpUrgentModalSubtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: color(0xFF5E7369),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Contacts List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: emergencyServices.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final service = emergencyServices[idx];
                  final isNational = service['isNational'] as bool;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isNational ? const color(0xFFFFF9F2) : colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isNational ? const color(0xFFF4E2C7) : const color(0xFFE4EDE7),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isNational ? const color(0xFFFDE8D3) : const color(0xFFE5F2EC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  service['badge'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isNational ? const color(0xFF9C5808) : const color(0xFF165A47),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              service['number'] as String,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: isNational ? const color(0xFF9C5808) : const color(0xFF165A47),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['name'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: color(0xFF123C32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['desc'] as String,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: color(0xFF5E7369),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundcolor: isNational ? const color(0xFFA15D08) : const color(0xFF165A47),
                              foregroundcolor: colors.white,
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => _onCallService(
                              context,
                              service['name'] as String,
                              service['number'] as String,
                            ),
                            icon: const Icon(Icons.call_rounded, size: 16),
                            label: Text(
                              'Call ${service['number']}',
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Gentle Disclaimer Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const color(0xFFF7FCF9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const color(0xFFE4EDE7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: color(0xFF5E7369), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      strings.helpDisclaimer,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: color(0xFF5E7369),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

