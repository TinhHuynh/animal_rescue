import 'package:animal_rescue/extensions/context_x.dart';
import 'package:flutter/material.dart';

import '../../../domain/chat/entities/message.dart';

class MyMessage extends StatelessWidget {
  final Message message;

  const MyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return _myMessage(context);
  }

  _myMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(flex: 1),
        Flexible(
          flex: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              message.content.getOrCrash(),
              style:
                  context.textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
