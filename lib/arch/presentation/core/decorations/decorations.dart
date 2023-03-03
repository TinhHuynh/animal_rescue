import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';


const borderInputDecorator = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.grey,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorName.brand, width: 1),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1),
  ),
);