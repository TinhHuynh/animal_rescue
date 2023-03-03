import 'package:flutter/cupertino.dart';

void showActionSheet(BuildContext context, String title, String message,
    List<SheetAction> actions) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(title),
      message: Text(message),
      actions: actions
          .map((e) => CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  e.onTap.call();
                },
                isDestructiveAction: e.isDestructiveAction,
                child: Text(e.title),
              ))
          .toList(),
    ),
  );
}

class SheetAction {
  final Function onTap;
  final String title;
  final bool isDestructiveAction;

  SheetAction(this.onTap, this.title, {this.isDestructiveAction = false});
}
