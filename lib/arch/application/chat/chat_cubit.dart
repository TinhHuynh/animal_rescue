import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:enum_annotation/enum_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/case/enums/case_status.dart';
import '../../domain/case/repositories/case_repository.dart';
import '../../domain/chat/entities/message.dart';
import '../../domain/chat/failures/failure.dart';
import '../../domain/chat/repositories/chat_repository.dart';
import '../../domain/chat/value_objects/value_object.dart';
import '../../domain/core/value_objects.dart';

part 'chat_cubit.freezed.dart';

part 'chat_cubit.g.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;
  final CaseRepository _caseRepository;
  StreamSubscription<Message>? newMessageSub;

  ChatCubit(this._chatRepository, this._authRepository, this._caseRepository)
      : super(ChatState.initial());

  Future<void> submitMessage(UniqueId caseId, String text) async {
    if (!await _isCaseActive(caseId)) {
      emit(state.copyWith(
          event: ChatEvent.submitMessageFailed,
          submitMessageOptions: Some(left(const ChatFailure.failedToSubmitMessage()))));
    }
    emit(state.copyWith(event: ChatEvent.submittingLoading));
    final result =
        await _chatRepository.submitMessage(caseId, MessageContent(text));
    emit(result.fold(
        (l) => state.copyWith(
            event: ChatEvent.submitMessageFailed,
            submitMessageOptions: Some(left(l))),
        (r) => state.copyWith(
            event: ChatEvent.submitMessageSuccess,
            submitMessageOptions: Some(right(unit)))));
  }

  Future getMessagesFor(UniqueId caseId, MessageDate? beforeDate) async {
    emit(state.copyWith(event: ChatEvent.loadingPage));
    await _chatRepository
        .getMessages(caseId, beforeDate, pageSize: 20)
        .then((value) => _processPaging(caseId, beforeDate, value));
  }

  _processPaging(UniqueId caseId, MessageDate? afterMessageDate,
      Either<ChatFailure, List<Message>> value) {
    value.fold(
        (l) => emit(state.copyWith(
            event: ChatEvent.loadPageFailed,
            loadPageOptions: some(left(l)))), (r) {
      if (r.isNotEmpty) {
        final nextPageKey = r.last.createdDate;
        emit(state.copyWith(
            event: ChatEvent.appendPage,
            loadPageOptions:
                some(right(PagingData(r, nextItemKey: nextPageKey)))));
        setUpNewMessageObserve(caseId, beforeDate: r.first.createdDate);
      } else {
        emit(state.copyWith(
            event: ChatEvent.appendLastPage,
            loadPageOptions: some(right(PagingData(r)))));
        setUpNewMessageObserve(caseId);
      }
    });
  }

  void setUpNewMessageObserve(UniqueId caseId, {MessageDate? beforeDate}) {
    if (newMessageSub != null) return;
    newMessageSub =
        _chatRepository.getNewMessageStream(caseId, beforeDate).listen((event) {
      emit(state.copyWith(event: ChatEvent.newMessage, newMessage: event));
    });
  }

  bool isMyMessage(Message message) {
    final userId = _authRepository.getUserId() ?? '';
    return userId == message.user.uid.getOrCrash();
  }

  @override
  Future<void> close() {
    newMessageSub?.cancel();
    return super.close();
  }

  Future<CaseStatus> getCaseStatus(UniqueId caseId) async {
    try {
      return await _caseRepository.getCaseStatus(caseId);
    } catch (e) {
      return CaseStatus.unknown;
    }
  }

  Future<bool> _isCaseActive(UniqueId caseId) {
    return getCaseStatus(caseId).then((value) => value == CaseStatus.active);
  }
}
