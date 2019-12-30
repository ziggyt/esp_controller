import 'package:esp_controller/pages/home.dart';
import 'package:esp_controller/pages/mode_selector.dart';
import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  MqttEspCommunicator controller = MqttEspCommunicator.getInstance();
  String loadingMsg = "Connecting to MQTT broker...";
  List<Color> colors = [Colors.lightBlueAccent, Colors.pinkAccent[100]];

  @override
  void initState() {
    super.initState();

    initMqtt();
  }

  void initMqtt() async {
    await controller.setupMqtt();
    print("Loaded mqtt connection $controller");

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loadingMsg = "Connected!";
    });

    await Future.delayed(Duration(seconds: 2));
    Navigator.push(
        context, new MaterialPageRoute(builder: (__) => new Home(controller)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueAccent,
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 60,
                ),
              ),
              SizedBox(height: 55,),
              Text(
                loadingMsg,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
