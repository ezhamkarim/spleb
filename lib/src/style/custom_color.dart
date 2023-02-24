import 'package:flutter/material.dart';

class CustomColor {
  static const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFE1E7EC),
    100: Color(0xFFB5C2CF),
    200: Color(0xFF839AAF),
    300: Color(0xFF51718F),
    400: Color(0xFF2C5277),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFF062F57),
    700: Color(0xFF05274D),
    800: Color(0xFF042143),
    900: Color(0xFF021532),
  });
  static const int _primaryPrimaryValue = 0xFF07345F;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFF6A95FF),
    200: Color(_primaryAccentValue),
    400: Color(0xFF044CFF),
    700: Color(0xFF0043EA),
  });
  static const int _primaryAccentValue = 0xFF3770FF;

  static const secondary = Color(0xff1DDDFF);
}
