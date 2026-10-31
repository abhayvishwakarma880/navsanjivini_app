import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import '../widgets/urgent_help_modal.dart';
import 'app_faqs_screen.dart';
import 'helpful_resources_screen.dart';
import 'talk_to_someone_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
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
                          strings.helpHeaderTitle,
                          style: const TextStyle(
                            fontSize: 19.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF123C32),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          strings.helpHeaderSubtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5E7369),
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
                      color: const Color(0xFFE2EFE9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF165A47).withAlpha(25),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.volunteer_activism_rounded,
                        color: Color(0xFF165A47),
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 2. HERO MINT CARD
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F2EC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFD2E6DC),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.volunteer_activism_outlined,
                      color: Color(0xFF165A47),
                      size: 26,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.helpHeroTitle,
                      style: const TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF123C32),
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.helpHeroSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4D6D63),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ==========================================
              // 3. EXPLORE SUPPORT SECTION
              // ==========================================
              Text(
                strings.helpExploreSupportTitle,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF123C32),
                ),
              ),
              const SizedBox(height: 12),

              // Card 1: Talk to someone
              _HelpNavCard(
                icon: Icons.phone_outlined,
                title: strings.helpTalkSomeoneTitle,
                subtitle: strings.helpTalkSomeoneSubtitle,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TalkToSomeoneScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Card 2: Helpful resources
              _HelpNavCard(
                icon: Icons.menu_book_outlined,
                title: strings.helpResourcesTitle,
                subtitle: strings.helpResourcesSubtitle,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpfulResourcesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Card 3: App FAQs
              _HelpNavCard(
                icon: Icons.help_outline_rounded,
                title: strings.helpFaqsTitle,
                subtitle: strings.helpFaqsSubtitle,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppFaqsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              // ==========================================
              // 4. URGENT HELP CARD (WARM AMBER)
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF7EC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFF4E2C7),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFFA15D08),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          strings.helpUrgentCardTitle,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5C3405),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.helpUrgentCardSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A5833),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // View urgent support options Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6D3D04),
                          side: const BorderSide(
                            color: Color(0xFFECD6B8),
                            width: 1.2,
                          ),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          UrgentHelpModal.show(context);
                        },
                        child: Text(
                          strings.helpUrgentButton,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6D3D04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpNavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpNavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFE4EDE7),
          width: 1.1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              // Square Soft Mint Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EFE9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFF165A47),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF123C32),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: Color(0xFF5E7369),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Trailing Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF7A8E85),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
