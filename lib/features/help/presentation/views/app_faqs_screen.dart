import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';

class AppFaqsScreen extends StatelessWidget {
  const AppFaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    final faqs = [
      {
        'q': 'Is my personal data and journal private?',
        'a': 'Yes, completely. Your journal entries and mood check-ins are stored locally on your device storage. Navsanjivini does not sell your private information, train public models on your diary entries, or share personal reflections with external third parties.',
        'tag': 'Privacy & Storage',
      },
      {
        'q': 'How does the AI Talk companion work?',
        'a': 'The Talk companion is designed as a compassionate, non-judgmental conversational space. It uses emotional reflection prompts to help you organize thoughts, express feelings, and de-stress. It does not provide medical prescriptions or clinical diagnoses.',
        'tag': 'AI Companion',
      },
      {
        'q': 'Can I use Navsanjivini offline?',
        'a': 'Yes! Mindful breathing rhythms, the 5-4-3-2-1 sensory grounding exercise, quick body relaxation guides, and your private diary work 100% offline without needing internet access or mobile data.',
        'tag': 'Offline Access',
      },
      {
        'q': 'How do I export or delete all my saved data?',
        'a': 'You have full sovereignty over your information. Go to your Profile screen, tap "Data & Privacy", and choose "Export Data" for an encrypted local archive, or "Delete Account & Data" to permanently wipe everything from your device.',
        'tag': 'Data Control',
      },
      {
        'q': 'Is Navsanjivini a substitute for medical psychiatric care?',
        'a': 'No. Navsanjivini is an emotional well-being and daily self-care companion. If you are experiencing severe depression, persistent trauma, clinical anxiety, or thoughts of self-harm, please connect with a qualified mental health doctor or dial Tele-MANAS at 14416 immediately.',
        'tag': 'Clinical Boundaries',
      },
      {
        'q': 'What languages are supported?',
        'a': 'Navsanjivini supports English, Hindi (हिंदी), and Hinglish (हिंग्लिश). You can switch your preferred language at any time from the Welcome screen or through Profile -> Settings.',
        'tag': 'Localization',
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
          strings.helpFaqsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF123C32),
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: faqs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, idx) {
            final faq = faqs[idx];

            return Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE4EDE7), width: 1.1),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  iconColor: const Color(0xFF165A47),
                  collapsedIconColor: const Color(0xFF5E7369),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F2EC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          faq['tag']!,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF165A47),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        faq['q']!,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF123C32),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Text(
                      faq['a']!,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF4D6D63),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
