import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'common.dart';

class Hour1 extends StatefulWidget {
  final ClockModel model;
  final Color color1;
  final Color color2;
  final double right;
  final double top;
  final double scale;
  final double opacity;

  final double topProgress;
  final double scaleProgress;
  final double colorIntense;


  Hour1(this.model, this.color1, this.color2, this.right, this.top, this.scale,
      this.opacity, this.topProgress, this.scaleProgress, this.colorIntense);

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<Hour1> with TickerProviderStateMixin {
  DateTime _dateTime;
  Timer _timer;

  AnimationController _animationController;
  List<String> hourData = [];
  double animProgress = 1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      value: animProgress,
      lowerBound: 0.00,
      upperBound: 1.25,
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {
          animProgress = _animationController.value;
        }));
    _animationController.reverse();
    _updateTime();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(hours: 1) -
            Duration(minutes: _dateTime.minute) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      _animationController.forward(from: 0.25);
      _animationController.animateTo(1.0, curve: Curves.easeOut);
    });
  }

  _timeLogic() {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);

    List<String> data = [];

    // Handling if minute is greater than 60
    for (int i = 3; i >= -1; i--) {
      var nextHour = int.parse(hour) + i;
      if (widget.model.is24HourFormat) {
        if (nextHour > 23) {
          nextHour = nextHour - 24;
        }
      } else {
        if (nextHour > 12) {
          nextHour = nextHour - 12;
        }
      }
      var nextHourStr = nextHour.toString();

      if (nextHour < 10) {
        nextHourStr = '0${nextHour.toString()}';
      }
      data.add(nextHourStr);
    }
    hourData = data;
  }

  @override
  Widget build(BuildContext context) {
    _timeLogic();

    double right = widget.right;
    double top = widget.top;
    double scale = widget.scale;
    double opacity = widget.opacity;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: hourData.map((item) {
              top = top + ((hourData.indexOf(item) + animProgress) * widget.topProgress);
              scale = scale + (((hourData.indexOf(item) * (hourData.indexOf(item) + 0.5) ) + animProgress) * widget.scaleProgress);
              opacity = opacity - widget.colorIntense;

              if (hourData.indexOf(item) == hourData.length - 1) {
                return Positioned(
                  right: right,
                  top: top,
                  child: Opacity(
                    opacity: 1 - animProgress,
                    child: Transform.scale(
                      scale: scale,
                      child: textViews(
                          true,
                          item,
                          Color.lerp(widget.color1, widget.color2, opacity),
                          FontWeight.w700),
                    ),
                  ),
                );
              } else {
                return Positioned(
                  right: right,
                  top: top,
                  child: Transform.scale(
                    scale: scale,
                    child: Stack(
                      children: <Widget>[
                        textViews(true, '88', widget.color1.withOpacity(0.05),
                            FontWeight.w200),
                        textViews(
                            true,
                            item,
                            Color.lerp(
                                widget.color1,
                                widget.color2,
                                hourData.indexOf(item) == (hourData.length - 2)
                                    ? 0.0
                                    : opacity),
                            FontWeight.w700)
                      ],
                    ),
                  ),
                );
              }
            }).toList()),
      ),
    );
  }
}
