import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VoiceAssistantPageState createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final String _keyapi = "AIzaSyBh594D5yyxZhkqJzKMDO0umyaJtjlajzQ";
  
  // Controller for the TextField to update in real-time
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Initialize the speech recognition service
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Start listening for speech input
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stop listening for speech input
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// Handle speech recognition results
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords; // Update the TextField with recognized words
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voice Assistant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Type your query or use voice input:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // TextField with controller to show the speech results in real-time
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Your query will appear here...',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        backgroundColor: _speechToText.isListening ? Colors.red : Colors.blue,
        child: Icon(
          _speechToText.isListening ? Icons.stop : Icons.mic,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
