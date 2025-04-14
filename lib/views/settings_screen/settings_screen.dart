// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // import '../../controllers/translation_controller.dart';

// // class SettingsScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final translator = Provider.of<TranslationController>(context);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Language Settings"),
// //       ),
// //       body: ListView(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Text(
// //               "Content Translation Language",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //             ),
// //           ),
// //           // Current language (Content translation language)
// //           ...translator.supportedLanguages
// //               .map(
// //                 (language) => ListTile(
// //                   title: Text(language['name'] ?? ''),
// //                   subtitle: Text("Translate content to this language"),
// //                   trailing: Radio(
// //                     value: language['code'],
// //                     groupValue: translator.currentLanguage,
// //                     onChanged: (value) async {
// //                       if (value != null) {
// //                         await translator.changeLanguage(value.toString());
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               )
// //               .toList(),

// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Text(
// //               "Note: The app will translate content between your selected languages.",
// //               style: TextStyle(
// //                   fontStyle: FontStyle.italic, color: Colors.grey[600]),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/translation_controller.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final translator = Provider.of<TranslationController>(context);

//     FutureBuilder<String> buildTranslatedText(String text) {
//       return FutureBuilder<String>(
//         future: translator.translate(text),
//         builder: (context, snapshot) {
//           return Text(
//             snapshot.data ?? text,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           );
//         },
//       );
//     }

//     FutureBuilder<String> buildSubtitle(String text) {
//       return FutureBuilder<String>(
//         future: translator.translate(text),
//         builder: (context, snapshot) {
//           return Text(
//             snapshot.data ?? text,
//             style:
//                 TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
//           );
//         },
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<String>(
//           future: translator.translate("Language Settings"),
//           builder: (context, snapshot) {
//             return Text(
//               snapshot.data ?? "Language Settings",
//             );
//           },
//         ),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: buildTranslatedText("Content Translation Language"),
//           ),
//           ...translator.supportedLanguages
//               .map(
//                 (language) => ListTile(
//                   title: FutureBuilder<String>(
//                     future: translator.translate(language['name'] ?? ''),
//                     builder: (context, snapshot) {
//                       return Text(snapshot.data ?? language['name'] ?? '');
//                     },
//                   ),
//                   subtitle: buildSubtitle("Translate content to this language"),
//                   trailing: Radio(
//                     value: language['code'],
//                     groupValue: translator.currentLanguage,
//                     onChanged: (value) async {
//                       if (value != null) {
//                         await translator.changeLanguage(value.toString());
//                       }
//                     },
//                   ),
//                 ),
//               )
//               .toList(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: buildSubtitle(
//               "Note: The app will translate content between your selected languages.",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/translation_controller.dart';
// import '../../controllers/tts_controller.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final translator = Provider.of<TranslationController>(context);
//     final ttsController = Provider.of<TTSController>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Language Settings"),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: FutureBuilder<String>(
//               future: translator.translate("Content Translation Language"),
//               builder: (context, snapshot) {
//                 return Text(
//                   snapshot.data ?? "Content Translation Language",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 );
//               },
//             ),
//           ),
//           ...translator.supportedLanguages
//               .map(
//                 (language) => ListTile(
//                   title: FutureBuilder<String>(
//                     future: translator.translate(language['name'] ?? ''),
//                     builder: (context, snapshot) {
//                       return Text(snapshot.data ?? language['name']!);
//                     },
//                   ),
//                   subtitle: FutureBuilder<String>(
//                     future: translator
//                         .translate("Translate content to this language"),
//                     builder: (context, snapshot) {
//                       return Text(snapshot.data ??
//                           "Translate content to this language");
//                     },
//                   ),
//                   trailing: Radio(
//                     value: language['code'],
//                     groupValue: translator.currentLanguage,
//                     onChanged: (value) async {
//                       if (value != null) {
//                         await translator.changeLanguage(value.toString());
//                       }
//                     },
//                   ),
//                 ),
//               )
//               .toList(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: FutureBuilder<String>(
//               future: translator.translate(
//                   "Note: The app will translate content between your selected languages."),
//               builder: (context, snapshot) {
//                 return Text(
//                   snapshot.data ??
//                       "Note: The app will translate content between your selected languages.",
//                   style: TextStyle(
//                       fontStyle: FontStyle.italic, color: Colors.grey[600]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           final allTexts = [
//             "Content Translation Language",
//             ...translator.supportedLanguages.map((e) => e['name'] ?? ""),
//             "Note: The app will translate content between your selected languages."
//           ].join(", "); // Combine texts

//           ttsController.speak(allTexts, context); // Pass context to TTS
//         },
//         child: Icon(ttsController.isSpeaking ? Icons.stop : Icons.volume_up),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/translation_controller.dart';
import '../../controllers/tts_controller.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translator = Provider.of<TranslationController>(context);
    final ttsController = Provider.of<TTSController>(context);

    Future<void> handleTTSAction() async {
      final allTexts = [
        "Content Translation Language",
        ...translator.supportedLanguages.map((e) => e['name'] ?? ""),
        "Note: The app will translate content between your selected languages."
      ].join(", ");

      await ttsController.speak(allTexts, context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Language Settings"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<String>(
              future: translator.translate("Content Translation Language"),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? "Content Translation Language",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                );
              },
            ),
          ),
          ...translator.supportedLanguages
              .map(
                (language) => ListTile(
                  title: FutureBuilder<String>(
                    future: translator.translate(language['name'] ?? ''),
                    builder: (context, snapshot) {
                      return Text(snapshot.data ?? language['name']!);
                    },
                  ),
                  trailing: Radio(
                    value: language['code'],
                    groupValue: translator.currentLanguage,
                    onChanged: (value) async {
                      if (value != null) {
                        await translator.changeLanguage(value.toString());
                      }
                    },
                  ),
                ),
              )
              .toList(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<String>(
              future: translator.translate(
                  "Note: The app will translate content between your selected languages."),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ??
                      "Note: The app will translate content between your selected languages.",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey[600]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              ttsController.isPlaying
                  ? ttsController.stop()
                  : handleTTSAction();
            },
            backgroundColor: Colors.blue,
            child: Icon(ttsController.isPlaying && !ttsController.isPaused
                ? Icons.pause
                : Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
