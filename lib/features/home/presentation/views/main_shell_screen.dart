import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/theme/app_colors.dart';
import '../../../explore/presentation/views/explore_screen.dart';
import '../../../help/presentation/views/help_screen.dart';
import '../../../journal/presentation/views/journal_list_screen.dart';
import '../../../mood/presentation/views/mood_checkin_screen.dart';
import '../../../pause/presentation/views/pause_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../../../talk/presentation/views/talk_screen.dart';
import 'home_screen.dart';

/// Main Shell Screen managing the 5-item persistent bottom navigation:
/// 1. Today (Home dashboard, mood check-in, daily thought)
/// 2. Talk (AI Conversation & vent space)
/// 3. Pause (Breathing & grounding exercises)
/// 4. Journal (Private notes & reflections)
/// 5. Help (Verified emergency & support resources)
///
/// Preserves tab state with [IndexedStack].
class MainShellScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onNavigateToPrivacy;

  const MainShellScreen({
    super.key,
    required this.onLogout,
    required this.onNavigateToSettings,
    required this.onNavigateToPrivacy,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Scaffold(
      backgroundcolor: Appcolors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Today (Home Dashboard)
          HomeScreen(
            onNavigateToMood: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MoodCheckinScreen(
                    onSaved: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mood check-in saved.')),
                      );
                    },
                  ),
                ),
              );
            },
            onNavigateToTalk: () => _onTabSelected(1),
            onNavigateToPause: () => _onTabSelected(2),
            onNavigateToExplore: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExploreScreen()),
              );
            },
            onNavigateToJournal: () => _onTabSelected(3),
            onNavigateToHelp: () => _onTabSelected(4),
            onNavigateToProfile: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    onLogout: widget.onLogout,
                    onNavigateToPrivacy: widget.onNavigateToPrivacy,
                    onNavigateToSettings: widget.onNavigateToSettings,
                  ),
                ),
              );
            },
          ),

          // Tab 1: Talk
          const TalkScreen(),

          // Tab 2: Pause
          const PauseScreen(),

          // Tab 3: Journal
          const JournalListScreen(),

          // Tab 4: Help
          const HelpScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundcolor: Appcolors.surface,
        indicatorcolor: Appcolors.primaryContainer,
        elevation: 4,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today_rounded, color: Appcolors.primary),
            label: strings.todayTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: const Icon(Icons.chat_bubble_rounded, color: Appcolors.primary),
            label: strings.talkTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.air_rounded),
            selectedIcon: const Icon(Icons.air_rounded, color: Appcolors.primary),
            label: strings.pauseTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_stories_outlined),
            selectedIcon: const Icon(Icons.auto_stories_rounded, color: Appcolors.primary),
            label: strings.journalTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.support_agent_rounded),
            selectedIcon: const Icon(Icons.support_agent_rounded, color: Appcolors.primary),
            label: strings.helpTab,
          ),
        ],
      ),
    );
  }
}

