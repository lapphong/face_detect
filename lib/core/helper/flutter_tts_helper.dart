import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsHelper {
  static final FlutterTts flutterTts = FlutterTts();

  FlutterTtsHelper._();

  static Future<void> initFlutterTts() async {
    if (Platform.isIOS) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
        IosTextToSpeechAudioMode.defaultMode,
      );
    }
    await flutterTts.setLanguage('vi-VN');
  }

  static void dispose() {
    flutterTts.stop();
  }
}
