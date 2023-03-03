import 'package:flutter/material.dart';

class KeyboardUtils {
  static void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
