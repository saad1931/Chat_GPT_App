// ignore_for_file: file_names

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgptapp/api_services.dart';
import 'package:chatgptapp/chat_model.dart';
import 'package:chatgptapp/ts.dart';
import 'package:flutter/material.dart';
import 'package:chatgptapp/colors.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final List<ChatMessage> messages = [];
  SpeechToText speechToText = SpeechToText();
  var text = "Hold the button and start speaking!";
  var isListening = false;
  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          endRadius: 75.0,
          animate: isListening,
          duration: const Duration(milliseconds: 2000),
          glowColor: bgColor,
          repeat: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (details) async {
              if (!isListening) {
                var availaible = await speechToText.initialize();
                if (availaible) {
                  setState(() {
                    isListening = true;
                    speechToText.listen(onResult: (result) {
                      setState(() {
                        text = result.recognizedWords;
                      });
                    });
                  });
                }
              }
            },
            onTapUp: (details) async {
              setState(() {
                isListening = false;
              });
              await speechToText.stop();
              if (text.isNotEmpty &&
                  text != "Hold the button and start speaking!") {
                messages
                    .add(ChatMessage(text: text, type: ChatMessageType.user));
                var msg = await ApiServices.sendMessage(text);
                msg = msg.trim();
                setState(() {
                  messages
                      .add(ChatMessage(text: msg, type: ChatMessageType.bot));
                });

                Future.delayed(const Duration(milliseconds: 500), () {
                  TextToSpeech.speak(msg);
                });
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Failed to process.Try again!")));
              }
            },
            child: CircleAvatar(
              backgroundColor: bgColor,
              radius: 35,
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          leading: const Icon(
            Icons.sort_rounded,
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0.0,
          title: const Text(
            "Voice Assistant",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 18,
                    color: isListening ? Colors.black87 : Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: chatBgColor,
                    borderRadius: BorderRadius.circular(12)),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    return chatBubble(chattext: chat.text, type: chat.type);
                  },
                ),
              )),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Developed my smart coder",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  Widget chatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot
              ? const Icon(
                  Icons.android,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: type == ChatMessageType.bot ? bgColor : Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: Text(
              "$chattext",
              style: TextStyle(
                  color: type == ChatMessageType.bot ? textColor : chatBgColor,
                  fontSize: 15,
                  fontWeight: type == ChatMessageType.bot
                      ? FontWeight.w400
                      : FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
