import 'package:flutter/material.dart';
import 'package:noodle_pong_app/noodle_pong_app.dart';
import 'package:noodle_pong_app/settings_page.dart';
import 'package:noodle_pong_app/slingshot.dart';

class SlingshotPage extends StatefulWidget {
  const SlingshotPage({super.key});

  @override
  State<SlingshotPage> createState() => _SlingshotPageState();
}

class _SlingshotPageState extends State<SlingshotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noodle Pong"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(app: NoodlePongApp.of(context)),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: SlingShot(),
      ),
    );
  }
}
