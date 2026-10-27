import '../entities/talk_message.dart';

abstract class TalkRepository {
  Future<List<TalkMessage>> getSessionMessages(String sessionId);
  Future<TalkMessage> sendMessage(String sessionId, String text);
  Future<void> clearSession(String sessionId);
}

