import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class Hour extends StatefulWidget {

  final ClockModel model;

  Hour(this.model);

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<Hour> with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
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
      lowerBound: 0.25,
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
      _timer = Timer(
          Duration(hours: 1) - Duration(minutes: _dateTime.minute) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      _animationController.forward(from: 0.75);
      _animationController.animateTo(1.0, curve: Curves.easeIn);
    });
  }

  _timeLogic() {
    final hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);

    List<String> data = [];

    // Handling if minute is greater than 60
    for (int i = 5; i >= -1; i--) {
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

    return Stack(
        alignment: AlignmentDirectional.center,
        children: hourData.map((item) {
          if (hourData.indexOf(item) == hourData.length - 1) {
            return Opacity(
                opacity: 1 - animProgress,
                child: Transform.scale(
                  scale: 1 + animProgress,
                  child: Text(
                    item.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .display4.copyWith(color: Colors.black, fontWeight: FontWeight.w400),),
                )
            );
          } else {
              return Opacity(
                opacity: animProgress * ((hourData.indexOf(item) + 1) / 7),
                child: Transform.scale(
                  scale: animProgress * ((hourData.indexOf(item) + 1) / 7),
                  child: Text(
                    item.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .display4.copyWith(color: Colors.black, fontWeight: FontWeight.w400),),
                ),
              );
          }
        }).toList());
  }
}

