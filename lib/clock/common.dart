import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

Widget textViews(bool isHour, String text,Color color2, double opacity, FontWeight weight) {
  return GradientText(
    isHour ? '$text' : '$text',
    gradient: LinearGradient(colors: [
      Color.lerp(Colors.cyan[600], color2, opacity), Color.lerp(Colors.cyan[700], color2, opacity)
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    style: TextStyle(
        letterSpacing: 2.0,
        fontFamily: 'BananaBrickTweaked',
        fontWeight: weight),
  );
}