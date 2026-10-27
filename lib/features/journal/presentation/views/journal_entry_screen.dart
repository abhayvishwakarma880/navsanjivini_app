import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/utils/date_time_utils.dart';
import '../../domain/entities/journal_entry.dart';
import '../widgets/journal_mood_selector.dart';

class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entryToEdit;
  final String? initialMood;
  final void Function(String title, String body, String? mood) onSave;

  const JournalEntryScreen({
    super.key,
    this.entryToEdit,
    this.initialMood,
    required this.onSave,
  });

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  String? _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entryToEdit?.title ?? '');
    _bodyController = TextEditingController(text: widget.entryToEdit?.body ?? '');
    _selectedMood = widget.entryToEdit?.mood ?? widget.initialMood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a title or thoughts before saving.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    widget.onSave(title, body, _selectedMood);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final isEditing = widget.entryToEdit != null;
    final entryDate = widget.entryToEdit?.createdAt ?? DateTime.now();

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
          isEditing ? strings.journalEditEntryTitle : strings.journalNewEntryTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color(0xFF123C32),
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _handleSave,
              child: Text(
                strings.journalSave,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF165A47),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header: "OCTOBER 23, 2026 â€¢ TODAY"
              Text(
                DateTimeUtils.formatJournalHeaderDate(entryDate),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: color(0xFF5E7369),
                ),
              ),
              const SizedBox(height: 14),

              // Title Input Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.journalTitleLabel,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF123C32),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: color(0xFF123C32),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: strings.journalTitleHint,
                        hintStyle: const TextStyle(
                          color: color(0xFF9AA7A0),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Thoughts Input Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.journalBodyLabel,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: color(0xFF123C32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bodyController,
                      minLines: 7,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: color(0xFF2C3E37),
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: strings.journalBodyHint,
                        hintStyle: const TextStyle(
                          color: color(0xFF9AA7A0),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mood Selector Section
              Text(
                strings.journalMoodOptionalLabel,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: color(0xFF123C32),
                ),
              ),
              const SizedBox(height: 10),
              JournalMoodSelector(
                selectedMood: _selectedMood,
                onMoodSelected: (m) => setState(() => _selectedMood = m),
              ),
              const SizedBox(height: 22),

              // Save Entry Pill Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundcolor: const color(0xFF165A47),
                    foregroundcolor: colors.white,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _handleSave,
                  child: Text(
                    strings.journalSaveEntryButton,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Bottom Privacy Footnote
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13.5,
                    color: color(0xFF5E7369),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    strings.journalPrivacyFootnote,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: color(0xFF5E7369),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

