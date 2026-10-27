import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';

enum TodayMood {
  great(label: 'Great', emoji: 'ðŸ˜Š'),
  okay(label: 'Okay', emoji: 'ðŸ˜'),
  low(label: 'Low', emoji: 'ðŸ˜”'),
  anxious(label: 'Anxious', emoji: 'ðŸ˜°'),
  overwhelmed(label: 'Overwhelmed', emoji: 'ðŸ˜«');

  final String label;
  final String emoji;

  const TodayMood({required this.label, required this.emoji});
}

/// Screen: Home / Today Dashboard (Tab 1)
/// Exact layout matching the Navsanjivini design blueprint and visual reference:
/// 1. Top Header: Time-of-day greeting ("Good morning ðŸŒ¿"), subtitle, circular profile button.
/// 2. Daily Mood Check-in Card (Primary Action): 5 Mood options (Great, Okay, Low, Anxious, Overwhelmed) + supportive response flow.
/// 3. Take a small pause shortcut: "A minute to breathe and reset."
/// 4. "What would help right now?": 4 clean cards (Talk it out, Explore, My Journal, Find support).
/// 5. A gentle thought: Non-judgmental supportive reflection quote.
class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToMood;
  final VoidCallback onNavigateToTalk;
  final VoidCallback onNavigateToPause;
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToHelp;
  final VoidCallback onNavigateToProfile;
  final VoidCallback? onNavigateToJournal;

  const HomeScreen({
    super.key,
    required this.onNavigateToMood,
    required this.onNavigateToTalk,
    required this.onNavigateToPause,
    required this.onNavigateToExplore,
    required this.onNavigateToHelp,
    required this.onNavigateToProfile,
    this.onNavigateToJournal,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodayMood? _selectedMood;
  String? _supportiveResponse;

  String _getTimeGreeting(dynamic strings) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return strings.goodMorningGreeting;
    } else if (hour >= 12 && hour < 17) {
      return strings.goodAfternoonGreeting;
    } else {
      return strings.goodEveningGreeting;
    }
  }

  void _onSelectMood(TodayMood mood) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedMood = mood;
      _supportiveResponse = _getSupportiveMessage(mood);
    });
  }

  String _getSupportiveMessage(TodayMood mood) {
    return switch (mood) {
      TodayMood.great =>
        'Wonderful to hear. Savor this positive feeling and take it with you today. ðŸŒ¿',
      TodayMood.okay =>
        'Thank you for checking in. Steady, quiet days are just as meaningful. ðŸŒ¿',
      TodayMood.low =>
        'We hear you. Be gentle with yourself today. You don\'t have to carry everything all at once. ðŸŒ¿',
      TodayMood.anxious =>
        'Take a slow breath. You are safe in this moment, and it\'s okay to pause right now. ðŸŒ¿',
      TodayMood.overwhelmed =>
        'It is completely okay to slow down. One small step at a time is more than enough. ðŸŒ¿',
    };
  }

  void _submitMoodCheckin() {
    if (_selectedMood == null) {
      // Default to Okay if user taps without selecting
      setState(() {
        _selectedMood = TodayMood.okay;
        _supportiveResponse = _getSupportiveMessage(TodayMood.okay);
      });
    }

    widget.onNavigateToMood();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final greeting = _getTimeGreeting(strings);

    return Scaffold(
      backgroundcolor: const color(0xFFF7FCF9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              // ==========================================
              // â‘  TOP HEADER
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
                          greeting,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: color(0xFF1D3C33),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          strings.howAreYouFeeling,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: color(0xFF5E7369),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Top-Right Circular Profile Button
                  Material(
                    color: const color(0xFFE2EFE9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: widget.onNavigateToProfile,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const color(0xFF0F5B46).withAlpha(35),
                            width: 1.2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: color(0xFF0F5B46),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // â‘¡ DAILY MOOD CHECK-IN CARD (Primary Action)
              // ==========================================
              _buildMoodCheckinCard(strings),
              const SizedBox(height: 14),

              // ==========================================
              // â‘¢ TAKE A SMALL PAUSE CARD
              // ==========================================
              _buildTakePauseCard(strings),
              const SizedBox(height: 18),

              // ==========================================
              // â‘£ WHAT WOULD HELP RIGHT NOW?
              // ==========================================
              Text(
                strings.whatWouldHelpRightNow,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF0C4D38),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),
              _buildHelpActionGrid(strings),
              const SizedBox(height: 16),

              // ==========================================
              // â‘¤ A GENTLE THOUGHT
              // ==========================================
              _buildGentleThoughtCard(strings),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// â‘¡ Daily Mood Check-in Card
  Widget _buildMoodCheckinCard(dynamic strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const color(0xFFEBF5F0), // Soft mint container
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const color(0xFFD6EAE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const color(0xFF0F5B46).withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.aMomentForYourself,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color(0xFF247D6B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.howAreYouFeelingRightNow,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: color(0xFF0C4D38),
            ),
          ),
          const SizedBox(height: 14),

          // 5 Mood Options (Great, Okay, Low, Anxious, Overwhelmed)
          Row(
            children: TodayMood.values.map((mood) {
              final isSelected = _selectedMood == mood;
              final localizedLabel = switch (mood) {
                TodayMood.great => strings.moodGreat,
                TodayMood.okay => strings.moodOkay,
                TodayMood.low => strings.moodLow,
                TodayMood.anxious => strings.moodAnxious,
                TodayMood.overwhelmed => strings.moodOverwhelmed,
              };

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Material(
                    color: isSelected ? const color(0xFFD5ECE0) : colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? const color(0xFF0F5B46)
                            : const color(0xFFDCECE4),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    elevation: isSelected ? 1 : 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _onSelectMood(mood),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mood.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              localizedLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? const color(0xFF0C4D38)
                                    : const color(0xFF1D3C33),
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
          const SizedBox(height: 14),

          // Supportive Response Preview if mood selected
          if (_supportiveResponse != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.white.withAlpha(200),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const color(0xFF0F5B46).withAlpha(35)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: color(0xFF0F5B46),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _supportiveResponse!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: color(0xFF1D3C33),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Action Button: "Check in with your mood â†’"
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: const color(0xFF0F5B46),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const color(0xFF0F5B46).withAlpha(45),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _submitMoodCheckin,
                child: Center(
                  child: Text(
                    strings.checkInWithMood,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// â‘¢ Take a small pause Card
  Widget _buildTakePauseCard(dynamic strings) {
    return Material(
      color: colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: color(0xFFE4EDE7), width: 1.2),
      ),
      elevation: 0,
      shadowcolor: colors.black.withAlpha(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onNavigateToPause,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const color(0xFFE2F0EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.air_rounded,
                    color: color(0xFF0F5B46),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.takeSmallPauseTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF1D3C33),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.takeSmallPauseSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: color(0xFF5E7369),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: color(0xFF7A9489),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// â‘£ 4 Action Prompt Cards (2x2 Grid)
  Widget _buildHelpActionGrid(dynamic strings) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HelpActionCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: strings.talkItOutTitle,
                subtitle: strings.talkItOutSubtitle,
                onTap: widget.onNavigateToTalk,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HelpActionCard(
                icon: Icons.menu_book_outlined,
                title: strings.exploreTitle,
                subtitle: strings.exploreSubtitle,
                onTap: widget.onNavigateToExplore,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _HelpActionCard(
                icon: Icons.edit_note_rounded,
                title: strings.myJournalTitle,
                subtitle: strings.myJournalSubtitle,
                onTap: () {
                  if (widget.onNavigateToJournal != null) {
                    widget.onNavigateToJournal!();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HelpActionCard(
                icon: Icons.favorite_border_rounded,
                title: strings.findSupportTitle,
                subtitle: strings.findSupportSubtitle,
                onTap: widget.onNavigateToHelp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// â‘¤ A gentle thought Card
  Widget _buildGentleThoughtCard(dynamic strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const color(0xFFE5EDE8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.gentleThoughtTitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color(0xFF247D6B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            strings.gentleThoughtQuote,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: color(0xFF1D3C33),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpActionCard({
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
        side: const BorderSide(color: color(0xFFE5EDE8), width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: const color(0xFF0F5B46),
                size: 22,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF1D3C33),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: color(0xFF5E7369),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

