// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'translation_controller.dart';

// class TTSController extends ChangeNotifier {
//   final FlutterTts _flutterTts = FlutterTts();
//   bool isSpeaking = false;
//   String currentLanguage = "en"; // Default to English

//   TTSController() {
//     _flutterTts.setCompletionHandler(() {
//       isSpeaking = false;
//       notifyListeners();
//     });

//     _flutterTts.setErrorHandler((message) {
//       isSpeaking = false;
//       notifyListeners();
//     });
//   }

//   // Dynamically set language before speaking
//   Future<void> speak(String text, BuildContext context) async {
//     final translator =
//         Provider.of<TranslationController>(context, listen: false);
//     currentLanguage = translator.currentLanguage; // Get current language

//     // FlutterTTS only supports specific language codes
//     await _flutterTts.setLanguage(_mapLanguageCode(currentLanguage));
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setPitch(1.0);

//     isSpeaking = true;
//     notifyListeners();

//     await _flutterTts.speak(text);
//   }

//   Future<void> stop() async {
//     await _flutterTts.stop();
//     isSpeaking = false;
//     notifyListeners();
//   }

//   // Map app language codes to TTS-supported codes
//   String _mapLanguageCode(String code) {
//     switch (code) {
//       case "hi":
//         return "hi-IN"; // Hindi (India)
//       case "mr":
//         return "mr-IN"; // Marathi (India)
//       case "gu":
//         return "gu-IN"; // Gujarati (India)
//       case "te":
//         return "te-IN"; // Telugu (India)
//       case "ta":
//         return "ta-IN"; // Tamil (India)
//       case "bn":
//         return "bn-IN"; // Bengali (India)
//       case "en":
//       default:
//         return "en-US"; // Default to English
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'translation_controller.dart';

class TTSController extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;
  String currentLanguage = "en"; // Default language

  int _currentIndex = 0;
  String _currentText = "";
  String _remainingText = "";

  TTSController() {
    _flutterTts.setCompletionHandler(() {
      isPlaying = false;
      isPaused = false;
      _currentIndex = 0;
      notifyListeners();
    });

    _flutterTts.setStartHandler(() {
      isPlaying = true;
      isPaused = false;
      notifyListeners();
    });

    _flutterTts.setErrorHandler((message) {
      isPlaying = false;
      isPaused = false;
      notifyListeners();
    });
  }

  // Dynamically set language and speak
  Future<void> speak(String text, BuildContext context) async {
    final translator =
        Provider.of<TranslationController>(context, listen: false);
    currentLanguage = translator.currentLanguage;

    await _flutterTts.setLanguage(_mapLanguageCode(currentLanguage));
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);

    // Translate before speaking
    String translatedText = await translator.translate(text);

    _currentText = translatedText;
    _remainingText = translatedText;
    _currentIndex = 0;

    isPlaying = true;
    isPaused = false;
    notifyListeners();

    await _flutterTts.speak(translatedText);
  }

  Future<void> pause() async {
    if (isPlaying && !isPaused) {
      await _flutterTts.stop();
      isPaused = true;
      _remainingText = _currentText.substring(_currentIndex);
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (isPaused) {
      isPaused = false;
      isPlaying = true;
      notifyListeners();
      await _flutterTts.speak(_remainingText);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    isPlaying = false;
    isPaused = false;
    _currentIndex = 0;
    notifyListeners();
  }

  Future<void> restart(String text, BuildContext context) async {
    await stop();
    await speak(text, context);
  }

  // Map app language codes to TTS-supported codes
  String _mapLanguageCode(String code) {
    switch (code) {
      case "hi":
        return "hi-IN";
      case "mr":
        return "mr-IN";
      case "gu":
        return "gu-IN";
      case "te":
        return "te-IN";
      case "ta":
        return "ta-IN";
      case "bn":
        return "bn-IN";
      case "en":
      default:
        return "en-US";
    }
  }
}
