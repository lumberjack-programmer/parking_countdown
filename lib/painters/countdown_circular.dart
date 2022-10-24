import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';
import 'dart:math' as math;



class CountdownCircularPainter extends CustomPainter {
  final double percentFinished;
  double radius = 135.0;
  double strokeWidth = 15.0;
  CountdownCircularPainter(this.percentFinished);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    var rainbowPaint = Paint()
      ..shader = SweepGradient(colors: kColors).createShader(rect)..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    canvas.drawArc(rect, 0, percentFinished, false, rainbowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}