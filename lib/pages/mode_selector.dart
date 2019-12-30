import 'package:flutter/material.dart';
import 'package:esp_controller/services/mqtt_communicator.dart';

final String INCREASE_MODE_TOPIC = "/esp/increaseMode";
final String DECREASE_MODE_TOPIC = "/esp/decreaseMode";
final String SPECIFIC_MODE_TOPIC = "/esp/specific";

class ModeSelector extends StatefulWidget {
  final MqttEspCommunicator controller;

  ModeSelector({this.controller});

  @override
  _ModeSelectorState createState() =>
      _ModeSelectorState(controller: controller);
}

class _ModeSelectorState extends State<ModeSelector> {
  MqttEspCommunicator controller;
  String currentModeString = "Unknown";

  _ModeSelectorState({this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
                child: Text(
              "Current Mode",
              style: TextStyle(fontSize: 40, color: Colors.grey[900]),
            )),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              "$currentModeString",
              style: TextStyle(fontSize: 40, color: Colors.grey[900]),
            )),
      SizedBox(
        height: 20),
            LargeButton(
              controller: controller,
              text: "Increase Mode",
              onPressed: () async {
                controller.publishToTopic(INCREASE_MODE_TOPIC);
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  currentModeString = controller.currentModeString;
                  print(currentModeString);
                });
              },
            ),
            SizedBox(height: 40),
            LargeButton(
              controller: controller,
              text: "Decrease Mode",
              onPressed: () async {
                controller.publishToTopic(DECREASE_MODE_TOPIC);

                await Future.delayed(Duration(milliseconds: 500));

                setState(() {
                  currentModeString = controller.currentModeString;
                  print(currentModeString);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class LargeButton extends StatelessWidget {
  LargeButton({this.controller, this.text, this.onPressed});

  final MqttEspCommunicator controller;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 50.0),
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              textBaseline: TextBaseline.alphabetic),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
