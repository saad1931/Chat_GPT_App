import 'package:chatgptapp/ts.dart';
import 'package:flutter/material.dart';

class TtsScreen extends StatelessWidget {
  const TtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text to Speech"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: textController,
          ),
          ElevatedButton(
              onPressed: () {
                TextToSpeech.speak(textController.text);
              },
              child: const Text("Speak"))
        ],
      ),
    );
  }
}
