// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'hour1.dart';
import 'minute1.dart';

enum _Element {
  background,
  text1,
  text2,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text1: Colors.deepOrange,
  _Element.text2: Colors.white,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text1: Colors.cyan,
  _Element.text2: Colors.black,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {

  final gemScale = 6.0;

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

    final width = MediaQuery.of(context).size.width;

    final left = _isPortrait(context) ? 20.0 : 40.0;
    final top = _isPortrait(context) ? 10.0 : 10.0;
    final scale = _isPortrait(context) ? 1.5 : 4.0;
    final opacity = 1.0;
    final topProgress = _isPortrait(context) ? 10.0 : 13.0;
    final scaleProgress = _isPortrait(context) ? 0.2 : 0.15;
    final colorIntense = _isPortrait(context) ? 0.15 : 0.2;

    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: colors[_Element.background],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[

              Hour1(
                  widget.model,
                  colors[_Element.text1],
                  colors[_Element.text2],
                  left,
                  top,
                  scale,
                  opacity,
                  topProgress,
                  scaleProgress,
                  colorIntense),

              /*Text(
                ' : ',
                textScaleFactor: gemScale,
                style: TextStyle(
                  letterSpacing: -4.0,
                    color: colors[_Element.text1],
                    fontFamily: 'BBrick',
                    fontWeight: FontWeight.w900),
              ),*/
              SizedBox(width: 100,),

              Minute1(
                  colors[_Element.text1],
                  colors[_Element.text2],
                  left,
                  top,
                  scale,
                  opacity,
                  topProgress,
                  scaleProgress,
                  colorIntense),

              /*Container(
                width: 100,
                alignment: Alignment.centerLeft,
                child: _amPM(),
              ),*/

            ],
          ),
        ));
  }

  Widget _amPM() {
    final hr = int.parse(DateFormat('HH').format(DateTime.now()));
    if (widget.model.is24HourFormat) {
      return Container();
    } else {
      if (hr >= 12) {
        return _textViews('PM');
      } else {
        return _textViews('AM');
      }
    }
  }

  Widget _textViews(String text) {
    return Text(
      text,
      textScaleFactor: gemScale-2.5,
      style: TextStyle(
          color: (Theme.of(context).brightness == Brightness.light)
              ? Colors.deepOrange
              : Colors.cyan,
          fontFamily: 'BBrick',
          fontWeight: FontWeight.w200),
    );
  }

  static bool _isPortrait(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait) ? true : false;
  }
}