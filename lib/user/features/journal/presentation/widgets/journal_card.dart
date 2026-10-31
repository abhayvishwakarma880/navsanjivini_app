import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/utils/date_time_utils.dart';
import '../../domain/entities/journal_entry.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onOptionsTap;

  const JournalCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onOptionsTap,
  });

  String _getMoodEmoji(String? mood) {
    switch (mood) {
      case 'good':
        return '😊';
      case 'calm':
        return '😌';
      case 'low':
        return '😔';
      case 'anxious':
        return '😰';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;
    final moodEmoji = _getMoodEmoji(entry.mood);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Date / Time + Mood + More Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        DateTimeUtils.formatRelativeDate(entry.createdAt),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF5E7369),
                        ),
                      ),
                      if (moodEmoji.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          moodEmoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: Color(0xFF7A8E85),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    onPressed: onOptionsTap,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF123C32),
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 6),

              // Preview Body
              Text(
                entry.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.2,
                  color: Color(0xFF5E7369),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Private Badge
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: Color(0xFF6E8078),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    strings.journalPrivateBadge,
                    style: const TextStyle(
                      fontSize: 11.8,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6E8078),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
