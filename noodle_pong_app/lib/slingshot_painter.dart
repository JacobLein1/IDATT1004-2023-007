import 'dart:math';

import 'package:flutter/material.dart';

class SlingshotPainter extends CustomPainter {
  final Offset? stringPointPosition;
  final Offset? ballPosition;
  final bool isAnimating;
  final Color primaryColor;
  final Color secondaryColor;
  final Color stringColor;
  final double animationValue;
  final bool finishedAdjusting;

  SlingshotPainter({
    required this.isAnimating,
    required this.stringPointPosition,
    required this.ballPosition,
    required this.animationValue,
    required this.finishedAdjusting,
    this.primaryColor = Colors.green,
    this.secondaryColor = Colors.brown,
    this.stringColor = Colors.black,
  });

  static const double padding = 30.0;
  static const double ballRadius = 25;
  static const double slingshotCurveCoefficient = 0.3;
  static const double slingshotPointRadius = 18;
  static const double stringStrokeWidth = 10;
  static const double pointRadius = 15;
  static const double expandedPointRadius = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final stringCenter = Offset(size.width / 2, size.height / 2 * 0.8);

    late final double yTranslation;
    if (ballPosition != null) {
      late final double rotation;
      if (stringPointPosition != null) {
        rotation = ((stringCenter.dx - stringPointPosition!.dx) / size.width) *
            pi /
            -20;
        yTranslation = (stringPointPosition!.dy - stringCenter.dy) * -0.1;
      } else {
        rotation = ((ballPosition!.dx / size.width) - 0.5) * pi / -20;
      }
      canvas.rotate(rotation);
      canvas.translate(0, yTranslation);
    } else {
      yTranslation = 0;
      canvas.rotate(0);
    }

    final left = Offset(padding + yTranslation.abs(), stringCenter.dy);
    final right =
        Offset(size.width - padding - yTranslation.abs(), stringCenter.dy);
    final slingshotMeetingPoint =
        Offset(size.width / 2, stringCenter.dy + size.height / 3.5);
    final bottom = Offset(size.width / 2, stringCenter.dy + size.height / 2);

    final slingshotPaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final slingshotBottomPaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        // Account for the cap radius sticking out
        slingshotMeetingPoint.translate(0, 10),
        bottom,
        slingshotBottomPaint);

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

    final pointPaint = Paint()..color = primaryColor;

    _drawString(canvas, size, left, right, stringCenter);

    final double pointSize =
        finishedAdjusting ? expandedPointRadius : pointRadius;
    canvas.drawCircle(left, pointSize, pointPaint);
    canvas.drawCircle(right, pointSize, pointPaint);

    var ballPaint = Paint()..color = Colors.white;
    var ballStrokePaint = Paint()
      ..color = stringColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (ballPosition != null) {
      canvas.drawCircle(ballPosition!, ballRadius, ballPaint);
      canvas.drawCircle(ballPosition!, ballRadius, ballStrokePaint);
    }
  }

  void _drawString(
      Canvas canvas, Size size, Offset left, Offset right, Offset center) {
    final stringPaint = Paint()
      ..color = stringColor
      ..strokeWidth = stringStrokeWidth
      ..strokeCap = StrokeCap.round;

    Offset finger;
    if (stringPointPosition != null || ballPosition != null) {
      finger = stringPointPosition!;
    } else {
      finger = center;
    }

    final ballPosition2 =
        finger.translate(0, -ballRadius - stringStrokeWidth / 2);

    final rightBall = Offset(finger.dx + ballRadius, finger.dy - ballRadius);
    final leftBall = Offset(finger.dx - ballRadius, finger.dy - ballRadius);

    if (!isAnimating) {
      canvas.drawLine(left, leftBall, stringPaint);
      canvas.drawLine(right, rightBall, stringPaint);
      canvas.drawArc(
          Rect.fromCenter(
              center: ballPosition2,
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
