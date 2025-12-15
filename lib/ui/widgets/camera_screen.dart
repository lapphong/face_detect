import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../coordinator.dart';
import 'overlay_qr_painter.dart';

class CameraScreen extends StatefulWidget {
  final Widget? painter;
  final CameraController? controller;
  final VoidCallback? onCameraInitialized;

  const CameraScreen({
    super.key,
    required this.painter,
    required this.controller,
    required this.onCameraInitialized,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    context.checkAndRequestPermissionCamera(completed: widget.onCameraInitialized);
  }

  @override
  Widget build(BuildContext context) {
    return controller != null && controller!.value.isInitialized
        ? Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(
                controller!,
                child: widget.painter,
              ),
              CustomPaint(
                size: context.frameSize,
                painter: OverlayQrPainter(overlayRect: context.overlayRect),
              ),
            ],
          )
        : Center(
            child: TextButton.icon(
              onPressed: () => context.checkAndRequestPermissionCamera(completed: widget.onCameraInitialized),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Check Camera Permission'),
            ),
          );
  }
}
