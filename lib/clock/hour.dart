import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'common.dart';

class HourView extends StatefulWidget {
  final ClockModel model;
  final Color fontColor;
  final double right;
  final double top;
  final double scale;
  final double opacity;
  final double topProgress;
  final double scaleProgress;
  final double colorIntense;

  HourView(this.model, this.fontColor, this.right, this.top, this.scale,
      this.opacity, this.topProgress, this.scaleProgress, this.colorIntense);

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<HourView> with TickerProviderStateMixin {
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
      duration: Duration(milliseconds: 800),
    )..addListener(() => setState(() {
          animProgress = _animationController.value;
        }));

    _animationController.reverse();
    _updateHour();
  }

  // Disposing animation controller
  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // Animating the controller in each hour
  void _updateHour() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(hours: 1) -
            Duration(minutes: _dateTime.minute) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateHour,
      );

      _animationController.forward(from: 0.0);
      _animationController.animateTo(1.0, curve: Curves.linear);
    });
  }

  _hourLogic() {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);

    List<String> data = [];

    // Calculating the next hours
    for (int i = 3; i >= -1; i--) {
      var nextHour = int.parse(hour) + i;

      // Handling if hour is greater than 12 or 24
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

      // Handling if hour is less than 9
      if (nextHour < 10) {
        nextHourStr = '0${nextHour.toString()}';
      }
      data.add(nextHourStr);
    }
    hourData = data;
  }

  @override
  Widget build(BuildContext context) {
    _hourLogic();

    double right = widget.right;
    double top = widget.top;
    double scale = widget.scale;
    double opacity = widget.opacity;

    return Expanded(
      child: Stack(
          alignment: AlignmentDirectional.center,
          children: hourData.map((item) {
            // Calculating the values for position and animation
            final index = hourData.indexOf(item);
            top = top + ((index + animProgress) * widget.topProgress);
            scale = scale +
                (((index * (index + 0.5)) + animProgress) *
                    widget.scaleProgress);
            opacity = opacity - widget.colorIntense;

            // Logic for first element that is zooming out
            if (index == hourData.length - 1) {
              return Positioned(
                right: right,
                top: top,
                child: Opacity(
                  opacity: 1 - animProgress,
                  child: Transform.scale(
                    scale: scale,
                    child: getClockText(
                        (Theme.of(context).brightness == Brightness.light)
                            ? false
                            : true,
                        true,
                        item,
                        widget.fontColor,
                        opacity,
                        FontWeight.w100),
                  ),
                ),
              );
            } else {
              // Logic for rest of the elements
              return Positioned(
                right: right,
                top: top,
                child: Transform.scale(
                  scale: scale,
                  child: getClockText(
                      (Theme.of(context).brightness == Brightness.light)
                          ? false
                          : true,
                      true,
                      item,
                      widget.fontColor,
                      index == (hourData.length - 2) ? 0.0 : opacity,
                      FontWeight.w100),
                ),
              );
            }
          }).toList()),
    );
  }
}
