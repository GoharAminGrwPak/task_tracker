import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstants {

  ColorConstants._();

  static const int _whitePrimaryValue = 0xFFFFFFFF;
  static const MaterialColor white = MaterialColor(
    _whitePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_whitePrimaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static const mainColor = Color(0xFF26baed);
  static const successColor = Color(0xff00B43D);
  static const redColor = Color(0xFFc62a2b);
  static const redColorAccent = Colors.redAccent;
  static const greyColor = Colors.grey;
}