part of 'face_detection_bloc.dart';

abstract class FaceDetectionState {}

class FaceDetectionInitial extends FaceDetectionState {}

class FaceDetectionSuccess extends FaceDetectionState {
  final User user;

  FaceDetectionSuccess(this.user);
}

class FaceDetectionError extends FaceDetectionState {
  final String errMsg;

  FaceDetectionError(this.errMsg);
}

class FaceDetectionNoInternet extends FaceDetectionState {}

class FaceDetectionNoInternetHasData extends FaceDetectionState {
  final UserAlias userAlias;

  FaceDetectionNoInternetHasData(this.userAlias);
}
