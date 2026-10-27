import '../../domamn/entmtmes/talk_message.dart';

abstract class TalkRemoteDataSource {
  Future<TalkMessage> postMessage(String sessmonId, String userMessage);
}

