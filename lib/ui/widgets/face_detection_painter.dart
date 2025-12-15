import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../core/core.dart';

class FaceDetectionPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  FaceDetectionPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint facePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    final Paint landmarkPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.75;

    final Paint textPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    for (int i = 0; i < faces.length; i++) {
      final Face face = faces[i];
      final boundingBox = face.boundingBox;

      final rectFace = boundingBox.adjustedBoundingBox(imageSize, rotation, size, cameraLensDirection);
      canvas.drawRect(rectFace, facePaint);

      void drawLandmark(FaceLandmarkType type) {
        final landmark = face.landmarks[type];
        if (landmark != null) {
          final double x = rotation.translateX(landmark.position.x.toDouble(), size, imageSize, cameraLensDirection);
          final double y = rotation.translateY(landmark.position.y.toDouble(), size, imageSize);
          canvas.drawCircle(Offset(x, y), 4.0, landmarkPaint);
        }
      }

      drawLandmark(FaceLandmarkType.leftEye);
      drawLandmark(FaceLandmarkType.rightEye);
      drawLandmark(FaceLandmarkType.noseBase);
      drawLandmark(FaceLandmarkType.leftMouth);
      drawLandmark(FaceLandmarkType.rightMouth);
      drawLandmark(FaceLandmarkType.bottomMouth);

      String smileText;
      Color smileColor;
      final smilePercent = (face.smilingProbability! * 100).round();
      if (smilePercent > 70) {
        smileText = '😊 Happy ($smilePercent%)';
        smileColor = Colors.green;
      } else if (smilePercent > 40) {
        smileText = '😐 Neutral ($smilePercent%)';
        smileColor = Colors.yellow;
      } else {
        smileText = '😞 Sad ($smilePercent%)';
        smileColor = Colors.red;
      }

      final textSpan = TextSpan(
        text: smileText,
        style: TextStyle(color: smileColor),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      final left = rotation.translateX(face.boundingBox.left, size, imageSize, cameraLensDirection);
      final top = rotation.translateY(face.boundingBox.top, size, imageSize);
      final right = rotation.translateX(face.boundingBox.right, size, imageSize, cameraLensDirection);

      final leftReact = rotation == InputImageRotation.rotation270deg ? right : left;
      textPainter.layout();

      final textReact = Rect.fromLTWH(
        leftReact,
        top - textPainter.height - 10,
        textPainter.width + 14,
        textPainter.height + 8,
      );

      canvas.drawRRect(RRect.fromRectAndRadius(textReact, const Radius.circular(8)), textPaint);
      textPainter.paint(canvas, Offset(leftReact + 8, top - textPainter.height - 6));
    }
  }

  @override
  bool shouldRepaint(FaceDetectionPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
