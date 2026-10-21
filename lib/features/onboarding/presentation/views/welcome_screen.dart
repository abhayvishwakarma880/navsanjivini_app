import 'package:flutter/material.dart';
import 'package:app/core/localization/app_languages.dart';
import 'package:app/core/localization/language_scope.dart';

/// Screen 1: Welcome Screen (Matches exact Navsanjivini visual aesthetic)
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final currentLang = context.currentLanguage;

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
            child: Column(
              children: [
                // Subtle Language Switch Pill at Top Right
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _LanguagePill(
                      currentLang: currentLang,
                      onChanged: (lang) => context.setLanguage(lang),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Centered Logo Emblem
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF135A45).withAlpha(35),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
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
                const SizedBox(height: 22),

                // Brand Name: Navsanjivini
                Text(
                  strings.appName,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0C4D38),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Tagline / Subtitle: A gentle space to feel better
                Text(
                  strings.welcomeSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B6050),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 18),

                // Decorative Divider with Leaf Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 1,
                      color: const Color(0xFFA5CBBF),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.eco_rounded,
                      size: 18,
                      color: Color(0xFF438E75),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 48,
                      height: 1,
                      color: const Color(0xFFA5CBBF),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Body Description: Your companion for everyday emotional well-being.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    strings.welcomeDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF386457),
                      height: 1.45,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // 3 Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F5A44),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3D9CA),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3D9CA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Pill Button: "Get Started  →"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5B46),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F5B46).withAlpha(60),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onContinue,
                        borderRadius: BorderRadius.circular(28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              strings.getStartedBtn,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final AppLanguage currentLang;
  final ValueChanged<AppLanguage> onChanged;

  const _LanguagePill({
    required this.currentLang,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withAlpha(220),
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      child: InkWell(
        onTap: () => _showLanguageModal(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 16, color: Color(0xFF0F5B46)),
              const SizedBox(width: 6),
              Text(
                currentLang.nativeName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F5B46),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_drop_down_rounded, size: 18, color: Color(0xFF0F5B46)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 16),
              Text(
                context.tr.chooseLanguageTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F5B46),
                ),
              ),
              const SizedBox(height: 16),
              ...AppLanguage.values.map((lang) {
                final isSelected = lang == currentLang;
                return ListTile(
                  title: Text(lang.nativeName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(lang.displayName),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0F5B46))
                      : null,
                  onTap: () {
                    onChanged(lang);
                    Navigator.of(sheetCtx).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
