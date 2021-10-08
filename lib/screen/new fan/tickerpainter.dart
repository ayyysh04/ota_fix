import 'package:flutter/material.dart';
import 'dart:math';

class TickPainter extends CustomPainter {
  final LONG_TICK = 15.0;
  final SHORT_TICK = 5.0;
  final tickCount;
  final tickPerSection;
  final tickInset;
  final tickPaint;
  final currentRed;

  TickPainter({
    this.tickCount = 16,
    this.tickPerSection = 5,
    this.tickInset = 0.0,
    this.currentRed,
  }) : tickPaint = new Paint() {
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(pi);
    canvas.save();

    for (int i = 0; i < tickCount; i++) {
      currentRed >= i
          ? tickPaint.color = Colors.blueAccent
          : tickPaint.color = Colors.deepOrange;
      final ticklenght = i % tickPerSection == 0 ? LONG_TICK : SHORT_TICK;
      canvas.drawLine(
        Offset(radius, 0),
        Offset(radius + ticklenght, 0.0),
        tickPaint,
      );

      canvas.rotate((2.14 * pi / tickCount) / 2);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
