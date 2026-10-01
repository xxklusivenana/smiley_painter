// In-Class Activity 06 — Drawing with Flutter
// Student: Janiya Green
// Date: September 26, 2026

import 'dart:math' show pi, Random;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

// three preset faces
enum FaceType {
  classic,
  sleepy,
  surprised,
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {

  // 0.0 = sad, 0.5 = neutral, 1.0 = happy.
  double mood = 0.8;

  // Controls the size of both eyes.
  double eyeRadius = 10.0;

  // Controls the distance between the two eyes.
  double eyeGap = 0.35;

  // Controls the face color using a hue from 0 to 360.
  double colorHue = 50.0;

  // Controls whether blush is visible.
  bool showBlush = false;

  // Current preset face.
  FaceType faceType = FaceType.classic;

  final Random random = Random();
  void _selectFace(FaceType type) {
    setState(() {
      faceType = type;
    });

    _showMessage('${_faceName(type)} face selected');
  }

  void _cycleFace() {
    setState(() {
      switch (faceType) {
        case FaceType.classic:
          faceType = FaceType.sleepy;
          break;

        case FaceType.sleepy:
          faceType = FaceType.surprised;
          break;

        case FaceType.surprised:
          faceType = FaceType.classic;
          break;
      }
    });

    _showMessage('${_faceName(faceType)} face selected');
  }

  void _randomizeFace() {
    setState(() {
      mood = random.nextDouble();

      eyeRadius = 6 + random.nextDouble() * 12;

      eyeGap = 0.25 + random.nextDouble() * 0.25;

      colorHue = random.nextDouble() * 360;

      showBlush = random.nextBool();

      faceType =
          FaceType.values[random.nextInt(FaceType.values.length)];
    });

    _showMessage(
      'Randomized ${_faceName(faceType)} face',
    );
  }

  String _faceName(FaceType type) {
    switch (type) {
      case FaceType.classic:
        return 'Classic';

      case FaceType.sleepy:
        return 'Sleepy';

      case FaceType.surprised:
        return 'Surprised';
    }
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                // Tap cycles through Classic → Sleepy → Surprised.
                onTap: _cycleFace,

                // Long press randomizes the face settings.
                onLongPress: _randomizeFace,

                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: SmileyPainter(
                    mood: mood,
                    eyeRadius: eyeRadius,
                    eyeGap: eyeGap,
                    colorHue: colorHue,
                    showBlush: showBlush,
                    faceType: faceType,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16,
            ),
            child: Column(
              children: [
                Text(
                  '${_faceName(faceType)} Face',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text('Mood'),
                    ),

                    Expanded(
                      child: Slider(
                        value: mood,
                        min: 0.0,
                        max: 1.0,
                        divisions: 100,
                        label: mood.toStringAsFixed(2),
                        onChanged: (double value) {
                          setState(() {
                            mood = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      width: 45,
                      child: Text(
                        mood.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text('Eye Radius'),
                    ),

                    Expanded(
                      child: Slider(
                        value: eyeRadius,
                        min: 4.0,
                        max: 18.0,
                        divisions: 28,
                        label: eyeRadius.toStringAsFixed(1),
                        onChanged: (double value) {
                          setState(() {
                            eyeRadius = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      width: 45,
                      child: Text(
                        eyeRadius.toStringAsFixed(1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text('Eye Gap'),
                    ),

                    Expanded(
                      child: Slider(
                        value: eyeGap,
                        min: 0.20,
                        max: 0.55,
                        divisions: 35,
                        label: eyeGap.toStringAsFixed(2),
                        onChanged: (double value) {
                          setState(() {
                            eyeGap = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      width: 45,
                      child: Text(
                        eyeGap.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text('Face Color'),
                    ),

                    Expanded(
                      child: Slider(
                        value: colorHue,
                        min: 0.0,
                        max: 360.0,
                        divisions: 360,
                        activeColor: HSVColor.fromAHSV(
                          1,
                          colorHue,
                          0.65,
                          0.95,
                        ).toColor(),
                        label: '${colorHue.toInt()}°',
                        onChanged: (double value) {
                          setState(() {
                            colorHue = value;
                          });
                        },
                      ),
                    ),

                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: HSVColor.fromAHSV(
                          1,
                          colorHue,
                          0.65,
                          0.95,
                        ).toColor(),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: showBlush,
                      onChanged: (bool? value) {
                        setState(() {
                          showBlush = value ?? false;
                        });
                      },
                    ),

                    const Text('Show Blush'),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _selectFace(FaceType.classic);
                      },
                      child: const Text('Classic'),
                    ),

                    const SizedBox(width: 6),

                    OutlinedButton(
                      onPressed: () {
                        _selectFace(FaceType.sleepy);
                      },
                      child: const Text('Sleepy'),
                    ),

                    const SizedBox(width: 6),

                    OutlinedButton(
                      onPressed: () {
                        _selectFace(FaceType.surprised);
                      },
                      child: const Text('Surprised'),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Tap the face to change designs • '
                  'Long-press to randomize',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
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
    required this.eyeRadius,
    required this.eyeGap,
    required this.colorHue,
    required this.showBlush,
    required this.faceType,
  });

  final double mood;
  final double eyeRadius;
  final double eyeGap;
  final double colorHue;
  final bool showBlush;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.40;

    final faceColor = HSVColor.fromAHSV(
      1.0,
      colorHue,
      0.65,
      0.95,
    ).toColor();

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    switch (faceType) {
      case FaceType.classic:
        _drawClassicFace(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.sleepy:
        _drawSleepyFace(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.surprised:
        _drawSurprisedFace(
          canvas,
          center,
          radius,
        );
        break;
    }

    if (showBlush) {
      _drawBlush(
        canvas,
        center,
        radius,
      );
    }
  }

  void _drawClassicFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY = center.dy - radius * 0.18;

    final eyeDx = radius * eyeGap;

    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.15,
      ),
      width: radius * 1.0,
      height: radius * (0.4 + mood * 0.5),
    );

    if (mood < 0.35) {
      final frownRect = mouthRect.translate(
        0,
        radius * 0.25,
      );

      canvas.drawArc(
        frownRect,
        1.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }

    else {
      canvas.drawArc(
        mouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }
  }

  void _drawSleepyFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final sleepyPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.12;
    final eyeDx = radius * eyeGap;

    // Closed left eyes
    final leftEye = Rect.fromCenter(
      center: Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      width: eyeRadius * 2.2,
      height: eyeRadius * 1.2,
    );

    canvas.drawArc(
      leftEye,
      0,
      pi,
      false,
      sleepyPaint,
    );

    final rightEye = Rect.fromCenter(
      center: Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      width: eyeRadius * 2.2,
      height: eyeRadius * 1.2,
    );

    canvas.drawArc(
      rightEye,
      0,
      pi,
      false,
      sleepyPaint,
    );

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.22,
      ),
      width: radius * 0.75,
      height: radius * 0.35,
    );

    canvas.drawArc(
      mouthRect,
      0.15 * pi,
      0.70 * pi,
      false,
      sleepyPaint,
    );
  }

  void _drawSurprisedFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * eyeGap;

    final surprisedEyeRadius = eyeRadius * 1.25;

    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      surprisedEyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      surprisedEyeRadius,
      eyePaint,
    );

    // Open surprised mouth.
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.20,
        ),
        width: radius * 0.42,
        height: radius * 0.60,
      ),
      mouthPaint,
    );
  }

  void _drawBlush(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final blushPaint = Paint()
      ..color = Colors.pink.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    // Left blush oval.
    final leftBlush = Rect.fromCenter(
      center: Offset(
        center.dx - radius * 0.62,
        center.dy + radius * 0.22,
      ),
      width: radius * 0.32,
      height: radius * 0.16,
    );

    // Right blush oval.
    final rightBlush = Rect.fromCenter(
      center: Offset(
        center.dx + radius * 0.62,
        center.dy + radius * 0.22,
      ),
      width: radius * 0.32,
      height: radius * 0.16,
    );

    canvas.drawOval(
      leftBlush,
      blushPaint,
    );

    canvas.drawOval(
      rightBlush,
      blushPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant SmileyPainter oldDelegate,
  ) {
    // Every value used by paint() is checked here.
    return oldDelegate.mood != mood ||
        oldDelegate.eyeRadius != eyeRadius ||
        oldDelegate.eyeGap != eyeGap ||
        oldDelegate.colorHue != colorHue ||
        oldDelegate.showBlush != showBlush ||
        oldDelegate.faceType != faceType;
  }
}