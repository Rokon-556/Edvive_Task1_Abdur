import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stts;
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isListening = false;
  String textLine = 'Please Press The Button to Speak';
  var _speechToText = stts.SpeechToText();
  GoogleTranslator translator = GoogleTranslator();

  //This Function will translate the text generated from voice to Bangla
  void translate() {
    translator.translate(textLine, to: 'bn').then((value) {
      setState(() {
        textLine = value.toString();
      });
    });
  }


  //This function allows to enable mic for converting the speech to text
  void listen() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
          onStatus: ((status) => print('$status')),
          onError: ((errorNotification) => print('$errorNotification')));
      if (available) {
        setState(() {
          isListening = true;
        });
        _speechToText.listen(onResult: ((result) {
          setState(() {
            textLine = result.recognizedWords;
          });
        }));
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  void initState() {
    _speechToText = stts.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voice Translator',
        ),
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                textLine,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                translate();
              },
              child: const Text('Translate'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        repeat: true,
        endRadius: 80,
        glowColor: Colors.red,
        duration: const Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
