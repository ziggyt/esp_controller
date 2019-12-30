import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:random_string/random_string.dart';

class MqttEspCommunicator {
  final MqttClient client = MqttClient('192.168.1.201', '1883');

  final String CURRENT_MODE_TOPIC = "/esp/mode";
  final String CURRENT_MODE_STRING_TOPIC = "/esp/modeString";
  final String CURRENT_BRIGHTNESS_TOPIC = "/esp/brightness";
  final String CURRENT_COLOR_TOPIC = "/esp/color";
  final String CURRENT_SPEED_TOPIC = "/esp/speed";

  int currentMode = -999;
  int currentBrightness = -999;
  int currentSpeed = 10000;
  String currentModeString = "Unknown";
  Color currentColor;
  static MqttEspCommunicator controller = MqttEspCommunicator();

  static MqttEspCommunicator getInstance() {
    return controller;
  }

  void subscribeToTopics() {
    client.onSubscribed = onSubscribed;

    client.subscribe(CURRENT_MODE_STRING_TOPIC, MqttQos.atLeastOnce);
    client.subscribe(CURRENT_MODE_TOPIC, MqttQos.atLeastOnce);
    client.subscribe(CURRENT_BRIGHTNESS_TOPIC, MqttQos.atLeastOnce);
    client.subscribe(CURRENT_COLOR_TOPIC, MqttQos.atLeastOnce);
    client.subscribe(CURRENT_SPEED_TOPIC, MqttQos.atLeastOnce);
  }

  Future<void> publishToTopic(String topic, [String message = ""]) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('EXAMPLE::Publishing to $topic with message: $message');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  Future<void> connectToMqttClient() async {
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(randomAlpha(20));
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
  }

  void listenForUpdates() {
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String topic = c[0].topic;
      String message = pt;

      handleMessage(topic, message);
    });
  }

  void handleMessage(String topic, String message) {
    print(
        'Change notification:: topic is <$topic>, payload is <-- $message -->');

    if (topic == CURRENT_MODE_TOPIC) {
      currentMode = int.parse(message);
      print("Current mode is $currentMode");
    }
    if (topic == CURRENT_BRIGHTNESS_TOPIC) {
      currentBrightness = int.parse(message);
    }
    if (topic == CURRENT_MODE_STRING_TOPIC) {
      currentModeString = message;
      print("CurrentModeString: $currentModeString");
    }
    if (topic == CURRENT_COLOR_TOPIC) {
      currentColor = Color(int.parse(message));
    }
    if (topic == CURRENT_SPEED_TOPIC) {
      currentSpeed = int.parse(message);
    }
  }

  Future<void> main() async {
    setupMqtt();
  }

  Future<void> setupMqtt() async {
    await connectToMqttClient();
    subscribeToTopics();
    listenForUpdates();
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    connectToMqttClient();
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  void printDebugInfo() {
    client.published.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });
  }
}
