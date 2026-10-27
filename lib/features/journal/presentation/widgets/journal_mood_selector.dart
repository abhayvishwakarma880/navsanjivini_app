import 'package:flutter/material.dart';
import 'package:app/core/localization/language_scope.dart';

class JournalMoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String?> onMoodSelected;

  const JournalMoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<Map<String, String>> _moods = [
    {'id': 'good', 'emoji': 'ðŸ˜Š'},
    {'id': 'calm', 'emoji': 'ðŸ˜Œ'},
    {'id': 'low', 'emoji': 'ðŸ˜”'},
    {'id': 'anxious', 'emoji': 'ðŸ˜°'},
  ];

  String _getMoodLabel(String id, dynamic strings) {
    switch (id) {
      case 'good':
        return strings.journalMoodGood;
      case 'calm':
        return strings.journalMoodCalm;
      case 'low':
        return strings.journalMoodLow;
      case 'anxious':
        return strings.journalMoodAnxious;
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.tr;

    return Row(
      children: _moods.map((m) {
        final id = m['id']!;
        final emoji = m['emoji']!;
        final isSelected = selectedMood == id;
        final isLast = m == _moods.last;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: Material(
              color: isSelected ? const color(0xFFE5F2EC) : colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isSelected ? const color(0xFF165A47) : const color(0xFFE4EDE7),
                  width: isSelected ? 1.5 : 1.1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  if (isSelected) {
                    onMoodSelected(null);
                  } else {
                    onMoodSelected(id);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getMoodLabel(id, strings),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const color(0xFF165A47)
                              : const color(0xFF4D6D63),
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
    );
  }
}

