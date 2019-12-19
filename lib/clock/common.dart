import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

Widget textViews(bool isDarkMode, bool isHour, String text, Color color,
    double opacity, FontWeight weight) {

  final lightColors = [
    Color.lerp(Colors.white, color, opacity),
    Color.lerp(Colors.white, color, opacity)
  ];

  final darkColors = [
    Color.lerp(Colors.cyan[800], color, opacity),
    Color.lerp(Colors.cyan[900], color, opacity)
  ];

  return GradientText(
    isHour ? '$text' : '$text',
    gradient: LinearGradient(
        colors: isDarkMode ? darkColors : lightColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter),
    style: TextStyle(
        letterSpacing: 2.0,
        fontFamily: 'BananaBrickTweaked',
        fontWeight: weight),
  );
}
