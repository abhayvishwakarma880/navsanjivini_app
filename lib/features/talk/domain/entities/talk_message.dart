enum MessageSender { user, ai, system }

class TalkMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isSafetyRouting;

  const TalkMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isSafetyRouting = false,
  });
}
