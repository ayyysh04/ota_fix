import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ota_fix/screen/new%20fan/circletickpainter.dart';

class ControlKnob extends StatelessWidget {
  // final double knobReading;
  // double? knobAngle;
  // ControlKnob({
  //   this.knobReading = 0,
  //   this.knobAngle,
  // });

  @override
  Widget build(BuildContext context) {
    // if (knobAngle == null) {
    //   knobAngle = knobReading * pi / 3;
    // }
    return Material(
      color: Colors.blueAccent,
      elevation: 10,
      shape: CircleBorder(),
      shadowColor: Colors.blueAccent,
      child:
          //  Transform.rotate(
          //   angle: knobAngle!,
          //   child:
          Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 1.0),
              )
            ]),
        child: Stack(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(0),
            //   child: Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     decoration: BoxDecoration(shape: BoxShape.circle),
            //     child: Padding(
            //       padding: const EdgeInsets.all(0.0),
            //       child: CustomPaint(
            //         painter: AllTickPainter(),
            //       ),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}
