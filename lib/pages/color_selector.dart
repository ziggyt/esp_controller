import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hex/hex.dart';

final String SET_BRIGHTNESS_TOPIC = "/esp/setBrightness";
final String CHANGE_COLOR_TOPIC = "/esp/changeColor";

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final MqttEspCommunicator controller = MqttEspCommunicator.getInstance();
  double brightness = 10;
  int brightnessInt = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: MaterialColorPicker(
                  shrinkWrap: true,
                  onColorChange: (Color color) {
                    String hexColor = "0x" + HEX.encode([color.red, color.green, color.blue]).toUpperCase();
                    print(hexColor);
                    controller.publishToTopic(CHANGE_COLOR_TOPIC, hexColor);
                  },
                )),
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
