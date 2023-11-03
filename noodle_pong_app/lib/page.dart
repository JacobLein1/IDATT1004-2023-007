import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noodle_pong_app/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 180.0, force = 0.0, newX = 180.0, newForce = 0.0;

  Future<void> onAdjust() async {
    print("Sending adjust request... x: $x, force: $force");
    final body = {"x": x, "force": force};

    try {
      await http.post(adjustUrl, body: jsonEncode(body));
    } catch (e) {
      print(e);
    }
  }

  Future<void> onFire() async {
    print("Sending fire request...");
    try {
      await http.post(fireUrl);
    } catch (e) {
      print(e);
    }
  }

  void setX(double x) {
    setState(() {
      this.x = x;
    });
    _handleDebounce();
  }

  void setForce(double force) {
    setState(() {
      this.force = force;
    });
    _handleDebounce();
  }

  Timer? _debounce;

  _handleDebounce() {
    if (_debounce?.isActive ?? false || (newForce == force && newX == x)) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (newForce == force && newX == x) return;
      onAdjust();
      newForce = force;
      newX = x;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoodlePong"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rotation: ${x.toStringAsFixed(0)} degrees",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: x,
              onChanged: setX,
              min: 0,
              max: 360,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Force: ${force.toStringAsFixed(0)} rpm",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: force,
              onChanged: setForce,
              min: 0,
              max: 1000,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 80,
              width: 200,
              child: FilledButton(
                onPressed: onFire,
                child: const Text("Fire!", style: TextStyle(fontSize: 24)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
