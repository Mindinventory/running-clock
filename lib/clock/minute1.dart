import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'common.dart';

class Minute1 extends StatefulWidget {
  final Color color1;
  final Color color2;
  final double left;
  final double top;
  final double scale;
  final double opacity;

  final double topProgress;
  final double scaleProgress;
  final double colorIntense;

  Minute1(this.color1, this.color2, this.left, this.top, this.scale,
      this.opacity, this.topProgress, this.scaleProgress, this.colorIntense);

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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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

      _animationController.forward(from: 0.25);
      _animationController.animateTo(1.0, curve: Curves.easeOut);
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

    double left = widget.left;
    double top = widget.top;
    double scale = widget.scale;
    double opacity = widget.opacity;

    return Expanded(
      child: Container(
//        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: minData.map((item) {
                top = top + ((minData.indexOf(item) + animProgress) * widget.topProgress);
                scale = scale + (((minData.indexOf(item) * (minData.indexOf(item) + 0.5) ) + animProgress) * widget.scaleProgress);
                opacity = opacity - widget.colorIntense;

                if (minData.indexOf(item) == minData.length - 1) {
                  return Positioned(
                    left: left,
                    top: top,
                    child: Opacity(
                      opacity: 1 - animProgress,
                      child: Transform.scale(
                        scale: scale,
                        child: textViews(
                            false,
                            item,
                            widget.color2,
                            opacity,
//                            Color.lerp(widget.color1, widget.color2, opacity),
                            FontWeight.w100),
                      ),
                    ),
                  );
                } else {
                  return Positioned(
                      left: left,
                      top: top,
                      child: Transform.scale(
                        scale: scale,
                        child: Stack(
                          children: <Widget>[
                            /*textViews(false, '88', widget.color1.withOpacity(0.05),
                                FontWeight.w200),*/
                            textViews(
                                false,
                                item,
                                widget.color2,
                                minData.indexOf(item) == (minData.length - 2) ? 0.0 : opacity,
//                                Color.lerp(
//                                    widget.color1,
//                                    widget.color2,
//                                    minData.indexOf(item) == (minData.length - 2)
//                                        ? 0.0
//                                        : opacity),
                                FontWeight.w100)
                          ],
                        ),
                      ));
                }
              }).toList()),
        ),
      ),
    );
  }
}
