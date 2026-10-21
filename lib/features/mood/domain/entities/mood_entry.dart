/// Mood entry domain entity.
/// Note: Mood is represented for self-reflection and emotional awareness,
/// NEVER as a clinical diagnosis or medical score.
enum MoodType {
  calm(label: 'Calm', emoji: '😌'),
  peaceful(label: 'Peaceful', emoji: '🌿'),
  happy(label: 'Happy', emoji: '😊'),
  overwhelmed(label: 'Overwhelmed', emoji: '🌊'),
  anxious(label: 'Anxious', emoji: '💭'),
  sad(label: 'Sad', emoji: '🌧️'),
  tired(label: 'Tired', emoji: '🥱');

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
