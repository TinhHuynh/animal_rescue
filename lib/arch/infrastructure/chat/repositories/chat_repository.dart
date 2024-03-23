import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/value_objects/value_object.dart';
import '../../../domain/chat/entities/message.dart';
import '../../../domain/chat/failures/failure.dart';
import '../../../domain/chat/repositories/chat_repository.dart';
import '../../../domain/chat/value_objects/value_object.dart';
import '../../../domain/core/value_objects.dart';
import '../../core/firebase/auth_helper.dart';
import '../../core/firebase/firestore_helper.dart';
import '../dtos/message_dto.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final FirestoreHelper _firestoreHelper;
  final AuthHelper _authHelper;

  ChatRepositoryImpl(this._firestoreHelper, this._authHelper);

  @override
  Future<Either<ChatFailure, Unit>> submitMessage(
      UniqueId id, MessageContent content) async {
    try {
      final userId = _authHelper.getUserId();
      if (userId == null) {
        return left(const ChatFailure.failedToSubmitMessage());
      }
      _firestoreHelper.createMessage(
          id.getOrCrash(),
          MessageDto(
              id: const Uuid().v4(),
              userId: userId,
              content: content.getOrCrash(),
              createdDate: DateTime.now(),
              caseId: id.getOrCrash()));
      return right(unit);
    } on UnableToCreateMessage {
      return left(const ChatFailure.failedToSubmitMessage());
    }
  }

  @override
  Future<Either<ChatFailure, List<Message>>> getMessages(
      UniqueId caseId, MessageDate? afterMessageDate,
      {required int pageSize}) async {
    try {
      final List<Message> list = await _firestoreHelper
          .getMessages(caseId.getOrCrash(),
              afterMessageDate?.getOrCrash().millisecondsSinceEpoch, pageSize)
          .then((value) async {
        final List<Message> list = [];
        for (var dto in value) {
          list.add(await _parseMessageDomain(dto));
        }
        return list;
      });
      return right(list);
    } on UnableToLoadMessages {
      return left(const ChatFailure.failedToLoadMessages());
    }
  }

  Future<Message> _parseMessageDomain(MessageDto dto) async {
    final user = await _firestoreHelper
        .getUser(dto.userId)
        .then((value) => value.toDomain())
        .catchError((e) {
      return User(
          uid: UniqueId.fromUniqueString(""),
          email: EmailAddress(""),
          username: Username(""));
    });
    return dto.toDomain(user);
  }

  @override
  Stream<Message> getNewMessageStream(
      UniqueId caseId, MessageDate? beforeDate) {
    StreamController<Message> controller = StreamController();
    _firestoreHelper
        .getNewMessage(caseId.getOrCrash(),
            beforeDate?.getOrCrash().millisecondsSinceEpoch)
        .forEach((element) async {
      controller.sink.add(await _parseMessageDomain(element));
    });
    return controller.stream;
  }
}
