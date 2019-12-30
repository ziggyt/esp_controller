import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hex/hex.dart';

final String SET_BRIGHTNESS_TOPIC = "/esp/setBrightness";
final String CHANGE_COLOR_TOPIC = "/esp/changeColor";

class ColorPicker extends StatefulWidget {
  final MqttEspCommunicator controller;

  ColorPicker({this.controller});

  @override
  _ColorPickerState createState() => _ColorPickerState(controller: controller);
}

class _ColorPickerState extends State<ColorPicker> {
  MqttEspCommunicator controller;
  double brightness = 10;
  int brightnessInt = 10;

  _ColorPickerState({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: MaterialColorPicker(
                    onColorChange: (Color color) {
                      // Handle color changes
                      print(color.blue);
                      print(color.red);
                      print(color.green);

                      String hexColor = HEX.encode([color.red, color.green, color.blue]);
                      controller.publishToTopic(CHANGE_COLOR_TOPIC, hexColor);
                    },
                    selectedColor: Colors.red)),
            Center(
              child: Text(
                "Brightness: $brightnessInt",
                style: TextStyle(fontSize: 30, color: Colors.grey[800]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: brightness,
                onChanged: (value) {
                  setState(() {
                    brightness = value;
                    brightnessInt = brightness.round();
                  });
                },
                onChangeEnd: (double) {
                  controller.publishToTopic(
                      SET_BRIGHTNESS_TOPIC, "$brightnessInt");
                },
                min: 1,
                max: 60,
              ),
            )
          ]),
    );
  }
}
