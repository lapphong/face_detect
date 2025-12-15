import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../core/extension/context_ext.dart';
import '../core/extension/rect_ext.dart';
import 'widgets/face_detection_painter.dart';

typedef FaceCustomPainterBuilder = Widget Function(CustomPainter? value);

mixin FaceDetectionMixin<T extends StatefulWidget> on State<T> {
  List<CameraDescription> _cameras = [];
  CameraController? cameraController;

  // the overlay area for QR code scanning.
  Rect get overlayRect => context.overlayRect;

  late final FaceDetector _faceDetector;

  bool _isDetecting = false;

  int _cameraIndex = -1;

  bool isComparing = false;

  final _faceDetectionController = ValueNotifier<CustomPainter?>(null);

  void onFaceDetectionEvent() {}

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Widget valueListenableBuilder({required FaceCustomPainterBuilder builder}) {
    return ValueListenableBuilder(
      valueListenable: _faceDetectionController,
      builder: (context, value, child) {
        return builder(value);
      },
    );
  }

  void initialCameraController() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == CameraLensDirection.front) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  Future<void> switchLiveCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _stopLiveFeed();
    await _startLiveFeed();
  }

  Future<void> _stopLiveFeed() async {
    await cameraController?.stopImageStream();
    cameraController = null;
  }

  Future<void> _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize();

    if (!mounted) return;
    setState(_startFaceDetection);
  }

  void _startFaceDetection() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    cameraController!.startImageStream((image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isDetecting = false;
        return;
      }

      try {
        final List<Face> faces = await _faceDetector.processImage(inputImage);
        if (faces.isNotEmpty) {
          final face = _calculateFaceCenter(faces, inputImage.metadata!.size);
          final painter = FaceDetectionPainter(
            [?face],
            inputImage.metadata!.size,
            inputImage.metadata!.rotation,
            cameraController!.description.lensDirection,
          );
          _faceDetectionController.value = painter;
          final isFaceInsideOverlay = _checkFaceInsideOverlay(
            face,
            inputImage.metadata!.size,
            inputImage.metadata!.rotation,
          );
          if (!isComparing && isFaceInsideOverlay) {
            await Future.delayed(const Duration(seconds: 1), onFaceDetectionEvent);
          }
        } else {
          _faceDetectionController.value = null;
        }
      } catch (e) {
        if (kDebugMode) {
          print('[Start face detection error]: $e');
        }
      } finally {
        _isDetecting = false;
      }
    });
  }

  bool _checkFaceInsideOverlay(Face? face, Size imageSize, InputImageRotation rotation) {
    if (face == null) return false;
    final boundingBox = face.boundingBox.adjustedBoundingBox(
      imageSize,
      rotation,
      context.frameSize,
      cameraController!.description.lensDirection,
    );

    return context.overlayRect.containsRect(boundingBox);
  }

  Face? _calculateFaceCenter(List<Face> faces, Size imageSize) {
    final imageCenter = Offset(imageSize.width / 2, imageSize.height / 2);
    final minArea = overlayRect.width * overlayRect.height / 2;

    final validFaces = faces.where((face) {
      final area = face.boundingBox.width * face.boundingBox.height;
      return area >= minArea;
    }).toList();

    if (validFaces.isEmpty) return null;

    validFaces.sort((a, b) {
      final aDistance = (a.boundingBox.center - imageCenter).distance;
      final bDistance = (b.boundingBox.center - imageCenter).distance;
      return aDistance.compareTo(bDistance);
    });

    return validFaces.first;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameraController == null) return null;

    final InputImageRotation? rotation = _getRotationFromCamera();
    if (rotation == null) return null;

    final format = Platform.isIOS ? InputImageFormat.bgra8888 : InputImageFormat.nv21;

    final plane = image.planes.first;

    final inputImageMetaData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: plane.bytesPerRow,
    );

    final bytes = _concatenatePlanes(image.planes);
    return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetaData);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImageRotation? _getRotationFromCamera() {
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }
    var rotationCompensation = _orientations[cameraController!.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    if (camera.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
    }

    return InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }
}
