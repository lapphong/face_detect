import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/user.dart';

final dio = Dio(
  BaseOptions(
    // Go to https://github.com/lapphong/face_server, run it, and replace this `baseUrl` with the `Running http://192.168...:5100` output
    baseUrl: 'baseUrl',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ),
);

// Future<File> _copyAssetToFile(String assetPath) async {
//   final byteData = await rootBundle.load(assetPath);

//   final tempDir = await getTemporaryDirectory();
//   final tempFile = File('${tempDir.path}/ronaldo.jpg');

//   await tempFile.writeAsBytes(
//     byteData.buffer.asUint8List(),
//     flush: true,
//   );

//   return tempFile;
// }

Future<User> fetchData(File file) async {
  try {
    // final file = await _copyAssetToFile('assets/images/ronaldo.jpg');
    final response = await dio.post(
      '/compare',
      data: FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      }),
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    final user = User.fromJson(response.data);
    return user;
  } on DioException catch (e) {
    if (kDebugMode) {
      print('[Error fetching data]: ${e.message}');
    }
    rethrow;
  }
}
