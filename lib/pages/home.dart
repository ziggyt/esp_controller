import 'package:esp_controller/pages/color_selector.dart';
import 'package:esp_controller/pages/mode_selector.dart';
import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class Home extends StatefulWidget {
  final MqttEspCommunicator controller = MqttEspCommunicator.getInstance();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<Widget> _children;
  
  List<Color> colors = [Colors.lightBlueAccent, Colors.pinkAccent[100]];

  @override
  void initState() {
    super.initState();
    _children = [ColorPicker(), ModeSelector(), PlaceholderWidget(Colors.green)];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: colors),
        title: Text('NodeMCU MQTT Controller'),
        automaticallyImplyLeading: false,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            title: Text('Mode'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.brightness_4), title: Text('Brightness'))
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
