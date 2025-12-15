import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/core.dart';
import 'bloc/face_detection_bloc.dart';
import 'face_detection_action.dart';
import 'widgets/camera_screen.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> with FaceDetectionMixin {
  FlutterTts get _flutterTts => FlutterTtsHelper.flutterTts;

  void _onListenerBloc(BuildContext context, FaceDetectionState state) {
    if (state is FaceDetectionNoInternet) {
      showToastText('No internet connection');
    } else {
      hideLoading();
      Future.delayed(const Duration(seconds: 2), () => isComparing = false);
      if (state is FaceDetectionSuccess) {
        final String message = '${state.user.name}. Xin cám ơn !';
        _flutterTts.speak(message);
        context.showToastMessage(message);
      } else if (state is FaceDetectionError) {
        context.showToastMessage(state.errMsg, ToastMessageType.error);
      } else {
        context.showToastMessage('Hệ thống đã ghi nhận khuôn mặt', ToastMessageType.warning);
      }
    }
  }

  @override
  void onFaceDetectionEvent() async {
    final xFile = await cameraController!.takePicture();
    final imageFile = File(xFile.path);
    context.showLoading();
    isComparing = true;
    context.read<FaceDetectionBloc>().add(FaceDetectionCompareEvent(imageFile));
  }

  @override
  void initState() {
    super.initState();
    FlutterTtsHelper.initFlutterTts();
  }

  @override
  void dispose() {
    FlutterTtsHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ML Kit')),
      body: SafeArea(
        bottom: false,
        child: BlocListener<FaceDetectionBloc, FaceDetectionState>(
          listener: _onListenerBloc,
          child: CameraScreen(
            painter: valueListenableBuilder(
              builder: (painter) => CustomPaint(painter: painter),
            ),
            controller: cameraController,
            onCameraInitialized: initialCameraController,
          ),
        ),
      ),
      floatingActionButton: cameraController != null && cameraController!.value.isInitialized
          ? FloatingActionButton(
              onPressed: switchLiveCamera,
              child: const Icon(Icons.cameraswitch_outlined),
            )
          : const Offstage(),
    );
  }
}
