import 'package:flutter/material.dart';

const Color mainColor = Color(0xFFFFEED6);
const Color secondaryColor = Color(0xFFF3712E);

const String fontFamily = 'Roboto';

final ThemeData appTheme = ThemeData(
  primaryColor: mainColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
  fontFamily: fontFamily,
);
