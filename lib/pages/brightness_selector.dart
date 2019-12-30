import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

final String SET_BRIGHTNESS_TOPIC = "/esp/setBrightness";
final String SET_SPEED_TOPIC = "/esp/setSpeed";

class BrightnessPicker extends StatefulWidget {
  @override
  _BrightnessPickerState createState() => _BrightnessPickerState();
}

class _BrightnessPickerState extends State<BrightnessPicker> {
  final MqttEspCommunicator controller = MqttEspCommunicator.getInstance();
  int brightness;
  int speed;

  double uiBrightness = 10;
  double uiSpeed = 1;

  @override
  void initState() {
    super.initState();
    brightness =
        controller.currentBrightness <= 100 ? controller.currentBrightness : 10;
    speed = 10;

    controller.publishToTopic(SET_BRIGHTNESS_TOPIC, "$brightness");
    controller.publishToTopic(SET_SPEED_TOPIC, "$speed*");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Center(
                child: Text(
                  "Brightness: $uiBrightness",
                  style: TextStyle(fontSize: 30, color: Colors.grey[800]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Slider(
                  value: uiBrightness,
                  onChanged: (value) {
                    setState(() {
                      uiBrightness = value.round().toDouble();
                    });
                  },
                  onChangeEnd: (double) {
                    brightness = uiBrightness.round();
                    controller.publishToTopic(
                        SET_BRIGHTNESS_TOPIC, "$brightness");

                    setState(() {
                      uiBrightness = double.round().toDouble();
                    });
                  },
                  min: 1,
                  max: 100,
                ),
              ),
              Center(
                child: Text(
                  "Speed: $uiSpeed",
                  style: TextStyle(fontSize: 30, color: Colors.grey[800]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Slider(
                  value: uiSpeed,
                  onChanged: (value) {
                    setState(() {
                      uiSpeed = value.round().toDouble();
                    });
                  },
                  onChangeEnd: (double) {
                    speed = uiSpeed.round();
                    controller.publishToTopic(SET_SPEED_TOPIC, "$speed");

                    setState(() {
                      uiSpeed = double.round().toDouble();
                    });
                  },
                  min: 1,
                  max: 65000,
                ),
              )
            ]),
      ),
    );
  }
}
