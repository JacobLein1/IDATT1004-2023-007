import 'package:flutter/material.dart';
import 'package:noodle_pong_app/noodle_pong_app.dart';

Uri getAdjustUrl(NoodlePongAppState app) => Uri(
      scheme: scheme,
      host: app.ipAddress,
      port: app.port,
      path: "adjust",
    );

Uri getFireUrl(NoodlePongAppState app) => Uri(
      scheme: scheme,
      host: app.ipAddress,
      port: app.port,
      path: "fire",
    );

const DEFAULT_IP_ADDRESS = "192.168.2.2";
const int DEFAULT_PORT = 7878;
const scheme = "http";

const APP_NAME = "Noodle Pong";

const DEFAULT_COLOR = Colors.green;
const DEFAULT_THEME_MODE = ThemeMode.light;
