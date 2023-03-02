// ignore_for_file: avoid_print

import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();

  static initTTS() async {
    print(await tts.getLanguages);
    tts.setLanguage("hi_IN");
    tts.setPitch(1.0);
    // tts.setSpeechRate(1.0);
  }

  static speak(String text) async {
    tts.setStartHandler(() {
      print("TTS is started");
    });

    tts.setCompletionHandler(() {
      print("completed");
    });

    tts.setErrorHandler((message) {
      print(message);
    });
    await tts.awaitSpeakCompletion(true);

    tts.speak(text);
  }
}
