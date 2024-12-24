/*import 'package:flutter/material.dart';
import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double cubePosition = 0.0; // Position of the cube
  late final StreamSubscription<DeviceMotionData> _airPodsSubscription;

  @override
  void initState() {
    super.initState();
    startAirPodsListener();
  }

  void startAirPodsListener() {
    // Start listening to AirPods device motion updates
    _airPodsSubscription = FlutterAirpods.getAirPodsDeviceMotionUpdates
        .listen((DeviceMotionData data) {
      setState(() {
        // Use the roll value to determine head tilt
        final roll = data.attitude.roll;

        // Move the cube based on the roll value
        if (roll > 0.5) {
          cubePosition += 5; // Move right
        } else if (roll < -0.5) {
          cubePosition -= 5; // Move left
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _airPodsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AirPods Cube Controller'),
      ),
      body: Stack(
        children: [
          Positioned(
            left:
                cubePosition.clamp(0.0, MediaQuery.of(context).size.width - 50),
            top: 200,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
*/
