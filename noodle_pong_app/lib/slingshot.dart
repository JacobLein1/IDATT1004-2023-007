import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noodle_pong_app/noodle_pong_app.dart';
import 'package:noodle_pong_app/slingshot_painter.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class SlingShot extends StatefulWidget {
  const SlingShot({
    super.key,
  });

  @override
  State<SlingShot> createState() => _SlingShotState();
}

class _SlingShotState extends State<SlingShot> with TickerProviderStateMixin {
  late AnimationController _stringController;
  late AnimationController _ballController;
  Offset? pointerPosition;
  final widgetKey = GlobalKey();
  bool _isAnimating = false;
  Offset? ballPosition;
  static const double ballRadius = 25;

  late Animation<Offset> _pointerPositionAnimation;
  late Animation<Offset> _ballPositionAnimation;

  @override
  void initState() {
    _stringController = AnimationController(vsync: this);
    _stringController.duration = const Duration(milliseconds: 300);
    _stringController.addListener(() => setState(() {}));

    _ballController = AnimationController(vsync: this);
    _ballController.duration = const Duration(milliseconds: 400);
    _ballController.addListener(() => setState(() {}));
    super.initState();
  }

  NoodlePongAppState getApp(BuildContext context) => NoodlePongApp.of(context);

  void handlePointerMove(PointerEvent event, BuildContext context) {
    RenderBox? renderbox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderbox == null) {
      return;
    }
    setState(() {
      _isAnimating = false;
      pointerPosition = event.localPosition;
      ballPosition = event.localPosition;
      finishedAdjusting = false;
    });
    final positionX = event.localPosition.dx
        .clamp(ballRadius, renderbox.size.width - ballRadius);
    final positionY = event.localPosition.dy
        .clamp(renderbox.size.height * 0.35, renderbox.size.height * 0.8);

    final rotationX =
        lerp(ballRadius, renderbox.size.width - ballRadius, -1, 1, positionX);
    final forceY = lerp(renderbox.size.height * 0.35,
        renderbox.size.height * 0.8, 0, 1, positionY);
    handleUpdate(rotationX, forceY, getApp(context));
  }

  void handlePointerUp(PointerEvent event, BuildContext context) {
    setState(() {
      _isAnimating = true;
    });
    animateReset(event).then(
      (value) => setState(() {
        pointerPosition = null;
        ballPosition = null;
      }),
    );
    handleFire(getApp(context));
  }

  Future<void> animateReset(PointerEvent event) async {
    RenderBox? renderbox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderbox == null) {
      return;
    }
    double width = renderbox.size.width / 2;
    double height = renderbox.size.height / 2 * 0.8;

    Offset center = Offset(width, height);

    _pointerPositionAnimation =
        Tween<Offset>(begin: pointerPosition, end: center).animate(
      CurvedAnimation(
        parent: _stringController,
        curve: Curves.elasticOut,
      ),
    );

    if (ballPosition == null) {
      return;
    }

    // Pingpong ball
    Offset ballPositionEnd =
        Offset.fromDirection((center - ballPosition!).direction, 1500);

    _ballPositionAnimation =
        Tween<Offset>(begin: ballPosition, end: ballPositionEnd + ballPosition!)
            .animate(
      CurvedAnimation(
        parent: _ballController,
        curve: Curves.easeOut,
      ),
    );

    List<Future> futures = [];
    futures.add(_stringController.forward(from: 0));
    futures.add(_ballController.forward(from: 0));

    await futures.wait;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: widgetKey,
      onPointerMove: (event) => handlePointerMove(event, context),
      onPointerUp: (event) => handlePointerUp(event, context),
      onPointerDown: (event) => handlePointerMove(event, context),
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: SlingshotPainter(
            isAnimating: _isAnimating,
            stringPointPosition: _isAnimating
                ? _pointerPositionAnimation.value
                : pointerPosition,
            ballPosition:
                _isAnimating ? _ballPositionAnimation.value : ballPosition,
            primaryColor: finishedAdjusting
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            secondaryColor: Theme.of(context).colorScheme.secondary,
            stringColor: Theme.of(context).colorScheme.onBackground,
            animationValue: _ballController.value,
            finishedAdjusting: finishedAdjusting),
      ),
    );
  }

  double x = 0, force = 0, newX = 0, newForce = 0;
  bool finishedAdjusting = false;

  Future<void> adjustEv3(NoodlePongAppState app) async {
    setState(() {
      finishedAdjusting = true;
    });
    print("Sending adjust request... x: $newX, force: $newForce");
    final body = {"x": newX, "force": newForce};

    try {
      final response =
          await http.post(getAdjustUrl(app), body: jsonEncode(body));
      print(response.statusCode);
    } catch (e) {
      final SnackBar snackBar =
          SnackBar(content: Text("Failed to contact EV3"));
      snackbarKey.currentState?.showSnackBar(snackBar);
      print(e);
    }
  }

  Future<void> fireEv3(NoodlePongAppState app) async {
    setState(() {
      finishedAdjusting = false;
    });
    print("Sending fire request...");
    try {
      final response = await http.post(
        getFireUrl(app),
      );
      print(response.statusCode);
    } catch (e) {
      final SnackBar snackBar =
          SnackBar(content: Text("Failed to contact EV3"));
      snackbarKey.currentState?.showSnackBar(snackBar);
      print(e);
    }
  }

  void handleFire(NoodlePongAppState app) async {
    _debounce?.cancel();
    fireEv3(app);
  }

  void handleUpdate(double x, double force, NoodlePongAppState app) {
    setState(() {
      this.newX = x;
      this.newForce = force;
    });
    _handleDebounce();
  }

  Timer? _debounce;

  _handleDebounce() {
    if (_debounce?.isActive ??
        false || (newForce == force && newX == x) && !finishedAdjusting) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (newForce == force && newX == x) return;
      adjustEv3(NoodlePongApp.of(context));
      newForce = force;
      newX = x;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

double lerp(double minTotal, double maxTotal, double minResult,
    double maxResult, double value) {
  return (value - minTotal) / (maxTotal - minTotal) * (maxResult - minResult) +
      minResult;
}
