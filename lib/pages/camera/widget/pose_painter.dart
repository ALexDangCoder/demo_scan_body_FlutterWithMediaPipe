import 'dart:ui';
import 'package:flutter/material.dart';

class PosePainter extends CustomPainter {
  final List<Offset> points;
  final double ratio;

  PosePainter({
    required this.points,
    required this.ratio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || points.length <= 32) return;

    // === Helper Functions ===
    bool areShouldersAligned(List<Offset> pts, {double tolerance = 20}) {
      return (pts[11].dy - pts[12].dy).abs() <= tolerance;
    }

    bool isWristNearChest(Offset wrist, Offset center, {double maxDist = 60}) {
      return (wrist.dx - center.dx).abs() < maxDist;
    }

    bool isAnkleNearHip(Offset ankle, Offset hip, {double maxDist = 80}) {
      return (ankle.dx - hip.dx).abs() < maxDist &&
          (ankle.dy - hip.dy).abs() < maxDist;
    }

    // === Key Points ===
    final centerChest = Offset((points[11].dx + points[12].dx) / 2,
        (points[11].dy + points[12].dy) / 2);

    final leftWrist = points[16];
    final rightWrist = points[15];
    final leftAnkle = points[28];
    final rightAnkle = points[27];
    final leftHip = points[24];
    final rightHip = points[23];

    final leftArmCorrect = isWristNearChest(leftWrist, centerChest);
    final rightArmCorrect = isWristNearChest(rightWrist, centerChest);
    final shouldersAligned = areShouldersAligned(points);
    final leftLegCorrect = isAnkleNearHip(leftAnkle, leftHip);
    final rightLegCorrect = isAnkleNearHip(rightAnkle, rightHip);

    final armsCorrect = leftArmCorrect && rightArmCorrect;
    final legsCorrect = leftLegCorrect && rightLegCorrect;
    final isMeditationPose = armsCorrect && legsCorrect && shouldersAligned;

    // === Paints ===
    final leftPaint = Paint()
      ..color = leftArmCorrect ? Colors.green : Colors.red
      ..strokeWidth = 2;
    final rightPaint = Paint()
      ..color = rightArmCorrect ? Colors.green : Colors.red
      ..strokeWidth = 2;
    final leftLegPaint = Paint()
      ..color = leftLegCorrect ? Colors.green : Colors.red
      ..strokeWidth = 2;
    final rightLegPaint = Paint()
      ..color = rightLegCorrect ? Colors.green : Colors.red
      ..strokeWidth = 2;
    final bodyPaint = Paint()
      ..color = isMeditationPose ? Colors.green : Colors.red
      ..strokeWidth = 2;

    // === Draw body parts ===
    canvas.drawPoints(
      PointMode.polygon,
      [points[12], points[14], points[16], points[18], points[20], points[16]]
          .map((p) => p * ratio)
          .toList(),
      leftPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[16], points[22]].map((p) => p * ratio).toList(),
      leftPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[11], points[13], points[15], points[17], points[19], points[15]]
          .map((p) => p * ratio)
          .toList(),
      rightPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[15], points[21]].map((p) => p * ratio).toList(),
      rightPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[24], points[26], points[28], points[32], points[30], points[28]]
          .map((p) => p * ratio)
          .toList(),
      leftLegPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[23], points[25], points[27], points[29], points[31], points[27]]
          .map((p) => p * ratio)
          .toList(),
      rightLegPaint,
    );
    canvas.drawPoints(
      PointMode.polygon,
      [points[11], points[12], points[24], points[23], points[11]]
          .map((p) => p * ratio)
          .toList(),
      bodyPaint,
    );

    // === Collect error messages ===
    List<String> errors = [];

    if (!shouldersAligned) errors.add("Shoulders not aligned");
    if (!leftArmCorrect) errors.add("Left arm not folded");
    if (!rightArmCorrect) errors.add("Right arm not folded");
    if (!leftLegCorrect) errors.add("Left leg not folded");
    if (!rightLegCorrect) errors.add("Right leg not folded");

    if (errors.isNotEmpty) {
      final text = errors.join("\n");

      final textSpan = TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ));

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: errors.length,
      );

      textPainter.layout();

      const padding = 10.0;
      final bgWidth = textPainter.width + padding * 2;
      final bgHeight = textPainter.height + padding * 2;

      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 10, bgWidth, bgHeight),
        const Radius.circular(8),
      );

      final backgroundPaint = Paint()..color = Colors.white.withOpacity(0.9);
      final borderPaint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke;

      canvas.drawRRect(bgRect, backgroundPaint);
      canvas.drawRRect(bgRect, borderPaint);

      textPainter.paint(canvas, const Offset(10 + padding, 10 + padding));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
