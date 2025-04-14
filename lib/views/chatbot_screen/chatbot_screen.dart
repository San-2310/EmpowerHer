import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _thoughtsController = TextEditingController();
  bool _isLoading = false;
  Artboard? riveArtboard;

  @override
  void initState() {
    super.initState();
    loadRive();
  }

  void loadRive() async {
    final data = await RiveFile.asset('assets/RiveAssets/lady.riv');
    final artboard = data.artboardByName('artboard') ?? data.mainArtboard;
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine');
    if (controller != null) {
      artboard.addController(controller);
    }
    setState(() => riveArtboard = artboard);
  }

  Future<void> _submitThoughts() async {
    if (_thoughtsController.text.isEmpty) return;
    setState(() => _isLoading = true);
    // Here, you can send the thought to your Flask API or wherever needed
    await Future.delayed(Duration(seconds: 1)); // Placeholder for actual logic
    setState(() => _isLoading = false);
    _thoughtsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChatBot')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 220),
            Container(
              height: 300,
              width: double.infinity,
              alignment: Alignment.center,
              child: riveArtboard != null
                  ? SizedBox(
                      height: 290,
                      width: 250,
                      child: OverflowBox(
                        maxHeight: 290,
                        child: Transform.scale(
                            scale: 1.5, child: Rive(artboard: riveArtboard!)),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 10),

            // Preset Questions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _presetQuestionButton("Q1"),
                  _presetQuestionButton("Q2"),
                  _presetQuestionButton("Q3"),
                  _presetQuestionButton("Q4"),
                ],
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _thoughtsController,
                decoration: InputDecoration(
                  hintText: 'Type your thoughts...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isLoading ? null : _submitThoughts,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _presetQuestionButton(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        setState(() {
          _thoughtsController.text = label;
        });
      },
      child: Text(label),
    );
  }
}
