/// Mood entry domain entity.
/// Note: Mood is represented for self-reflection and emotional awareness,
/// NEVER as a clinical diagnosis or medical score.
enum MoodType {
  calm(label: 'Calm', emoji: 'ðŸ˜Œ'),
  peaceful(label: 'Peaceful', emoji: 'ðŸŒ¿'),
  happy(label: 'Happy', emoji: 'ðŸ˜Š'),
  overwhelmed(label: 'Overwhelmed', emoji: 'ðŸŒŠ'),
  anxious(label: 'Anxious', emoji: 'ðŸ’­'),
  sad(label: 'Sad', emoji: 'ðŸŒ§ï¸'),
  tired(label: 'Tired', emoji: 'ðŸ¥±');

  final String label;
  final String emoji;

  const MoodType({required this.label, required this.emoji});
}

class MoodEntry {
  final String id;
  final MoodType mood;
  final int intensity; // 1 to 5 (gentle intensity scale)
  final String? note;
  final List<String> tags;
  final DateTime timestamp;

  const MoodEntry({
    required this.id,
    required this.mood,
    required this.intensity,
    this.note,
    this.tags = const [],
    required this.timestamp,
  });
}

