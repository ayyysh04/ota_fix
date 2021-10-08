import 'package:flutter/material.dart';
import 'dart:math' as math;

class SemiCircleWidget extends StatelessWidget {
  final double? diameter;
  final double? sweepAngle; //angle by which it should move
  final Color? color;

  const SemiCircleWidget({
    Key? key,
    this.diameter = 200,
    @required this.sweepAngle,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (detail) {
        print("pan down" + detail.localPosition.toString());
      },
      onPanUpdate: (detail) {
        print("pan update" + detail.localPosition.toString());
      },
      onPanEnd: (detail) {
        print("pan end" + detail.toString());
      },
      child: CustomPaint(
        painter: MyPainter(sweepAngle, color),
        size: Size(diameter!, diameter!),
      ),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  MyPainter(this.sweepAngle, this.color);
  final double? sweepAngle;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 60.0
      ..style = PaintingStyle.stroke
      ..color = color!;

    double degToRad(double deg) => deg * (math.pi / 180.0);
    print(degToRad(sweepAngle!));
    // print(sweepAngle);
    final path = Path()
      ..arcTo(
          Rect.fromCenter(
            center: Offset(
                size.height / 2,
                size.width /
                    2), //offset is same as 2 cocordinate point (y: size.width ,x:size:height) and orgin is at top left of canvas
            height: size.height,
            width: size.width,
          ),
          degToRad(180),
          degToRad(sweepAngle!),
          false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
