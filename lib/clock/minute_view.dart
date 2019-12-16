import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Minute extends StatefulWidget {

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<Minute> with TickerProviderStateMixin {
  DateTime _dateTime;
  Timer _timer;

  AnimationController _animationController;
  List<String> minData = [];
  double animProgress = 1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      value: animProgress,
      lowerBound: 0.25,
      upperBound: 1.5,
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
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      _animationController.forward(from: 0.75);
      _animationController.animateTo(1.0, curve: Curves.easeIn);
    });
  }

  _timeLogic() {
    final minute = DateFormat('mm').format(_dateTime);

    List<String> data = [];

    // Handling if minute is greater than 60
    for (int i = 3; i >= -1; i--) {
      var nextMin = int.parse(minute) + i;
      if (nextMin > 59) {
        nextMin = nextMin - 60;
      }
      var nextMinStr = nextMin.toString();

      if (nextMin < 10) {
        nextMinStr = '0${nextMin.toString()}';
      }

      data.add(nextMinStr);
    }

    minData = data;
  }

  @override
  Widget build(BuildContext context) {

    _timeLogic();

    return Stack(
        alignment: AlignmentDirectional.center,
        children: minData.map((item) {
          if (minData.indexOf(item) == minData.length - 1) {
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
          } else if (minData.indexOf(item) == minData.length - 2) {
            return Opacity(
              opacity: 1.0,
              child: Transform.scale(
                scale: animProgress * ((minData.indexOf(item) + 1) / 4),
                child: Text(
                  item.toString(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .display4.copyWith(color: Colors.black, fontWeight: FontWeight.w400),),
              ),
            );
          } else {
            return Opacity(
              opacity: animProgress * ((minData.indexOf(item) + 1) / 4),
              child: Transform.scale(
                scale: animProgress * ((minData.indexOf(item) + 1) / 4),
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

