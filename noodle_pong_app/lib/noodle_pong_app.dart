import 'package:flutter/material.dart';
import 'package:noodle_pong_app/constants.dart';

import 'slingshot_page.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class NoodlePongApp extends StatefulWidget {
  const NoodlePongApp({super.key});

  @override
  State<NoodlePongApp> createState() => NoodlePongAppState();

  static NoodlePongAppState of(BuildContext context) {
    return context.findAncestorStateOfType<NoodlePongAppState>()!;
  }
}

class NoodlePongAppState extends State<NoodlePongApp> {
  Brightness _brightness = Brightness.light;
  MaterialColor _colorSeed = Colors.green;
  String ipAddress = DEFAULT_IP_ADDRESS;
  int port = DEFAULT_PORT;

  bool get isDarkMode => _brightness == Brightness.dark;

  void setBrightness(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
  }

  void setColorSeed(MaterialColor colorSeed) {
    setState(() {
      _colorSeed = colorSeed;
    });
  }

  void setNetworkInfo(String ipAddress, int port) {
    setState(() {
      this.ipAddress = ipAddress;
      this.port = port;
    });
  }

  bool get isRainbowColorOn => _isRainbowColorOn;

  bool _isRainbowColorOn = false;
  bool _hasAccptedEpilepsyWarning = false;

  Future<void> startRainbowColors(BuildContext context) async {
    if (!_hasAccptedEpilepsyWarning) {
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Epilepsy Warning"),
          content: const Text(
              "This feature uses flashing colors. If you have epilepsy, please refrain from using this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _hasAccptedEpilepsyWarning = true;
                  Navigator.of(context).pop(true);
                });
              },
              child: const Text("Proceed"),
            )
          ],
        ),
      );
      if (!(result ?? false)) {
        return;
      }
    }
    setState(() {
      _isRainbowColorOn = true;
    });
    final rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    int index = 0;
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        setColorSeed(rainbowColors[index]);
      });
      index = (index + 1) % rainbowColors.length;
      return _isRainbowColorOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      title: APP_NAME,
      theme: ThemeData(
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        brightness: _brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _colorSeed,
          brightness: _brightness,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SlingshotPage(),
    );
  }
}
