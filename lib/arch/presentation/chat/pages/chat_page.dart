import 'package:animal_rescue/di/get_it.dart';
import 'package:animal_rescue/extensions/any_x.dart';
import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/chat/chat_cubit.dart';
import '../../../domain/case/enums/case_status.dart';
import '../../../domain/core/value_objects.dart';
import '../../core/widgets/custom_annotated_region.dart';
import '../../core/widgets/lifecycle_aware.dart';
import '../widgets/message_list.dart';


class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.caseId}) : super(key: key);

  final TextEditingController _textController = TextEditingController();
  final UniqueId caseId;

  @override
  Widget build(BuildContext context) {
    return LifecycleAware(
        child: BlocProvider(
      create: (context) => getIt<ChatCubit>(),
      child: CustomAnnotatedRegion(
        statusBarColor: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            leading: backIcon(context),
            title: Text(context.s.chat),
          ),
          body: Builder(builder: (context) {
            return Column(
              children: [
                _messageList(context),
                _divider(context),
                _input(context)
              ],
            );
          }),
        ),
      ),
    ));
  }

  _messageList(BuildContext context) {
    return MessageList(
      caseId: caseId,
    );
  }

  _input(BuildContext context) {
    return FutureBuilder(
        future: context.read<ChatCubit>().getCaseStatus(caseId),
        builder: (context, snapshot) =>
            (snapshot.data == null || snapshot.data! != CaseStatus.active)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 12, top: 8, bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: _textController,
                      onChanged: (s) {},
                      decoration: _inputIcon(context),
                    ),
                  ));
  }

  _inputIcon(BuildContext context) {
    return InputDecoration(
        hintText: context.s.type_a_message,
        border: InputBorder.none,
        filled: false,
        suffixIcon: BlocConsumer<ChatCubit, ChatState>(
          listener: (ctx, state) => state.event.maybeWhen(
              orElse: () {},
              submitMessageSuccess: () => _textController.clear(),
              submitMessageFailed: () =>
                  showError(ctx, ctx.s.failed_to_submit_message)),
          buildWhen: (_, state) => state.event.maybeWhen(
              orElse: () => false,
              submittingLoading: () => true,
              submitMessageFailed: () => true,
              submitMessageSuccess: () => true),
          builder: (context, state) {
            return state.event.maybeWhen(
                orElse: () => GestureDetector(
                    onTap: () {
                      context
                          .read<ChatCubit>()
                          .submitMessage(caseId, _textController.text);
                    },
                    child: const Icon(Icons.send)),
                submittingLoading: () => Transform.scale(
                    scale: 0.4, child: const CircularProgressIndicator()));
          },
        ));
  }

  _divider(BuildContext context) {
    return Container(
      color: Colors.black,
      width: context.mediaQuery.size.width,
      height: 1,
    );
  }
}
