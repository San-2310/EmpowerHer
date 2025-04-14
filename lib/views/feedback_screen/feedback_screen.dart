// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../services/gemini_service.dart';

// class FeedbackScreen extends StatefulWidget {
//   const FeedbackScreen({super.key});

//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   String transcriptionText = "No transcription yet.";
//   String geminiResponse = "";

//   Future<void> fetchTranscriptionAndSendToGemini() async {
//     final url = Uri.parse(
//         'https://2616-2409-40c0-1007-715d-b0eb-788-4180-80c.ngrok-free.app/get-transcription');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final transcription =
//             data['transcription'] ?? "No transcription available.";

//         setState(() {
//           transcriptionText = transcription;
//         });

//         final gemini =
//             GeminiService(apiKey: 'AIzaSyAwzGYKvRmQNgEnmBypuq8l70-zoeaHoEc');
//         // final geminiReply = await gemini.generateContent("tell me a joke");
//         final geminiReply = await gemini.generateContent(
//             """You are an AI assistant designed to analyze call feedbacks from underprivileged women using our voice-based learning and employment platform called "EmpowerHer".

// The user receives periodic phone calls to check in on their learning progress, emotional state, difficulties, and future goals. These calls are transcribed using Twilio's voice transcription engine. However, due to pronunciation, noise, and regional language interference, the transcript might contain inaccuracies, broken grammar, or partially recognized phrases. Please keep this in mind while analyzing.

// Here is the transcription of the user’s voice call:
// ---
// $transcription
// ---

// Your job is to:
// 1. Understand the core intent** of the speaker, even if words are misspelled or partially incorrect.
// 2. Identify what the user is trying to express** — whether it’s a concern, a success update, a learning roadblock, or a need for support.
// 3. Emotionally contextualize** the tone (are they stressed, confused, confident, doubtful, motivated?).
// 4. Based on this, suggest **3 personalized next-step actions** that the platform can take to help this user. These actions can be related to:
//    - Recommending the next course
//    - Assigning a mentor
//    - Scheduling a motivational call
//    - Reassuring the user
//    - Suggesting financial goals
//    - Helping with emotional support
//    - Reporting tech issues, etc.

// Please format your response as:

// 🧠 Interpretation (summary of what the user said in natural language)
// ❤️ Emotional Tone
// 📋 Recommended Actions (3)

// Important Notes:
// - Be kind, sensitive, and motivating in your suggestions.
// - Assume this user may not be tech-savvy or fluent in English.
// - Your understanding should be human-first, not literal-text-first.

// Begin your analysis based on the transcript.""");
//         print(geminiReply);
//         setState(() {
//           geminiResponse = geminiReply;
//         });
//       } else {
//         setState(() {
//           transcriptionText = "Failed to fetch transcription.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         transcriptionText = "Error fetching transcription: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Feedback Screen'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   const phoneNumber = '+918169617362';
//                   const serverUrl =
//                       'https://2616-2409-40c0-1007-715d-b0eb-788-4180-80c.ngrok-free.app/make-call';

//                   try {
//                     final response = await http.post(
//                       Uri.parse(serverUrl),
//                       headers: {'Content-Type': 'application/json'},
//                       body: jsonEncode({'phone': phoneNumber}),
//                     );

//                     if (response.statusCode == 200) {
//                       print('✅ Call initiated successfully');
//                       print(response.body);
//                     } else {
//                       print(
//                           '❌ Failed to initiate call: ${response.statusCode}');
//                       print(response.body);
//                     }
//                   } catch (e) {
//                     print('❌ Error: $e');
//                   }
//                 },
//                 child: const Text('Make Call'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: fetchTranscriptionAndSendToGemini,
//                 child: const Text("Fetch Transcription & Get Feedback"),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: TextEditingController(text: transcriptionText),
//                 maxLines: null,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "Transcription",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: TextEditingController(text: geminiResponse),
//                 maxLines: null,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "Gemini Feedback",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// A fresh redesigned FeedbackScreen with pastel theme, better layout, modular cards and formatted Gemini response

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/gemini_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String transcriptionText = "No transcription yet.";
  String geminiResponse = "";

  Future<void> fetchTranscriptionAndSendToGemini() async {
    final url = Uri.parse(
        'https://90a7-103-104-226-58.ngrok-free.app/get-transcription');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transcription =
            data['transcription'] ?? "No transcription available.";

        setState(() {
          transcriptionText = transcription;
        });

        final gemini =
            GeminiService(apiKey: 'AIzaSyAwzGYKvRmQNgEnmBypuq8l70-zoeaHoEc');

        final geminiReply = await gemini.generateContent(
            """You are an AI assistant designed to analyze call feedbacks from underprivileged women using our voice-based learning and employment platform called "EmpowerHer".

The user receives periodic phone calls to check in on their learning progress, emotional state, difficulties, and future goals. These calls are transcribed using Twilio's voice transcription engine. However, due to pronunciation, noise, and regional language interference, the transcript might contain inaccuracies, broken grammar, or partially recognized phrases. Please keep this in mind while analyzing.

Here is the transcription of the user’s voice call:
---
$transcription
---

Your job is to:
1. Understand the core intent** of the speaker, even if words are misspelled or partially incorrect.
2. Identify what the user is trying to express** — whether it’s a concern, a success update, a learning roadblock, or a need for support.
3. Emotionally contextualize** the tone (are they stressed, confused, confident, doubtful, motivated?).
4. Based on this, suggest **3 personalized next-step actions** that the platform can take to help this user. These actions can be related to:
   - Recommending the next course
   - Assigning a mentor
   - Scheduling a motivational call
   - Reassuring the user
   - Suggesting financial goals
   - Helping with emotional support
   - Reporting tech issues, etc.

Return your final answer strictly in the following JSON format:

{
  "interpretation": "Summary of what the user said, in natural language.",
  "tone": "Emotional tone (e.g., hopeful, confused, anxious, confident).",
  "actions": [
    "Personalized next step 1",
    "Personalized next step 2",
    "Personalized next step 3"
  ]
}

Important Notes:
- Be kind, sensitive, and motivating in your suggestions.
- Assume this user may not be tech-savvy or fluent in English.
- Your understanding should be human-first, not literal-text-first.

Begin your analysis based on the transcript.
Return your answer in valid JSON with keys: interpretation, tone, actions.

Example:
{
  "interpretation": "...",
  "tone": "...",
  "actions": ["...", "...", "..."]
}
""");
        setState(() {
          geminiResponse = geminiReply;
        });
      } else {
        setState(() {
          transcriptionText = "Failed to fetch transcription.";
        });
      }
    } catch (e) {
      setState(() {
        transcriptionText = "Error fetching transcription: \$e";
      });
    }
  }

  Widget buildGeminiCard(
      String title, String content, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  Map<String, dynamic> extractJsonFromGemini(String rawResponse) {
    try {
      final cleaned = rawResponse.replaceAll(RegExp(r'```[a-z]*'), '').trim();
      final firstBrace = cleaned.indexOf('{');
      final lastBrace = cleaned.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        final jsonString = cleaned.substring(firstBrace, lastBrace + 1);
        return json.decode(jsonString);
      } else {
        throw FormatException("No JSON braces found.");
      }
    } catch (e) {
      debugPrint("❌ Failed to extract JSON from Gemini: \$e");
      return {};
    }
  }

  Widget buildResponseCard(
      String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 87, 84, 84)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = extractJsonFromGemini(geminiResponse);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDEE2F8),
        title: const Text('EmpowerHer Feedback'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            tooltip: 'Make Call',
            onPressed: () async {
              const phoneNumber = '+918169617362';
              const serverUrl =
                  'https://90a7-103-104-226-58.ngrok-free.app/make-call';
              try {
                final response = await http.post(
                  Uri.parse(serverUrl),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'phone': phoneNumber}),
                );
                if (response.statusCode == 200) {
                  print('✅ Call initiated successfully');
                } else {
                  print('❌ Failed to initiate call: \${response.statusCode}');
                }
              } catch (e) {
                print('❌ Error: \$e');
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC0C5F0),
                  foregroundColor: Colors.black,
                ),
                onPressed: fetchTranscriptionAndSendToGemini,
                child: const Text("📤 Fetch & Analyze Feedback"),
              ),
              const SizedBox(height: 20),
              Text("📝 Transcription",
                  style: Theme.of(context).textTheme.titleMedium),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(transcriptionText),
              ),
              const SizedBox(height: 20),
              if (result.isNotEmpty) ...[
                buildResponseCard("🧠 Interpretation", result["interpretation"],
                    Icons.lightbulb, const Color.fromRGBO(211, 231, 233, 1)),
                buildResponseCard("❤️ Emotional Tone", result["tone"],
                    Icons.favorite, const Color.fromARGB(255, 242, 127, 166)),
                buildResponseCard(
                  "📋 Recommended Actions",
                  (result["actions"] as List<dynamic>).join("\n• "),
                  Icons.task_alt,
                  const Color.fromARGB(255, 100, 230, 143),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
