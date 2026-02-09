import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/core.dart';
import '../../data/alias_hive.dart';
import '../../data/api.dart';
import '../../domain/user.dart';
import '../../domain/user_alias.dart';

part 'face_detection_event.dart';
part 'face_detection_state.dart';

Stream<T> singleEventTransformer<T>(Stream<T> events, EventMapper<T> mapper) {
  return events.exhaustMap(mapper);
}

class FaceDetectionBloc extends Bloc<FaceDetectionEvent, FaceDetectionState> {
  late final StreamSubscription _subscription;
  final AliasHive aliasHive;

  FaceDetectionBloc(this.aliasHive) : super(FaceDetectionInitial()) {
    on<FaceDetectionCompareEvent>(_faceDetectionEvent, transformer: singleEventTransformer);
    _subscription = ConnectivityHelper.onConnectivityChanged.listen((isConnected) {
      if (!isConnected) {
        emit(FaceDetectionNoInternet());
      } else {
        _onNetworkAvailable();
      }
    });
  }

  Future<void> _onNetworkAvailable() async {
    final userAliases = await aliasHive.getUserAliases();
    if (userAliases.isNotEmpty) {
      for (final alias in userAliases) {
        final file = await FileHelper.convertUint8ListToFile(alias.file);
        add(FaceDetectionCompareEvent(file, id: alias.id));
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  FutureOr<void> _faceDetectionEvent(
    FaceDetectionCompareEvent event,
    Emitter<FaceDetectionState> emit,
  ) async {
    try {
      final user = await fetchData(event.file);
      if (user.isMatch) {
        emit(FaceDetectionSuccess(user));
      } else {
        emit(FaceDetectionError('Face does not match.'));
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        final errorCode = (e.error as SocketException).osError?.errorCode;
        if (errorCode == 101 || errorCode == 51) {
          final alias = await saveFaceDetection(event.file);
          emit(FaceDetectionNoInternetHasData(alias));
          return;
        }
      }
      final statusCode = e.response?.statusCode;
      emit(FaceDetectionError(statusCode != null ? 'Face not found: ${statusCode.toString()}' : 'Server error: 500'));
    } finally {
      if (event.id.isNotEmpty) {
        unawaited(aliasHive.delete(event.id));
      }
    }
  }

  Future<UserAlias> saveFaceDetection(File file) async {
    final alias = UserAlias(date: DateTime.now().toString(), file: file.readAsBytesSync());
    await aliasHive.addUserAlias(alias);
    return alias;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
