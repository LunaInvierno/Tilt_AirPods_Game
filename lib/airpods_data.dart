import 'package:flutter/material.dart';

import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tilt'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: StreamBuilder<DeviceMotionData>(
              stream: FlutterAirpods.getAirPodsDeviceMotionUpdates,
              builder: (BuildContext context,
                  AsyncSnapshot<DeviceMotionData> snapshot) {
                if (snapshot.hasData) {
                  // Zugriff auf die Roll-Komponente
                  final rollValue = snapshot.data?.attitude.roll ?? 0.0;
                  // Anzeigen des Roll-Werts
                  return Text(
                    "Roll: ${rollValue.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 20),
                  );
                } else {
                  // Falls keine Daten vorhanden sind
                  return const Text("Waiting for incoming data...");
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
