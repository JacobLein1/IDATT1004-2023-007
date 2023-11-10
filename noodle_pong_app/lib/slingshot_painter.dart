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
    final double forceEndHeight = size.height * 0.8;
    final double forceStartHeight = size.height * 0.35;
    final double rotationStart = ballRadius;
    final double rotationEnd = size.width - ballRadius;

    final double? positionY =
        stringPointPosition?.dy.clamp(forceStartHeight, forceEndHeight);
    final double? positionX =
        stringPointPosition?.dx.clamp(rotationStart, rotationEnd);

    final Offset? stringPositionClamped =
        stringPointPosition != null ? Offset(positionX!, positionY!) : null;

    final Offset? ballPositionClamped = !isAnimating
        ? (ballPosition != null
            ? Offset(
                    ballPosition!.dx
                        .clamp(rotationStart, rotationEnd)
                        .clamp(rotationStart, rotationEnd),
                    ballPosition!.dy
                        .clamp(forceStartHeight, forceEndHeight)
                        .clamp(forceStartHeight, forceEndHeight))
                .translate(0, -30)
            : null)
        : ballPosition;

    final stringCenter = Offset(size.width / 2, size.height / 2 * 0.8);

    late final double rotation;
    late final double yTranslation;
    if (ballPositionClamped != null) {
      if (stringPositionClamped != null) {
        rotation = ((stringCenter.dx - stringPositionClamped.dx) / size.width) *
            pi /
            -20;
        yTranslation = (stringPositionClamped.dy - stringCenter.dy) * -0.1;
      } else {
        rotation = ((ballPositionClamped.dx / size.width) - 0.5) * pi / -20;
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

    _drawString(canvas, size, left, right, stringCenter, stringPositionClamped);

    final double pointSize =
        finishedAdjusting ? expandedPointRadius : pointRadius;
    canvas.drawCircle(left, pointSize, pointPaint);
    canvas.drawCircle(right, pointSize, pointPaint);

    var ballPaint = Paint()..color = Colors.white;
    var ballStrokePaint = Paint()
      ..color = stringColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (ballPositionClamped != null) {
      canvas.drawCircle(ballPositionClamped, ballRadius, ballPaint);
      canvas.drawCircle(ballPositionClamped, ballRadius, ballStrokePaint);
    }

    // Table in background
    final tablePaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final tablePath = Path()
      ..moveTo(ballRadius, size.height * 0.3)
      ..lineTo(ballRadius, size.height * 0.2)
      ..lineTo(size.width - ballRadius, size.height * 0.2)
      ..lineTo(size.width - ballRadius, size.height * 0.3)
      ..lineTo(size.width - ballRadius * 1.5, size.height * 0.2)
      ..lineTo(ballRadius * 1.5, size.height * 0.2)
      ..lineTo(ballRadius, size.height * 0.3);

    final cupPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final cupFillPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final cupPath = Path()
      ..addOval(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height * 0.15),
            width: 30,
            height: 10),
      )
      ..moveTo(size.width / 2 + 15, size.height * 0.15)
      ..lineTo(size.width / 2 + 10, size.height * 0.19)
      ..moveTo(size.width / 2 - 15, size.height * 0.15)
      ..lineTo(size.width / 2 - 10, size.height * 0.19);

    final cupFillPath = Path()
      ..addOval(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height * 0.19),
            width: 20,
            height: 10),
      );

    canvas.rotate(-rotation);
    canvas.translate(0, -yTranslation);

    canvas.drawPath(tablePath, tablePaint);
    canvas.drawPath(cupPath, cupPaint);
    canvas.drawPath(cupFillPath, cupFillPaint);
  }

  void _drawString(Canvas canvas, Size size, Offset left, Offset right,
      Offset center, Offset? stringPositionClamped) {
    final stringPaint = Paint()
      ..color = stringColor
      ..strokeWidth = stringStrokeWidth
      ..strokeCap = StrokeCap.round;

    Offset finger;
    if (stringPositionClamped != null || ballPosition != null) {
      finger = stringPositionClamped!;
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
