import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationController extends ChangeNotifier {
  String _currentLanguage = "en"; // Default language: English
  String _primaryLanguage = "en"; // Language to show app interface in
  static const _channel = MethodChannel('com.example.empower_her/translate');

  String get currentLanguage => _currentLanguage;
  String get primaryLanguage => _primaryLanguage;

  // List of supported languages
  final List<Map<String, String>> supportedLanguages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Marathi', 'code': 'mr'},
    {'name': 'Gujarati', 'code': 'gu'},
    {'name': 'Telugu', 'code': 'te'},
    {'name': 'Tamil', 'code': 'ta'},
    {'name': 'Bengali', 'code': 'bn'},
  ];

  TranslationController() {
    _loadLanguages(); // Load saved languages on startup
  }

  Future<void> _loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('currentLanguage') ?? "en";
    _primaryLanguage = prefs.getString('primaryLanguage') ?? "en";
    print(
        "Loaded languages - Current: $_currentLanguage, Primary: $_primaryLanguage");
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    _currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLanguage', langCode);
    notifyListeners();
    print("✅ Current Language: $_currentLanguage");
  }

  Future<void> setPrimaryLanguage(String langCode) async {
    _primaryLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryLanguage', langCode);
    notifyListeners();
    print("✅ Primary Language: $_primaryLanguage");
  }

  Future<String> translate(String text, {String? targetLang}) async {
    try {
      // If text is empty, return empty string to avoid unnecessary translations
      if (text.isEmpty) return "";

      String fromLang = _primaryLanguage;
      String toLang = targetLang ?? _currentLanguage;

      // If source and target languages are the same, no need to translate
      if (fromLang == toLang) return text;

      final translatedText = await _channel.invokeMethod(
        'translateText',
        {
          "text": text,
          "fromLang": fromLang,
          "toLang": toLang,
        },
      );
      return translatedText;
    } catch (e) {
      print("Translation error: $e");
      return text; // Fallback to original text if translation fails
    }
  }

  // Translate between any two specified languages
  Future<String> translateBetween(
      String text, String fromLang, String toLang) async {
    try {
      // If text is empty or languages are the same, return original text
      if (text.isEmpty || fromLang == toLang) return text;

      final translatedText = await _channel.invokeMethod(
        'translateText',
        {
          "text": text,
          "fromLang": fromLang,
          "toLang": toLang,
        },
      );
      return translatedText;
    } catch (e) {
      print("Translation error: $e");
      return text; // Fallback to original text if translation fails
    }
  }

  // Get language name from code
  String getLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'name': 'Unknown', 'code': code},
    );
    return language['name'] ?? 'Unknown';
  }
}
