import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  FileHelper._();

  static Future<File> convertUint8ListToFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await file.writeAsBytes(data);

    return file;
  }
}
