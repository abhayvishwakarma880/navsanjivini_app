import 'package:flutter/foundation.dart';
import '../../domain/entities/talk_message.dart';
import '../../domain/repositories/talk_repository.dart';

class TalkViewModel extends ChangeNotifier {
  final TalkRepository? _repository;

  TalkViewModel({TalkRepository? repository}) : _repository = repository {
    _messages.add(
      TalkMessage(
        id: 'initial',
        text: 'Hello. I am here to listen and help you unpack your thoughts without judgment. How can I support you right now?',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ),
    );
  }

  final List<TalkMessage> _messages = [];
  bool _isSending = false;

  List<TalkMessage> get messages => List.unmodifiable(_messages);
  bool get isSending => _isSending;

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
    notifyListeners();

    try {
      if (_repository != null) {
        final aiResponse = await _repository.sendMessage('default', trimmed);
        _messages.add(aiResponse);
      } else {
        // Mock supportive response
        await Future.delayed(const Duration(milliseconds: 600));
        _messages.add(
          TalkMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: 'I hear you. Thank you for sharing that with me. What would feel most grounding for you in this moment?',
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
          ),
        );
      }
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearConversation() {
    _messages.clear();
    notifyListeners();
  }
}
