import 'package:esp_controller/pages/home.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
                child: MaterialColorPicker(
                  allowShades: true,
                  //shrinkWrap: true,
                  selectedColor: Home.selectedColor,
                  onColorChange: (Color color) {
                    String hexColor = "0x" +
                        HEX.encode(
                            [color.red, color.green, color.blue]).toUpperCase();
                    controller.publishToTopic(CHANGE_COLOR_TOPIC, hexColor);
                    setState(() {
                      Home.selectedColor = color;
                    });
                  },
                )),
            //SizedBox(height: 40),
            Container(
                padding: EdgeInsets.all(20.0),
                child: Text("Current Color"),
                decoration: BoxDecoration(
                    color: Home.selectedColor))
          ]),
    );
  }
}
