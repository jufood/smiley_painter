// In-Class Activity 06 — Drawing with Flutter
// Student: Jinsung Han
// Date: October 1, 2026

import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SmileyApp());
}

enum FaceType {
  classic,
  sleepy,
  surprised,
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smiley Painter Lab',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType faceType = FaceType.classic;
  Color faceColor = Colors.orangeAccent;

  final Random random = Random();

  String get faceName {
    switch (faceType) {
      case FaceType.classic:
        return 'Classic';
      case FaceType.sleepy:
        return 'Sleepy';
      case FaceType.surprised:
        return 'Surprised';
    }
  }

  Color colorForMood(double value) {
    if (value < 0.35) {
      return Colors.lightBlue;
    } else if (value <= 0.7) {
      return Colors.yellow;
    } else {
      return Colors.orangeAccent;
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void cycleFace() {
    setState(() {
      if (faceType == FaceType.classic) {
        faceType = FaceType.sleepy;
      } else if (faceType == FaceType.sleepy) {
        faceType = FaceType.surprised;
      } else {
        faceType = FaceType.classic;
      }
    });

    showMessage('Face changed to $faceName');
  }

  void randomizeFace() {
    final colors = [
      Colors.orangeAccent,
      Colors.yellow,
      Colors.lightBlue,
      Colors.pinkAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
    ];

    setState(() {
      mood = random.nextDouble();
      faceColor = colors[random.nextInt(colors.length)];
    });

    showMessage(
      'Random mood: ${mood.toStringAsFixed(2)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: cycleFace,
                onLongPress: randomizeFace,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: SmileyPainter(
                    mood: mood,
                    faceType: faceType,
                    faceColor: faceColor,
                  ),
                ),
              ),
            ),
          ),

          Text(
            'Face: $faceName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.classic;
                  });
                },
                child: const Text('Classic'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.sleepy;
                  });
                },
                child: const Text('Sleepy'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.surprised;
                  });
                },
                child: const Text('Surprised'),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Mood: ${mood.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                Slider(
                  value: mood,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (double value) {
                    setState(() {
                      mood = value;
                      faceColor = colorForMood(value);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
    required this.faceColor,
  });

  final double mood;
  final FaceType faceType;
  final Color faceColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    // Face
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // Border
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeStrokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.2;
    final eyeDistance = radius * 0.35;
    final eyeRadius = radius * 0.08;

    if (faceType == FaceType.classic) {
      canvas.drawCircle(
        Offset(center.dx - eyeDistance, eyeY),
        eyeRadius,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDistance, eyeY),
        eyeRadius,
        eyePaint,
      );

      if (mood < 0.35) {
        final mouthRect = Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy + radius * 0.35,
          ),
          width: radius,
          height: radius * 0.5,
        );

        canvas.drawArc(
          mouthRect,
          1.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else if (mood <= 0.7) {
        final mouthRect = Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy + radius * 0.15,
          ),
          width: radius * 0.85,
          height: radius * 0.35,
        );

        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else {
        final mouthRect = Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy + radius * 0.15,
          ),
          width: radius * 1.1,
          height: radius * 0.75,
        );

        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }
    } else if (faceType == FaceType.sleepy) {
      final leftEyeRect = Rect.fromCenter(
        center: Offset(
          center.dx - eyeDistance,
          eyeY,
        ),
        width: radius * 0.28,
        height: radius * 0.18,
      );

      final rightEyeRect = Rect.fromCenter(
        center: Offset(
          center.dx + eyeDistance,
          eyeY,
        ),
        width: radius * 0.28,
        height: radius * 0.18,
      );

      canvas.drawArc(
        leftEyeRect,
        0,
        pi,
        false,
        eyeStrokePaint,
      );

      canvas.drawArc(
        rightEyeRect,
        0,
        pi,
        false,
        eyeStrokePaint,
      );

      final sleepyMouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.28,
        ),
        width: radius * 0.65,
        height: radius * 0.22,
      );

      canvas.drawArc(
        sleepyMouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else if (faceType == FaceType.surprised) {
      final bigEyeRadius = radius * 0.13;

      canvas.drawCircle(
        Offset(center.dx - eyeDistance, eyeY),
        bigEyeRadius,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDistance, eyeY),
        bigEyeRadius,
        eyePaint,
      );

      final surprisedMouthPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy + radius * 0.3,
          ),
          width: radius * 0.42,
          height: radius * 0.55,
        ),
        surprisedMouthPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType ||
        oldDelegate.faceColor != faceColor;
  }
}