import 'dart:math';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:ota_fix/model/room_model.dart';
import 'package:ota_fix/screen/new%20fan/controlknob.dart';

class CircleGestureDetector extends StatelessWidget {
  final int roomIndex;
  final int deviceIndex;
  CircleGestureDetector({
    Key? key,
    required this.roomIndex,
    required this.deviceIndex,
  }) : super(key: key);

  double degree = 0;
  double radius = 150 / 2;

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

    double temp =
        RoomListData.roomData![roomIndex].devicesData![deviceIndex].knobvalue! *
                (180 / pi) +
            (rotationalChange / 1.5);
    // setState(() {
    if (temp >= 0 && temp <= 180) {
      ChangeValue(
          value: temp * (pi / 180),
          deviceIndex: deviceIndex,
          roomIndex: roomIndex);

      // (widget._vxClass.myDevices[1] as FanItem).knobvalue = temp;
    }
    // });

    // Now do something interesting with these computations!
  }

  @override
  Widget build(BuildContext context) {
    print(
        RoomListData.roomData![roomIndex].devicesData![deviceIndex].knobvalue);
    // print((widget._vxClass.myDevices[1] as FanItem).knobvalue);
    return GestureDetector(
        onPanUpdate:
            RoomListData.roomData![roomIndex].devicesData![deviceIndex].status
                ? _panHandler
                : null,
        child: Transform.rotate(
          angle: RoomListData
              .roomData![roomIndex].devicesData![deviceIndex].knobvalue!,
          // degree * (pi / 180),
          child: ControlKnob(
              // knobReading: widget.knobReading,
              // knobAngle: 2 * pi / 3,
              ),
        ));
  }
}
