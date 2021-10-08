import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/fanItem_model.dart';

import 'package:ota_fix/screen/new%20fan/controlknob.dart';
import 'package:velocity_x/velocity_x.dart';

class CircleGestureDetector extends StatefulWidget {
  final _vxClass = (VxState.store as Mystore);
  double knobReading;
  CircleGestureDetector({
    Key? key,
    required this.knobReading,
  }) : super(key: key);
  @override
  _CircleGestureDetectorState createState() => _CircleGestureDetectorState();
}

class _CircleGestureDetectorState extends State<CircleGestureDetector> {
  double degree = 0;
  double radius = 150 / 2;
  @override
  void initState() {
    super.initState();
    // radius = wheelSize / 2;
  }

  void _panHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange * -1
        : yChange;

    double horz =
        (onTop && panLeft) || (onBottom && panRight) ? xChange * -1 : xChange;

    // Total computed change
    double rotationalChange = vert + horz;

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;
    double temp = degree + (rotationalChange / 1.5);
    setState(() {
      if (temp >= 0 && temp <= 180) {
        // degree = temp;

        ChangeValue(value: temp * (pi / 180));
        degree = temp;
        // (widget._vxClass.myDevices[1] as FanItem).knobvalue = temp;
      }

      print(degree);
      // _movement = rotationalChange + _movement;
    });

    // Now do something interesting with these computations!
  }

  @override
  Widget build(BuildContext context) {
    print((widget._vxClass.myDevices[1] as FanItem).knobvalue);
    return GestureDetector(
        onPanUpdate: _panHandler,
        child: Transform.rotate(
          angle: (widget._vxClass.myDevices[1] as FanItem).knobvalue!,
          // degree * (pi / 180),
          child: ControlKnob(
              // knobReading: widget.knobReading,
              // knobAngle: 2 * pi / 3,
              ),
        ));
  }
}
