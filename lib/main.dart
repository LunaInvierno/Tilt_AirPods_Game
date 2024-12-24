/*import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double roll = 0.0; // Rotation angle (in radians)
  double ballXPosition = 0.0; // Horizontal position of the ball (-1.0 to 1.0)

  @override
  void initState() {
    super.initState();
    // Listen to AirPods motion updates
    FlutterAirpods.getAirPodsDeviceMotionUpdates.listen((motionData) {
      setState(() {
        // Update roll and map it to ballXPosition
        roll = (motionData.attitude.roll ?? 0.0).toDouble();

        FlutterAirpods.getAirPodsDeviceMotionUpdates.listen((motionData) {
          setState(() {
            // Update roll value (ensure it stays within -π to π)
            roll = (motionData.attitude.roll ?? 0.0).toDouble();

            // Map roll to the range -0.5 to 0.5
            double maxRoll = 0.5;
            roll = math.max(-maxRoll, math.min(maxRoll, roll));

            // Map the roll value to the horizontal position (-1.0 to 1.0)
            ballXPosition = roll / maxRoll;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tilt'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the horizontal position of the ball in pixels
            double ballPositionInPixels = (constraints.maxWidth / 2) +
                ballXPosition * (constraints.maxWidth / 2 - 20);

            return Stack(
              children: [
                Positioned(
                  top: constraints.maxHeight / 2 - 20,
                  left: ballPositionInPixels - 20, // Center the ball
                  child: BallWidget(),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Roll: ${roll.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Ball Position: ${ballXPosition.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BallWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}
*/

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  double roll = 0.0;
  double ballXPosition = 0.0;
  double speed = 5.0; // Initial speed
  List<Obstacle> obstacles = [];
  late Timer _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Listen to AirPods motion updates
    FlutterAirpods.getAirPodsDeviceMotionUpdates.listen((motionData) {
      setState(() {
        // Update roll value
        roll = (motionData.attitude.roll ?? 0.0).toDouble();

        // Clamp roll to -1.0 to 1.0 for ball position
        double maxRoll = 0.5;
        roll = math.max(-maxRoll, math.min(maxRoll, roll));
        ballXPosition = roll / maxRoll; // Map to -1.0 to 1.0
      });
    });

    // Animation controller for the game loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    )..addListener(() {
        setState(() {
          _updateObstacles();
        });
      });

    // Start the game loop
    _controller.repeat();

    // Increase speed over time
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        speed += 1.0; // Gradually increase speed
      });
    });

    // Generate initial obstacles
    _generateObstacles();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _generateObstacles() {
    obstacles = List.generate(10, (index) {
      return Obstacle(
        x: math.Random().nextDouble() * 2 -
            1, // Random x position (-1.0 to 1.0)
        y: -index * 200.0, // Spread obstacles vertically
      );
    });
  }

  void _updateObstacles() {
    for (var obstacle in obstacles) {
      obstacle.y += speed;

      // Reset obstacle position if it goes off-screen
      if (obstacle.y > 600) {
        obstacle.y = -math.Random().nextDouble() * 600;
        obstacle.x = math.Random().nextDouble() * 2 - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tilt'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: RoadPainter(obstacles: obstacles),
                ),
                Positioned(
                  bottom: 50,
                  left: constraints.maxWidth / 2 +
                      ballXPosition * (constraints.maxWidth / 2 - 20) -
                      20,
                  child: BallWidget(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BallWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  final List<Obstacle> obstacles;

  RoadPainter({required this.obstacles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    // Draw road
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      roadPaint,
    );

    // Draw road lines
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(size.width / 2 - 5, i),
        Offset(size.width / 2 - 5, i + 20),
        linePaint,
      );
    }

    // Draw obstacles
    final Paint obstaclePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (var obstacle in obstacles) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(
            size.width / 2 + obstacle.x * (size.width / 2 - 20),
            obstacle.y,
          ),
          width: 40,
          height: 40,
        ),
        obstaclePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Obstacle {
  double x; // Horizontal position (-1.0 to 1.0)
  double y; // Vertical position (pixels)

  Obstacle({required this.x, required this.y});
}
