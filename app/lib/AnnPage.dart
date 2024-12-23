import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

class AnnModelClassifierPage extends StatefulWidget {
  const AnnModelClassifierPage({super.key});

  @override
  _AnnModelClassifierPageState createState() => _AnnModelClassifierPageState();
}

class _AnnModelClassifierPageState extends State<AnnModelClassifierPage> {
  Interpreter? _interpreter;
  File? _imageFile;
  String? _predictedClass;
  bool _isLoading = false;
  List<String>? _labels;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('lib/assets/ann.tflite');
    } catch (e) {
      print('Error loading model: $e');
      _showErrorDialog('Failed to load ML model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await DefaultAssetBundle.of(context).loadString('lib/assets/labels.txt');
      setState(() {
        _labels = LineSplitter.split(labelData).toList();
      });
    } catch (e) {
      print('Error loading labels: $e');
      _showErrorDialog('Failed to load labels: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true;
      });

      await _runModelInference();
    }
  }

  Future<void> _runModelInference() async {
    if (_interpreter == null || _imageFile == null || _labels == null) return;

    try {
      // Read and decode the image
      img.Image? originalImage = img.decodeImage(_imageFile!.readAsBytesSync());
      if (originalImage == null) throw Exception('Failed to decode image');

      // Resize image to 28x28
      img.Image resizedImage = img.copyResize(originalImage, width: 28, height: 28);

      // Prepare input tensor
      var inputTensor = Float32List(1 * 28 * 28 * 3);
      var index = 0;

      for (var y = 0; y < 28; y++) {
        for (var x = 0; x < 28; x++) {
          final pixel = resizedImage.getPixel(x, y);
          inputTensor[index++] = pixel.r.toDouble() / 255.0; // Normalize R
          inputTensor[index++] = pixel.g.toDouble() / 255.0; // Normalize G
          inputTensor[index++] = pixel.b.toDouble() / 255.0; // Normalize B
        }
      }

      // Reshape input tensor to [1, 28, 28, 3]
      var input = inputTensor.reshape([1, 28, 28, 3]);

      // Prepare output tensor [1, labels.length]
      var outputTensor = List.filled(_labels!.length, 0.0).reshape([1, _labels!.length]);

      // Run inference
      _interpreter!.run(input, outputTensor);

      // Get the index of the highest probability
      final predictions = outputTensor[0] as List<double>; // Explicitly cast to List<double>
      final maxIndex = predictions.indexWhere((prob) => prob == predictions.reduce((a, b) => a > b ? a : b));

      setState(() {
        _predictedClass = _labels![maxIndex];
        _isLoading = false;
      });

      print('Predicted Class: $_predictedClass');
    } catch (e) {
      print('Inference error: $e');
      _showErrorDialog('Failed to run model inference: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANN Model Classifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected'),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),

            _predictedClass != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Predicted Class: $_predictedClass',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
