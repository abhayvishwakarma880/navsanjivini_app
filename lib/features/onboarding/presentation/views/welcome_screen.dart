import 'package:flutter/material.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/localization/language_scope.dart';

/// Screen 1: Welcome Screen with Centered Logo Content & Bottom-docked Language + Safety Controls
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _is18Plus = true;
  bool _consentGiven = true;

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final currentLang = context.currentLanguage;
    final canProceed = _is18Plus && _consentGiven;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Watercolor Background Art with leaves & waves
          Image.asset(
            'assets/images/welcome_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFFF7FCF9));
            },
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            const Spacer(flex: 3),

                            // ==========================================
                            // 🌟 CENTER CONTENT: Logo & Brand Description
                            // ==========================================
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Centered Logo Emblem
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF135A45).withAlpha(35),
                                          blurRadius: 26,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/navsanjivini_logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Brand Name: Navsanjivini
                                  Text(
                                    strings.appName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 31,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0C4D38),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 3),

                                  // Tagline / Subtitle: A gentle space to feel better
                                  Text(
                                    strings.welcomeSubtitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2B6050),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Decorative Divider with Leaf Icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 1,
                                        color: const Color(0xFFA5CBBF),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.eco_rounded,
                                        size: 16,
                                        color: Color(0xFF438E75),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 40,
                                        height: 1,
                                        color: const Color(0xFFA5CBBF),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Body Description
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      strings.welcomeDescription,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF386457),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(flex: 4),

                            // ==========================================
                            // 🌟 BOTTOM SECTION: Language + Safety + Button
                            // Seamlessly merged with background image
                            // ==========================================

                            // 1. Language Selection (Merged with Background Image)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(55),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF247D6B).withAlpha(50),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F5B46).withAlpha(8),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F5B46).withAlpha(25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.translate_rounded,
                                          size: 14,
                                          color: Color(0xFF0F5B46),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        strings.chooseLanguageTitle,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0C4D38),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: AppLanguage.values.map((lang) {
                                      final isSelected = lang == currentLang;
                                      final scriptSymbol = lang == AppLanguage.english
                                          ? 'A'
                                          : (lang == AppLanguage.hindi ? 'अ' : 'Aa');

                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                          child: Material(
                                            color: isSelected
                                                ? const Color(0xFFE2F3EB).withAlpha(220)
                                                : Colors.white.withAlpha(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: isSelected
                                                    ? const Color(0xFF0F5B46)
                                                    : const Color(0xFF247D6B).withAlpha(45),
                                                width: isSelected ? 1.8 : 1,
                                              ),
                                            ),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              onTap: () {
                                                context.setLanguage(lang);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 6,
                                                  horizontal: 4,
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? const Color(0xFF0F5B46)
                                                            : const Color(0xFF0F5B46).withAlpha(20),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        scriptSymbol,
                                                        style: TextStyle(
                                                          fontSize: 11.5,
                                                          fontWeight: FontWeight.w700,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : const Color(0xFF0F5B46),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      lang.nativeName,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11.5,
                                                        fontWeight: isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w600,
                                                        color: isSelected
                                                            ? const Color(0xFF0C4D38)
                                                            : const Color(0xFF2E6353),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // 2. Safety & Consent (Merged with Background Image)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(55),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: canProceed
                                      ? const Color(0xFF0F5B46).withAlpha(75)
                                      : const Color(0xFF247D6B).withAlpha(45),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F5B46).withAlpha(8),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F5B46).withAlpha(25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.verified_user_outlined,
                                          size: 14,
                                          color: Color(0xFF0F5B46),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          strings.safetyConsentTitle,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0C4D38),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F5B46).withAlpha(20),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          '18+ & AI',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F5B46),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),

                                  // Checkbox 1: 18+
                                  InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () {
                                      setState(() => _is18Plus = !_is18Plus);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                              value: _is18Plus,
                                              activeColor: const Color(0xFF0F5B46),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFF247D6B),
                                                width: 1.5,
                                              ),
                                              onChanged: (val) =>
                                                  setState(() => _is18Plus = val ?? false),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              strings.ageConfirmationTitle,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: _is18Plus
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                                color: _is18Plus
                                                    ? const Color(0xFF0C4D38)
                                                    : const Color(0xFF2E6353),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Checkbox 2: Consent
                                  InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () {
                                      setState(() => _consentGiven = !_consentGiven);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                              value: _consentGiven,
                                              activeColor: const Color(0xFF0F5B46),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFF247D6B),
                                                width: 1.5,
                                              ),
                                              onChanged: (val) =>
                                                  setState(() => _consentGiven = val ?? false),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              strings.consentTitle,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: _consentGiven
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                                color: _consentGiven
                                                    ? const Color(0xFF0C4D38)
                                                    : const Color(0xFF2E6353),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),

                                  // Mini Disclaimer
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(45),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.info_outline_rounded,
                                          size: 12,
                                          color: Color(0xFF0F5B46),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            strings.clinicalDisclaimer,
                                            style: const TextStyle(
                                              fontSize: 9.5,
                                              height: 1.3,
                                              color: Color(0xFF386457),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 3. Pill Button: "Get Started  →" (Bottom-most)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: canProceed
                                      ? const Color(0xFF0F5B46)
                                      : const Color(0xFF86AFA2),
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: canProceed
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF0F5B46).withAlpha(50),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (canProceed) {
                                        widget.onContinue();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.currentLanguage == AppLanguage.hindi
                                                  ? 'जारी रखने के लिए 18+ और सुरक्षा नियमों की पुष्टि करें।'
                                                  : (context.currentLanguage == AppLanguage.hinglish
                                                      ? 'Aage badhne ke liye 18+ aur safety terms confirm karein.'
                                                      : 'Please confirm 18+ eligibility and safety terms to continue.'),
                                            ),
                                            duration: const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(28),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          strings.getStartedBtn,
                                          style: const TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
