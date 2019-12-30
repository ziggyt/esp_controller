import 'package:esp_controller/pages/brightness_selector.dart';
import 'package:esp_controller/pages/color_selector.dart';
import 'package:esp_controller/pages/mode_selector.dart';
import 'package:esp_controller/services/mqtt_communicator.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class Home extends StatefulWidget {
  final MqttEspCommunicator controller = MqttEspCommunicator.getInstance();
  static Color selectedColor = Colors.white;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<Widget> _children;

  //List<Color> colors = [Colors.lightBlueAccent, Colors.pinkAccent[100]];
  List<Color> colors = [Colors.blue[900], Colors.grey[500]];

  @override
  void initState() {
    super.initState();
    _children = [ModeSelector(), ColorPicker(), BrightnessPicker()];
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
        centerTitle: true,
        title: Text('NodeMCU MQTT Controller'),
        automaticallyImplyLeading: false,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            title: Text('Mode'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            title: Text('Color'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.brightness_4), title: Text('Brightness / Speed'))
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
