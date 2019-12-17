// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'hour1.dart';
import 'hour_view.dart';
import 'minute1.dart';
import 'minute_view.dart';

enum _Element {
  background,
  text1,
  text2,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text1: Colors.red,
  _Element.text2: Colors.white,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text1: Colors.red,
  _Element.text2: Colors.black,
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
    final colors = Theme
        .of(context)
        .brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: colors[_Element.background],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(child: Hour1(widget.model, colors[_Element.text1],
                  colors[_Element.text2])),

              Text(':', textScaleFactor: 6,
                style: TextStyle(
                    color: colors[_Element.text1],
                    fontFamily: 'digital-7'),
              ),


              Flexible(child: Minute1(
                  colors[_Element.text1], colors[_Element.text2])),



            ],
          ),
        )
    );
  }
}