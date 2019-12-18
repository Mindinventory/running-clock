import 'package:flutter/material.dart';

Widget textViews(bool isHour, String text, Color color, FontWeight weight) {
  return Text(
    isHour ? '$text  ' : '  $text',
    style: TextStyle(
        color: color,
        letterSpacing: 2.0,
        fontFamily: 'Segment7Standard',
        fontWeight: weight),
  );
}