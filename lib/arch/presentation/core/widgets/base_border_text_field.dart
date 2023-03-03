
import 'package:flutter/material.dart';

abstract class BaseBorderTextFieldState<T extends StatefulWidget> extends State<T>{
  late FocusNode? focusNode;
  bool isFocused = false;

  void setFocusNode(FocusNode node){
    focusNode = node;
  }

  @override
  void initState() {
    focusNode?.addListener(() {
      setState(() {
        isFocused = focusNode?.hasFocus ?? false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }
}