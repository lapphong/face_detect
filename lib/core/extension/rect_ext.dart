import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../core.dart';

extension RectExt on Rect {
  Rect adjustedBoundingBox(
    Size imageSize,
    InputImageRotation rotation,
    Size canvasSize,
    CameraLensDirection lensDirection,
  ) {
    final left = rotation.translateX(this.left, canvasSize, imageSize, lensDirection);
    final top = rotation.translateY(this.top, canvasSize, imageSize);
    final right = rotation.translateX(this.right, canvasSize, imageSize, lensDirection);
    final bottom = rotation.translateY(this.bottom, canvasSize, imageSize);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  bool containsRect(Rect boundingBox) {
    final l1 = math.min(left, right);
    final r1 = math.max(left, right);
    final t1 = math.min(top, bottom);
    final b1 = math.max(top, bottom);

    final l2 = math.min(boundingBox.left, boundingBox.right);
    final r2 = math.max(boundingBox.left, boundingBox.right);
    final t2 = math.min(boundingBox.top, boundingBox.bottom);
    final b2 = math.max(boundingBox.top, boundingBox.bottom);

    return l1 <= l2 && t1 <= t2 && r1 >= r2 && b1 >= b2;
  }
}
