import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/utils/date_time_utils.dart';
import '../../domain/entities/journal_entry.dart';
import '../viewmodels/journal_viewmodel.dart';
import 'journal_entry_screen.dart';

class JournalDetailScreen extends StatelessWidget {
  final JournalEntry entry;
  final JournalViewModel viewModel;

  const JournalDetailScreen({
    super.key,
    required this.entry,
    required this.viewModel,
  });

  String _getMoodLabel(String? mood, dynamic strings) {
    switch (mood) {
      case 'good':
        return 'ðŸ˜Š ${strings.journalMoodGood}';
      case 'calm':
        return 'ðŸ˜Œ ${strings.journalMoodCalm}';
      case 'low':
        return 'ðŸ˜” ${strings.journalMoodLow}';
      case 'anxious':
        return 'ðŸ˜° ${strings.journalMoodAnxious}';
      default:
        return '';
    }
  }

  void _confirmDelete(BuildContext context) {
    final strings = context.tr;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundcolor: colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          strings.journalDeleteConfirmTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color(0xFF123C32),
          ),
        ),
        content: Text(
          strings.journalDeleteConfirmMessage,
          style: const TextStyle(fontSize: 14, color: color(0xFF5E7369)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              strings.journalCancel,
              style: const TextStyle(color: color(0xFF5E7369), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundcolor: const color(0xFFD32F2F),
              foregroundcolor: colors.white,
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              viewModel.deleteEntry(entry.id);
              Navigator.of(context).pop();
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

  void _openEdit(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JournalEntryScreen(
          entryToEdit: entry,
          onSave: (title, body, mood) {
            viewModel.updateEntry(
              entry.id,
              title: title,
              body: body,
              mood: mood,
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final moodText = _getMoodLabel(entry.mood, strings);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: color(0xFF165A47)),
            tooltip: strings.journalEdit,
            onPressed: () => _openEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: color(0xFFD32F2F)),
            tooltip: strings.journalDelete,
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timestamp & Mood pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTimeUtils.formatFullDateTime(entry.createdAt),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: color(0xFF5E7369),
                    ),
                  ),
                  if (moodText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const color(0xFFE5F2EC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const color(0xFFD2E6DC)),
                      ),
                      child: Text(
                        moodText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color(0xFF165A47),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color(0xFF123C32),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),

              // Divider
              Container(
                width: double.infinity,
                height: 1.1,
                color: const color(0xFFE4EDE7),
              ),
              const SizedBox(height: 16),

              // Body Content
              Text(
                entry.body.isEmpty ? 'â€”' : entry.body,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: color(0xFF2C3E37),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),

              // Private Guarantee Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const color(0xFFE4EDE7),
                    width: 1.1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: color(0xFFE5F2EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: color(0xFF165A47),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Private & Local',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: color(0xFF123C32),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'This reflection is saved securely on your device. It is never shared with AI companion or external services.',
                            style: TextStyle(
                              fontSize: 12,
                              color: color(0xFF5E7369),
                              height: 1.35,
                            ),
                          ),
                        ],
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

