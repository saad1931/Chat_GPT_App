import 'package:chatgptapp/SpeechScreen.dart';
import 'package:chatgptapp/ts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//make sure to change api-key,i have removed.
//update in api-services.dart file 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  SpeechScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
