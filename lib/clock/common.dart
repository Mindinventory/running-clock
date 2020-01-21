import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

Widget getClockText(bool isDarkMode, bool isHour, String text, Color color,
    double fraction, FontWeight weight) {
  final lightColors = [
    Color.lerp(lighten(color, 0.1), Colors.white, fraction),
    Color.lerp(lighten(color, 0.3), Colors.white, fraction)
  ];

  final darkColors = [
    Color.lerp(Colors.cyan[800], color, fraction),
    Color.lerp(Colors.cyan[900], color, fraction)
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

// Lighter color
Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
