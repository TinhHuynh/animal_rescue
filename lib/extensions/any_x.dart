import 'package:animal_rescue/extensions/context_x.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../arch/presentation/core/dialogs/alert_dialog.dart';
import '../gen/colors.gen.dart';

extension AnyX on dynamic {
  bool isOneOf(List items) => items.contains(this);
}

showLoading() {
  EasyLoading.show();
}

hideLoading() {
  EasyLoading.dismiss();
}

toggleLoading(bool toggle) {
  toggle ? showLoading() : hideLoading();
}

showError(BuildContext context, String message) {
  showAlertDialog(context, context.s.error, message, [
    AlertDialogAction(context.s.ok, () {
      context.navigator.pop();
    })
  ]);
}

showToast(String message, {backgroundColor = ColorName.brand}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

backIcon(BuildContext context) {
  return GestureDetector(
    onTap: () {
      context.back();
    },
    child: const Icon(
      Icons.arrow_back_ios_new,
      color: Colors.black,
    ),
  );
}

double paddingTopOr(BuildContext context, double paddingTop) {
  return context.mediaQuery.padding.top != 0
      ? context.mediaQuery.padding.top
      : paddingTop;
}

double paddingBottomOr(BuildContext context, double paddingTop) {
  return context.mediaQuery.padding.bottom != 0
      ? context.mediaQuery.padding.bottom
      : paddingTop;
}
