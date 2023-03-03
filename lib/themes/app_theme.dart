import 'package:animal_rescue/gen/colors.gen.dart';
import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';

ThemeData appTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
    fontFamily: FontFamily.lato,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: ColorName.brand),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            textStyle: MaterialStateProperty.all(const TextStyle(
                fontFamily: FontFamily.lato,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 52)))),
    scaffoldBackgroundColor: Colors.white);
