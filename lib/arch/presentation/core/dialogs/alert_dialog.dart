import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String message,
    List<AlertDialogAction> actions,
    {bool barrierDismissible = false}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions
              .map(
                (e) => TextButton(
                  onPressed: e.onTap,
                  child: Text(e.title),
                ),
              )
              .toList());
    },
  );
}

class AlertDialogAction {
  final String title;
  final VoidCallback onTap;

  AlertDialogAction(this.title, this.onTap);
}
