import 'dart:math';

import 'package:flutter/material.dart';

class SlingshotPainter extends CustomPainter {
  final Offset? pointerPosition;
  final Offset? ballPosition;
  final bool isAnimating;

  SlingshotPainter(this.isAnimating, this.pointerPosition, this.ballPosition);

  static const double padding = 30.0;
  static const double ballRadius = 25;
  static const double slingshotCurveCoefficient = 0.3;
  static const double slingshotPointRadius = 18;
  static const double stringStrokeWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final left = Offset(padding, center.dy);
    final right = Offset(size.width - padding, center.dy);
    final slingshotMeetingPoint = Offset(size.width / 2, size.height * 0.75);
    final bottom = Offset(size.width / 2, size.height);

    final slingshotPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    canvas.drawLine(slingshotMeetingPoint, bottom, slingshotPaint);

    final leftPath = Path()..moveTo(left.dx, left.dy);
    leftPath.quadraticBezierTo(
        size.width * slingshotCurveCoefficient,
        slingshotMeetingPoint.dy,
        slingshotMeetingPoint.dx,
        slingshotMeetingPoint.dy);
    canvas.drawPath(leftPath, slingshotPaint);
    final rightPath = Path()..moveTo(right.dx, right.dy);
    rightPath.quadraticBezierTo(
        size.width * (1 - slingshotCurveCoefficient),
        slingshotMeetingPoint.dy,
        slingshotMeetingPoint.dx,
        slingshotMeetingPoint.dy);
    canvas.drawPath(rightPath, slingshotPaint);

    final pointPaint = Paint()..color = Colors.green;

    _drawString(canvas, size);

    canvas.drawCircle(left, slingshotPointRadius, pointPaint);
    canvas.drawCircle(right, slingshotPointRadius, pointPaint);

    var ballPaint = Paint()..color = Colors.white;
    var ballStrokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (ballPosition != null) {
      canvas.drawCircle(ballPosition!, ballRadius, ballPaint);
      canvas.drawCircle(ballPosition!, ballRadius, ballStrokePaint);
    }
  }

  void _drawString(Canvas canvas, Size size) {
    final stringPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = stringStrokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final left = Offset(padding, center.dy);
    final right = Offset(size.width - padding, center.dy);

    Offset finger;
    if (pointerPosition != null) {
      finger = pointerPosition!;
    } else {
      finger = center;
    }

    final ballPosition =
        finger.translate(0, -ballRadius - stringStrokeWidth / 2);

    final rightBall = Offset(finger.dx + ballRadius, finger.dy - ballRadius);
    final leftBall = Offset(finger.dx - ballRadius, finger.dy - ballRadius);

    if (!isAnimating) {
      canvas.drawLine(left, leftBall, stringPaint);
      canvas.drawLine(right, rightBall, stringPaint);
      canvas.drawArc(
          Rect.fromCenter(
              center: ballPosition,
              width: ballRadius * 2 + stringStrokeWidth,
              height: ballRadius * 2 + stringStrokeWidth),
          pi,
          -pi,
          false,
          stringPaint);
    } else {
      canvas.drawLine(left, finger, stringPaint);
      canvas.drawLine(right, finger, stringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
