import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import 'resource_detail_screen.dart';

class HelpfulResourcesScreen extends StatefulWidget {
  const HelpfulResourcesScreen({super.key});

  @override
  State<HelpfulResourcesScreen> createState() => _HelpfulResourcesScreenState();
}

class _HelpfulResourcesScreenState extends State<HelpfulResourcesScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Stress & Calm',
    'Emotional Health',
    'Study & Focus',
    'Self-Care',
  ];

  final List<Map<String, dynamic>> _articles = [
    {
      'title': 'Understanding the Stress Response in the Body',
      'category': 'Stress & Calm',
      'readTime': '3 min read',
      'preview': 'Why your heart races when stressed, how cortisol works, and how slow exhales signal safety to the brain.',
      'takeaways': [
        'Stress triggers the fight-or-flight sympathetic nervous system.',
        'Extending your exhalation activates the calming vagus nerve.',
        'A single 1-minute conscious pause can de-escalate acute anxiety.',
      ],
      'sections': [
        {
          'heading': '1. The Biology of Feeling Overwhelmed',
          'body': 'When deadlines loom or difficult news arrives, the brain perceives danger and initiates an adrenaline surge. Your breathing turns shallow and muscles tighten. This is natural and protective, but modern stressors rarely require physical running.',
        },
        {
          'heading': '2. Engaging the Parasympathetic Brake',
          'body': 'By consciously slowing down your breathing rhythmâ€”specifically inhaling for 4 seconds and exhaling for 4 or 6 secondsâ€”you send sensory feedback to the brainstem that danger has passed.',
        },
      ],
    },
    {
      'title': 'The 5-4-3-2-1 Sensory Grounding Technique',
      'category': 'Stress & Calm',
      'readTime': '2 min read',
      'preview': 'A simple, evidence-based method to bring attention back to the present moment when thoughts feel overwhelming.',
      'takeaways': [
        'Grounding pulls cognitive focus out of racing thoughts into physical sensations.',
        'Can be done anywhere without anyone noticing.',
        'Helps break anxiety spirals and panic before they escalate.',
      ],
      'sections': [
        {
          'heading': 'What is Sensory Grounding?',
          'body': 'During panic or anxiety, our thoughts tend to race ahead into catastrophic future scenarios. The 5-4-3-2-1 exercise grounds your nervous system in the objective reality of right now by engaging all five senses in descending order.',
        },
        {
          'heading': 'How to Practice',
          'body': 'Notice 5 things you see, 4 things you physically touch, 3 sounds you hear, 2 scents you notice, and 1 positive affirmation. Move slowly without rushing.',
        },
      ],
    },
    {
      'title': 'Navigating Exam & Academic Pressure',
      'category': 'Study & Focus',
      'readTime': '4 min read',
      'preview': 'Practical strategies to overcome procrastination, manage syllabus anxiety, and maintain mental clarity during study sessions.',
      'takeaways': [
        'Break vast syllabi into 25-minute Pomodoro intervals.',
        'Self-worth is never defined by a single test score or grade.',
        'Scheduled rest actually enhances long-term memory consolidation.',
      ],
      'sections': [
        {
          'heading': 'The Myth of Continuous Grinding',
          'body': 'Studying for 8 hours without breaks leads to cognitive fatigue and diminishing returns. The brain requires brief mental pauses to integrate new concepts into long-term memory.',
        },
        {
          'heading': 'Handling Worry Thoughts',
          'body': 'When thoughts like "What if I fail?" arise, acknowledge them without arguing. Write them down in your private journal and refocus on one small practice problem right in front of you.',
        },
      ],
    },
    {
      'title': 'Gentle Self-Compassion in Daily Life',
      'category': 'Self-Care',
      'readTime': '3 min read',
      'preview': 'How treating yourself with the same kindness you offer a good friend builds lasting emotional resilience.',
      'takeaways': [
        'Self-criticism activates threat physiology; self-compassion activates safety.',
        'Acknowledge that struggle is part of the shared human experience.',
        'Small acts of patience with yourself compound into deep inner calm.',
      ],
      'sections': [
        {
          'heading': 'Speaking to Yourself as a Friend',
          'body': 'Notice the tone of your internal voice when you make a mistake. Would you say those same harsh words to a friend who is hurting? Practice offering yourself the same understanding and gentle support.',
        },
      ],
    },
    {
      'title': 'Managing Heavy Feelings & Low Mood Days',
      'category': 'Emotional Health',
      'readTime': '4 min read',
      'preview': 'Gentle ways to care for yourself when energy is depleted, without forcing yourself to be happy.',
      'takeaways': [
        'It is okay to have low days; you do not have to solve everything immediately.',
        'Lower the bar for what success looks like on tough days.',
        'Gentle physical careâ€”hydration, soft rest, sunlightâ€”makes a real difference.',
      ],
      'sections': [
        {
          'heading': 'Removing the Pressure to "Fix" Mood',
          'body': 'Sometimes trying desperately to feel good when you are low creates secondary frustration. Allow the feeling to simply be there without judgment, like clouds passing in the sky.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    final filtered = _selectedCategory == 'All'
        ? _articles
        : _articles.where((a) => a['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundcolor: const color(0xFFF7FCF9),
      appBar: AppBar(
        backgroundcolor: const color(0xFFF7FCF9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: color(0xFF123C32)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          strings.helpResourcesTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color(0xFF123C32),
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? colors.white : const color(0xFF5E7369),
                      ),
                      selectedcolor: const color(0xFF165A47),
                      backgroundcolor: colors.white,
                      side: BorderSide(
                        color: isSelected ? const color(0xFF165A47) : const color(0xFFE4EDE7),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Articles List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final article = filtered[idx];

                  return Material(
                    color: colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: color(0xFFE4EDE7), width: 1.1),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ResourceDetailScreen(resource: article),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const color(0xFFE5F2EC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    article['category'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: color(0xFF165A47),
                                    ),
                                  ),
                                ),
                                Text(
                                  article['readTime'] as String,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: color(0xFF7A8E85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              article['title'] as String,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: color(0xFF123C32),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article['preview'] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: color(0xFF5E7369),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Row(
                              children: [
                                Text(
                                  'Read guide',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: color(0xFF165A47),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, size: 14, color: color(0xFF165A47)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

