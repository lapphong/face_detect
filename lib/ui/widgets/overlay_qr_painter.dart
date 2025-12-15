import 'dart:math';

import 'package:flutter/material.dart';

const double cornerLength = 30.0;
const double radius = 20.0;

class OverlayQrPainter extends CustomPainter {
  final Rect overlayRect;

  OverlayQrPainter({required this.overlayRect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      overlayPaint,
    );

    canvas.drawRRect(
      RRect.fromRectXY(overlayRect, 16, 16),
      clearPaint,
    );

    canvas.restore();

    void drawCorner(Canvas canvas, Offset origin, double angle) {
      canvas.save();
      canvas.translate(origin.dx, origin.dy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, radius);
      path.arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      );
      path.moveTo(0, radius);
      path.lineTo(0, cornerLength);
      path.moveTo(radius, 0);
      path.lineTo(cornerLength, 0);

      canvas.drawPath(path, paint);
      canvas.restore();
    }

    drawCorner(canvas, overlayRect.topLeft, 0);

    drawCorner(canvas, overlayRect.topRight, pi / 2);

    drawCorner(canvas, overlayRect.bottomRight, pi);

    drawCorner(canvas, overlayRect.bottomLeft, 3 * pi / 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
