import 'package:flutter/material.dart';

class ControlKnob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      elevation: 10,
      shape: CircleBorder(),
      shadowColor: Colors.blueAccent,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 3.0,
                spreadRadius: 2.0,
                offset: const Offset(2.0, 0.0),
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
