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
            seedColor: _colorSeed, brightness: _brightness),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SlingshotPage(),
    );
  }
}
