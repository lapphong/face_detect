part of 'face_detection_bloc.dart';

abstract class FaceDetectionEvent {}

class FaceDetectionCompareEvent extends FaceDetectionEvent {
  final File file;
  final String id;

  FaceDetectionCompareEvent(this.file, {this.id = ''});
}
