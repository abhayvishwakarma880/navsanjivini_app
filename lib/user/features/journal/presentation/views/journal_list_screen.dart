import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import '../../domain/entities/journal_entry.dart';
import '../viewmodels/journal_viewmodel.dart';
import '../widgets/journal_card.dart';
import '../widgets/journal_mood_selector.dart';
import 'journal_detail_screen.dart';
import 'journal_entry_screen.dart';

class JournalListScreen extends StatefulWidget {
  final JournalViewModel? viewModel;

  const JournalListScreen({super.key, this.viewModel});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  late final JournalViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = JournalViewModel();
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  void _openWriteNewEntry([String? preselectedMood]) {
    HapticFeedback.lightImpact();
    final moodToPass = preselectedMood ?? _viewModel.selectedQuickMood;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalEntryScreen(
          initialMood: moodToPass,
          onSave: (title, body, mood) {
            _viewModel.addEntry(title: title, body: body, mood: mood);
            _viewModel.clearQuickMood();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.journalSavedToast),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openDetail(JournalEntry entry) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalDetailScreen(
          entry: entry,
          viewModel: _viewModel,
        ),
      ),
    );
  }

  void _openEdit(JournalEntry entry) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalEntryScreen(
          entryToEdit: entry,
          onSave: (title, body, mood) {
            _viewModel.updateEntry(entry.id, title: title, body: body, mood: mood);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.journalSavedToast),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(JournalEntry entry) {
    final strings = context.tr;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          strings.journalDeleteConfirmTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF123C32),
          ),
        ),
        content: Text(
          strings.journalDeleteConfirmMessage,
          style: const TextStyle(fontSize: 14, color: Color(0xFF5E7369)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              strings.journalCancel,
              style: const TextStyle(color: Color(0xFF5E7369), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _viewModel.deleteEntry(entry.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.journalDeletedToast),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(strings.journalDelete),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(JournalEntry entry) {
    final strings = context.tr;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF123C32),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.visibility_outlined, color: Color(0xFF165A47)),
                title: Text(
                  strings.journalReadEntry,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123C32)),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openDetail(entry);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit_outlined, color: Color(0xFF165A47)),
                title: Text(
                  strings.journalEdit,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123C32)),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openEdit(entry);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F)),
                title: Text(
                  strings.journalDelete,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFD32F2F)),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmDelete(entry);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final entries = _viewModel.entries;

            return SingleChildScrollView(
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
                              strings.journalHeaderTitle,
                              style: const TextStyle(
                                fontSize: 19.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF123C32),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              strings.journalHeaderSubtitle,
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
                            Icons.menu_book_rounded,
                            color: Color(0xFF165A47),
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ==========================================
                  // 2. FEATURED MINT CARD
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
                        Text(
                          strings.journalHowFeelingToday,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF123C32),
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.journalCheckInSubtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4D6D63),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4 Mood Option Cards
                        JournalMoodSelector(
                          selectedMood: _viewModel.selectedQuickMood,
                          onMoodSelected: (m) {
                            _viewModel.selectQuickMood(m);
                          },
                        ),
                        const SizedBox(height: 16),

                        // + Write a new entry Pill Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF165A47),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            onPressed: () => _openWriteNewEntry(),
                            child: Text(
                              strings.journalWriteNewEntryButton,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ==========================================
                  // 3. YOUR REFLECTIONS SECTION
                  // ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strings.journalYourReflections,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF123C32),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF165A47),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                        ),
                        child: Text(
                          strings.journalViewAll,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF165A47),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Reflections List
                  if (entries.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFE4EDE7),
                          width: 1.1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5F2EC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF165A47),
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            strings.journalEmptyTitle,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF123C32),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.journalEmptySubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5E7369),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: JournalCard(
                          entry: entry,
                          onTap: () => _openDetail(entry),
                          onOptionsTap: () => _showOptionsSheet(entry),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
