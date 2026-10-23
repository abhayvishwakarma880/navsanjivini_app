import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';

class TalkToSomeoneScreen extends StatelessWidget {
  const TalkToSomeoneScreen({super.key});

  void _callHelpline(BuildContext context, String name, String number) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: number));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF165A47), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Connect to $name',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF123C32),
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
              'Helpline: $number',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF165A47),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This number has been copied to your clipboard so you can easily paste or dial it from your phone dialer.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5E7369),
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF5E7369), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF165A47),
              foregroundColor: Colors.white,
              minimumSize: const Size(100, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dialing $number... Copied to clipboard.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    final helplines = [
      {
        'name': 'Tele-MANAS',
        'sub': 'Ministry of Health & Family Welfare, Govt. of India',
        'number': '14416',
        'hours': '24/7 Support',
        'isTollFree': true,
        'languages': 'Hindi, English & 20+ Regional',
        'desc': 'Comprehensive, free mental health counseling by trained psychiatric social workers and clinical psychologists.',
      },
      {
        'name': 'KIRAN Helpline',
        'sub': 'Ministry of Social Justice & Empowerment',
        'number': '1800-599-0019',
        'hours': '24/7 Support',
        'isTollFree': true,
        'languages': 'Hindi, English & 13 Regional',
        'desc': 'National helpline providing psychological first aid, panic intervention, and depression counseling.',
      },
      {
        'name': 'Vandrevala Foundation',
        'sub': 'Non-Profit Mental Health Alliance',
        'number': '+91 9999 666 555',
        'hours': '24/7 Support',
        'isTollFree': false,
        'languages': 'Hindi, English & Major Languages',
        'desc': 'Free emotional crisis intervention and mental health support by experienced clinical counsellors.',
      },
      {
        'name': 'Sneha India',
        'sub': 'Suicide Prevention & Crisis Intervention',
        'number': '044-24640050',
        'hours': '24/7 Support',
        'isTollFree': false,
        'languages': 'English, Tamil & Hindi',
        'desc': 'Confidential, unconditional emotional support for anyone in distress, feeling overwhelmed or hopeless.',
      },
      {
        'name': 'Sangath Youth Helpline',
        'sub': 'Community Mental Health Initiative',
        'number': '011-41198666',
        'hours': '10 AM - 6 PM (Mon-Sat)',
        'isTollFree': false,
        'languages': 'Hindi & English',
        'desc': 'Dedicated youth, student and young adult emotional wellbeing and exam pressure guidance.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FCF9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF123C32)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          strings.helpTalkSomeoneTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF123C32),
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Intro Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F2EC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD2E6DC)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: Color(0xFF165A47), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All helplines listed below are verified, confidential, and run by qualified clinical organizations across India.',
                      style: TextStyle(
                        fontSize: 12.8,
                        color: Color(0xFF165A47),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Helplines list
            ...helplines.map((item) {
              final isTollFree = item['isTollFree'] as bool;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE4EDE7), width: 1.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF123C32),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['sub'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5E7369),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isTollFree)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F2EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Toll Free',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF165A47),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['desc'] as String,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: Color(0xFF4D6D63),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Badges: Hours & Language
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildBadge(Icons.access_time_rounded, item['hours'] as String),
                        _buildBadge(Icons.translate_rounded, item['languages'] as String),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Call button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF165A47),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () => _callHelpline(
                          context,
                          item['name'] as String,
                          item['number'] as String,
                        ),
                        icon: const Icon(Icons.call_rounded, size: 17),
                        label: Text(
                          'Call ${item['number']}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4EDE7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF5E7369)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5E7369),
            ),
          ),
        ],
      ),
    );
  }
}
