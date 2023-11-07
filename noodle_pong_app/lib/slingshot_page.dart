import 'package:flutter/material.dart';
import 'package:noodle_pong_app/slingshot.dart';

class SlingshotPage extends StatelessWidget {
  const SlingshotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noodle Pong"),
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: SlingShot(),
      ),
    );
  }
}
