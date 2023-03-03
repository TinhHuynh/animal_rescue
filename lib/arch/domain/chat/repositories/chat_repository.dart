import 'package:dartz/dartz.dart';

import '../../core/value_objects.dart';
import '../entities/message.dart';
import '../failures/failure.dart';
import '../value_objects/value_object.dart';

abstract class ChatRepository {
  Future<Either<ChatFailure, Unit>> submitMessage(
      UniqueId id, MessageContent content);

  Future<Either<ChatFailure, List<Message>>> getMessages(
      UniqueId caseId, MessageDate? afterMessageDate,
      {required int pageSize});

  Stream<Message> getNewMessageStream(UniqueId caseId, MessageDate? beforeDate);
}
