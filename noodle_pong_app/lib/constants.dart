import 'package:flutter/material.dart';
import 'package:noodle_pong_app/noodle_pong_app.dart';

Uri getAdjustUrl(NoodlePongAppState app) => Uri(
      scheme: SCHEME,
      host: app.ipAddress,
      port: app.port,
      path: "adjust",
    );

Uri getFireUrl(NoodlePongAppState app) => Uri(
      scheme: SCHEME,
      host: app.ipAddress,
      port: app.port,
      path: "fire",
    );

Uri getTestUrl(NoodlePongAppState app) => Uri(
      scheme: SCHEME,
      host: app.ipAddress,
      port: app.port,
      path: "test",
    );

Uri getCalibrateUrl(NoodlePongAppState app) => Uri(
      scheme: SCHEME,
      host: app.ipAddress,
      port: app.port,
      path: "calibrate",
    );

const DEFAULT_IP_ADDRESS = "192.168.137.3";
const int DEFAULT_PORT = 7878;
const SCHEME = "http";

const APP_NAME = "Noodle Pong";

const DEFAULT_COLOR = Colors.green;
const DEFAULT_THEME_MODE = ThemeMode.light;
