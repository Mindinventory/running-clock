import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Minute1 extends StatefulWidget {

  final Color color1;
  final Color color2;

  Minute1(this.color1, this.color2);

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<Minute1> with TickerProviderStateMixin {
  List<String> minData = [];
  AnimationController _animationController;
  double animProgress = 1;
  Timer _timer;
  DateTime _dateTime;

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

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      _animationController.forward(from: 0.25);
      _animationController.animateTo(1.0, curve: Curves.decelerate);
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

    double left = -20;
    double top = 30;
    double scale = 2.0;
    double opacity = 1.0;

    return Stack(
        alignment: AlignmentDirectional.center,
        children: minData.map((item) {
          top = top + ((minData.indexOf(item) + animProgress) * 7);
          scale = scale + ((minData.indexOf(item) + 1) * 0.3);
          opacity = opacity - 0.3;

          if (minData.indexOf(item) == minData.length - 1) {
            return Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: 1 - animProgress,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    '   $item',
                    style: TextStyle(
                        color: Color.lerp(widget.color1, widget.color2, opacity),
                        fontFamily: 'digital-7',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
          } else {
            return Positioned(
              left: left,
              top: top,
              child: Transform.scale(
                scale: scale,
                child: Text(
                  '   $item',
                  style: TextStyle(
                      color: Color.lerp(widget.color1, widget.color2, opacity),
                      fontFamily: 'digital-7',
                      fontWeight: FontWeight.w700),
                ),
              ),
            );
          }
        }).toList());
  }
}
