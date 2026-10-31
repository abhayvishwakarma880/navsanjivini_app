import '../../domain/entities/talk_message.dart';

abstract class TalkRemoteDataSource {
  Future<TalkMessage> postMessage(String sessionId, String userMessage);
}
