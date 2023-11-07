import 'package:flutter/material.dart';
import 'package:noodle_pong_app/slingshot_painter.dart';

class SlingShot extends StatefulWidget {
  const SlingShot({super.key});

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

  void handlePointerMove(PointerMoveEvent event) {
    setState(() {
      _isAnimating = false;
      pointerPosition = event.localPosition;
      ballPosition = event.localPosition.translate(0, -30);
    });
  }

  void handlePointerUp(PointerUpEvent event) {
    setState(() {
      _isAnimating = true;
    });
    animateReset(event);
    setState(() {
      pointerPosition = null;
      ballPosition = null;
    });
  }

  void animateReset(PointerUpEvent event) {
    RenderBox? renderbox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderbox == null) {
      return;
    }
    double width = renderbox.size.width / 2;
    double height = renderbox.size.height / 2;

    Offset center = Offset(width, height);

    _pointerPositionAnimation =
        Tween<Offset>(begin: pointerPosition, end: center).animate(
      CurvedAnimation(
        parent: _stringController,
        curve: Curves.elasticOut,
      ),
    );

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

    _stringController.forward(from: 0);
    _ballController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: widgetKey,
      onPointerMove: handlePointerMove,
      onPointerUp: handlePointerUp,
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: SlingshotPainter(
          _isAnimating,
          _isAnimating ? _pointerPositionAnimation.value : pointerPosition,
          _isAnimating ? _ballPositionAnimation.value : ballPosition,
        ),
      ),
    );
  }
}
