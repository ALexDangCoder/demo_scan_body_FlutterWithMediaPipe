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
    if (points.isNotEmpty && points.length > 32) {
      // Kiểm tra vai thẳng hàng
      bool areShouldersAligned(List<Offset> pts, {double tolerance = 20}) {
        return (pts[11].dy - pts[12].dy).abs() <= tolerance;
      }

      // Kiểm tra cổ tay gần giữa ngực
      bool isWristNearChest(Offset wrist, Offset center,
          {double maxDist = 60}) {
        return (wrist.dx - center.dx).abs() < maxDist;
      }

      final centerChest = Offset((points[11].dx + points[12].dx) / 2,
          (points[11].dy + points[12].dy) / 2);

      final leftWrist = points[16];
      final rightWrist = points[15];

      final leftCorrect = isWristNearChest(leftWrist, centerChest);
      final rightCorrect = isWristNearChest(rightWrist, centerChest);
      final shouldersAligned = areShouldersAligned(points);
      final isMeditationPose = leftCorrect && rightCorrect && shouldersAligned;

      final leftPaint = Paint()
        ..color = leftCorrect ? Colors.green : Colors.red
        ..strokeWidth = 2;
      final rightPaint = Paint()
        ..color = rightCorrect ? Colors.green : Colors.red
        ..strokeWidth = 2;
      final bodyPaint = Paint()
        ..color = isMeditationPose ? Colors.green : Colors.red
        ..strokeWidth = 2;

      // left
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[12],
          points[14],
          points[16],
          points[18],
          points[20],
          points[16],
        ].map((p) => p * ratio).toList(),
        leftPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [points[16], points[22]].map((p) => p * ratio).toList(),
        leftPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [points[24], points[26], points[28], points[32], points[30], points[28]]
            .map((p) => p * ratio)
            .toList(),
        leftPaint,
      );

      // right
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[11],
          points[13],
          points[15],
          points[17],
          points[19],
          points[15],
        ].map((p) => p * ratio).toList(),
        rightPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [points[15], points[21]].map((p) => p * ratio).toList(),
        rightPaint,
      );
      canvas.drawPoints(
        PointMode.polygon,
        [points[23], points[25], points[27], points[29], points[31], points[27]]
            .map((p) => p * ratio)
            .toList(),
        rightPaint,
      );

      // body
      canvas.drawPoints(
        PointMode.polygon,
        [
          points[11],
          points[12],
          points[24],
          points[23],
          points[11],
        ].map((p) => p * ratio).toList(),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
