import 'package:esp_controller/pages/home.dart';
import 'package:esp_controller/pages/loading.dart';
import 'package:esp_controller/pages/mode_selector.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: "ESP MQTT Controller",
  initialRoute: "/",
  routes: {
    "/": (context) => LoadingScreen(),
    "/home": (context) => Home()
  },
));