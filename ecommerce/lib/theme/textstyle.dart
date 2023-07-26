import 'package:flutter/material.dart';

TextStyle titleTextStyle() {
  return const TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}

TextStyle subtitleTextStyle() {
  return const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Color(0xFF5F5F5F));
}

TextStyle editTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) {
  return TextStyle(
    fontFamily: 'Montserrat',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}