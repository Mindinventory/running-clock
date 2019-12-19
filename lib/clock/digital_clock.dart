// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'hour.dart';
import 'minute.dart';

enum _Element {
  background,
}

final _lightTheme = {
  _Element.background: Color.lerp(Color(0xffE374E9), Color(0xff462D66), 0.5),
};

final _darkTheme = {
  _Element.background: Colors.black,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final valueTop = _isPortrait(context) ? 15 : 25;
    final valueTopProgress = _isPortrait(context) ? 8.5 : 8.0;
    final boxHeight = _isPortrait(context) ? ((MediaQuery.of(context).size.width/5) * 3) : MediaQuery.of(context).size.height;

    // Initializations of values
    final left = _isPortrait(context) ? 20.0 : 40.0;
    final top = _isPortrait(context) ? ((boxHeight * valueTop) / 225)
        : (boxHeight * valueTop) / 225;
    final scale = _isPortrait(context) ? 2.0 : 4.0;
    final opacity = 1.0;
    final topProgress = (boxHeight * valueTopProgress) / 225;
    final scaleProgress = _isPortrait(context) ? 0.25 : 0.25;
    final colorIntense = _isPortrait(context) ? 0.15 : 0.3;

    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: colors[_Element.background], // Changing background color according to dark and light theme
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            // Arranging the hour and minute stack
            children: <Widget>[

              HourView(
                  widget.model,
                  colors[_Element.background],
                  left,
                  top,
                  scale,
                  opacity,
                  topProgress,
                  scaleProgress,
                  colorIntense),

              SizedBox(width: _isPortrait(context) ? 130 : 150),

              MinuteView(
                  colors[_Element.background],
                  left,
                  top,
                  scale,
                  opacity,
                  topProgress,
                  scaleProgress,
                  colorIntense),
            ],
          ),
        ));
  }

  // Determines whether in landScape or portrait mode
  static bool _isPortrait(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait) ? true : false;
  }
}
