// ignore: file_names
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  _VoiceAssistantPageState createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final String _apikey = 'AIzaSyBh594D5yyxZhkqJzKMDO0umyaJtjlajzQ';

  // Controllers for TextFields
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();

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
      _queryController.text =
          _lastWords; // Update the query field with recognized words
    });
  }

  /// Send the query to the Gemini API using google_generative_ai package
  Future<void> _sendQueryToAssistant(String query) async {
    try {
      // Initialize the generative model
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apikey);
      
      final prompt = [Content.text(query)];
      // Generate text using the input query
      final response = await model.generateContent(prompt);

      // Display the response
      setState(() {
        _responseController.text = response.text ?? "No response received.";
      });
    } catch (e) {
      setState(() {
        _responseController.text = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant - Gemini'),
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
            // Query TextField
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                hintText: 'Your query will appear here...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendQueryToAssistant(_queryController.text);
              },
              child: const Text('Send Query'),
            ),
            const SizedBox(height: 20),
            // Response TextField
            TextField(
              controller: _responseController,
              readOnly: true,
              decoration: const InputDecoration(
                  hintText: 'Assistant\'s response will appear here...',
                  border: OutlineInputBorder()),
            ),
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
