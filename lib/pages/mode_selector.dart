import 'package:flutter/material.dart';
import 'package:esp_controller/services/mqtt_communicator.dart';

final String INCREASE_MODE_TOPIC = "/esp/increaseMode";
final String DECREASE_MODE_TOPIC = "/esp/decreaseMode";
final String SPECIFIC_MODE_TOPIC = "/esp/specific";

class ModeSelector extends StatefulWidget {

  @override
  _ModeSelectorState createState() =>
      _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  final MqttEspCommunicator controller = MqttEspCommunicator.getInstance();

  String currentModeString = "Unknown";
  int currentMode = 0;

  @override
  void initState() {
    super.initState();

    currentModeString = controller.currentModeString;
    currentMode = controller.currentMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              "Current Mode ($currentMode)",
              style: TextStyle(fontSize: 45, color: Colors.grey[900], fontStyle: FontStyle.italic),
            )),
            SizedBox(
              height: 40,
            ),
            Center(
                child: Text(
              "$currentModeString",
              style: TextStyle(fontSize: 30, color: Colors.grey[900]),
            )),
      SizedBox(
        height: 70),
            LargeButton(
              controller: controller,
              text: "Increase Mode",
              onPressed: () async {
                controller.publishToTopic(INCREASE_MODE_TOPIC);
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  currentModeString = controller.currentModeString;
                  currentMode = controller.currentMode;
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
                  currentMode = controller.currentMode;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Center(
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
      ),
    );
  }
}
