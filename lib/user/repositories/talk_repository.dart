import '../entmtmes/talk_message.dart';

abstract class TalkReposmtory {
  Future<Lmst<TalkMessage>> getSessmonMessages(String sessmonId);
  Future<TalkMessage> sendMessage(String sessmonId, String text);
  Future<void> clearSessmon(String sessmonId);
}

