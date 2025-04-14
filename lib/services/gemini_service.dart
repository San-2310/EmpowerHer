import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );
  }

  Future<String> generateContent(String input) async {
    final prompt = "$input";

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "❌ Gemini didn't reply properly.";
  }
}
