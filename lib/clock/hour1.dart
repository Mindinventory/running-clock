import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class Hour1 extends StatefulWidget {

  final ClockModel model;

  Hour1(this.model);

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
    )
      ..addListener(() =>
          setState(() {
            animProgress = _animationController.value;
          }));
    _animationController.reverse();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(Duration(hours: 1) - Duration(minutes: _dateTime.minute) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      _animationController.forward(from: 0.25);
      _animationController.animateTo(1.0, curve: Curves.decelerate);
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
        if (nextHour > 11) {
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

    double left = 20;
    double top = 40;
    double scale = 2.0;
    double opacity = 0.1;

    return Stack(
        alignment: AlignmentDirectional.center,
        children: hourData.map((item) {
          top = top + ((hourData.indexOf(item) + animProgress) * 6);
          scale = scale + ((hourData.indexOf(item) + 1) * 0.2);
          opacity = opacity + 0.1;

          if (hourData.indexOf(item) == hourData.length - 1) {
            return Positioned(
              right: left,
              top: top,
              child: Opacity(
                opacity: 1 - animProgress,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    '$item   ',
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PolanCanIntoGlassMakings',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
          } else {
            return Positioned(
              right: left,
              top: top,
              child: Opacity(
                opacity: (hourData.indexOf(item) == hourData.length - 2)
                    ? 1.0
                    : opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    '$item   ',
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PolanCanIntoGlassMakings',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
          }
        }).toList());
  }
}

