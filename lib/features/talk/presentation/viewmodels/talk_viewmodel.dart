import 'package:flutter/foundation.dart';
import '../../domain/entities/talk_message.dart';
import '../../domain/repositories/talk_repository.dart';

class TalkViewModel extends ChangeNotifier {
  final TalkRepository? repository;

  TalkViewModel({this.repository}) {
    _initDefaultConversation();
  }

  final List<TalkMessage> _messages = [];
  bool _isSending = false;
  bool _isTyping = false;

  List<TalkMessage> get messages => List.unmodifiable(_messages);
  bool get isSending => _isSending;
  bool get isTyping => _isTyping;

  void _initDefaultConversation() {
    _messages.clear();
    _messages.addAll([
      TalkMessage(
        id: 'msg_1',
        text: "Hi there 🌿 I'm here to listen. What's been on your mind today?",
        sender: MessageSender.ai,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      TalkMessage(
        id: 'msg_2',
        text: "I've been feeling a little overwhelmed lately.",
        sender: MessageSender.user,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      TalkMessage(
        id: 'msg_3',
        text:
            "That sounds like a lot to carry. Would you like to talk about what's been feeling overwhelming?",
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ),
    ]);
  }

  Future<void> sendUserMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) return;

    final userMsg = TalkMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isSending = true;
    _isTyping = true;
    notifyListeners();

    try {
      if (repository != null) {
        final aiResponse = await repository!.sendMessage('default', trimmed);
        _messages.add(aiResponse);
      } else {
        // Mock supportive emotional companion response with realistic thinking pause
        await Future.delayed(const Duration(milliseconds: 700));
        final replyText = _generateSupportiveReply(trimmed);
        _messages.add(
          TalkMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: replyText,
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
          ),
        );
      }
    } finally {
      _isSending = false;
      _isTyping = false;
      notifyListeners();
    }
  }

  String _generateSupportiveReply(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('anxious') ||
        lower.contains('panic') ||
        lower.contains('scared') ||
        lower.contains('fear') ||
        lower.contains('nervous') ||
        lower.contains('overthink')) {
      return "When anxiety shows up, our thoughts can feel so fast. Let's take a slow breath together. Inhale gently... and exhale. You are safe in this moment.";
    } else if (lower.contains('overwhelm') ||
        lower.contains('pressure') ||
        lower.contains('heavy') ||
        lower.contains('stress') ||
        lower.contains("can't handle")) {
      return "That sounds like a lot to carry. Take a gentle breath with me. What is the one thing feeling heaviest right now?";
    } else if (lower.contains('work') ||
        lower.contains('stud') ||
        lower.contains('exam') ||
        lower.contains('college') ||
        lower.contains('job') ||
        lower.contains('office') ||
        lower.contains('boss')) {
      return "Work and study demands can build up quietly until they feel heavy. Would you like to break it down into smaller pieces together, or simply vent about what happened?";
    } else if (lower.contains('feel') ||
        lower.contains('sad') ||
        lower.contains('cry') ||
        lower.contains('low') ||
        lower.contains('lonely') ||
        lower.contains('hurt')) {
      return "Whatever you are feeling right now is completely okay to feel. You don't have to carry it alone. I'm right here with you—take all the time you need.";
    } else if (lower.contains('vent') ||
        lower.contains('angry') ||
        lower.contains('frustrat') ||
        lower.contains('mad') ||
        lower.contains('annoy')) {
      return "I am right here to listen with an open heart. Go ahead and let it all out. What has been on your mind?";
    } else if (lower.contains('tired') ||
        lower.contains('exhaust') ||
        lower.contains('sleep') ||
        lower.contains('drain')) {
      return "Your mind and body work so hard. It is okay to rest, even if there are things left unfinished today. Have you been able to take a pause today?";
    } else if (lower.contains('thank') ||
        lower.contains('good') ||
        lower.contains('happy') ||
        lower.contains('better') ||
        lower.contains('peace')) {
      return "I'm so glad to hear that. Moments of ease and lightness are worth celebrating. What helped bring this sense of ease to your day?";
    } else {
      return "Thank you for sharing that with me. It takes courage to open up. Tell me more about what that has been like for you.";
    }
  }

  void clearConversation() {
    _messages.clear();
    _messages.add(
      TalkMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Hi there 🌿 I'm here to listen. What's been on your mind today?",
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
