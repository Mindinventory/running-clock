import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'common.dart';

class MinuteView extends StatefulWidget {
  final Color fontColor;
  final double left;
  final double top;
  final double scale;
  final double opacity;
  final double topProgress;
  final double scaleProgress;
  final double colorIntense;

  MinuteView(this.fontColor, this.left, this.top, this.scale, this.opacity,
      this.topProgress, this.scaleProgress, this.colorIntense);

  @override
  _MinuteState createState() => _MinuteState();
}

class _MinuteState extends State<MinuteView> with TickerProviderStateMixin {
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
      duration: Duration(milliseconds: 600),
    )..addListener(() => setState(() {
          animProgress = _animationController.value;
        }));
    _animationController.reverse();
    _updateMinute();
  }

  // Disposing animation controller
  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // Animating the controller in each min
  void _updateMinute() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateMinute,
      );

      _animationController.forward(from: 0.25);
      _animationController.animateTo(1.0, curve: Curves.fastOutSlowIn);
    });
  }

  _minuteLogic() {
    final minute = DateFormat('mm').format(_dateTime);

    List<String> data = [];

    // Calculating the next minutes
    for (int i = 3; i >= -1; i--) {
      var nextMin = int.parse(minute) + i;

      // Handling if minute is greater than 60
      if (nextMin > 59) {
        nextMin = nextMin - 60;
      }
      var nextMinStr = nextMin.toString();

      // Handling if minute is less than 9
      if (nextMin < 10) {
        nextMinStr = '0${nextMin.toString()}';
      }

      data.add(nextMinStr);
    }
    minData = data;
  }

  @override
  Widget build(BuildContext context) {
    _minuteLogic();

    double left = widget.left;
    double top = widget.top;
    double scale = widget.scale;
    double opacity = widget.opacity;

    return Expanded(
      child: Stack(
          alignment: AlignmentDirectional.center,
          children: minData.map((item) {
            // Calculating the values for position and animation
            final index = minData.indexOf(item);
            top = top + ((index + animProgress) * widget.topProgress);
            scale = scale +
                (((index * (index + 0.5)) + animProgress) *
                    widget.scaleProgress);
            opacity = opacity - widget.colorIntense;

            // Logic for the first element that is zooming out
            if (index == minData.length - 1) {
              return Positioned(
                left: left,
                top: top,
                child: Opacity(
                  opacity: 1 - animProgress,
                  child: Transform.scale(
                    scale: scale,
                    child: getClockText(
                        (Theme.of(context).brightness == Brightness.light)
                            ? false
                            : true,
                        false,
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
                  left: left,
                  top: top,
                  child: Transform.scale(
                    scale: scale,
                    child: getClockText(
                        (Theme.of(context).brightness == Brightness.light)
                            ? false
                            : true,
                        false,
                        item,
                        widget.fontColor,
                        index == (minData.length - 2) ? 0.0 : opacity,
                        FontWeight.w100),
                  ));
            }
          }).toList()),
    );
  }
}
