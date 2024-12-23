// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'dart:io';

// class PageCnnModel extends StatefulWidget {
//   const PageCnnModel({super.key});

//   @override
//   State<PageCnnModel> createState() => _PageCnnModelState();
// }

// class _PageCnnModelState extends State<PageCnnModel> {
//   Interpreter? _interpreter;
//   String _result = "No result yet.";
//   Uint8List? _imageBytes;
//   final ImagePicker _picker = ImagePicker();
//   List<String> _labels = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//     _loadLabels();
//   }

//   /// Load the TFLite model
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset("ann_model.tflite");
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Failed to load model: $e');
//       setState(() {
//         _result = "Failed to load model.";
//       });
//     }
//   }

//   /// Load labels from the labels.txt file
//   Future<void> _loadLabels() async {
//     try {
//       final labelsData =
//           await DefaultAssetBundle.of(context).loadString('labels.txt');
//       setState(() {
//         _labels =
//             labelsData.split('\n').where((label) => label.isNotEmpty).toList();
//       });
//       print('Labels loaded successfully');
//     } catch (e) {
//       print('Failed to load labels: $e');
//       setState(() {
//         _result = "Failed to load labels.";
//       });
//     }
//   }

//   /// Pick an image using the Image Picker
//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         final bytes = await pickedFile.readAsBytes();
//         setState(() {
//           _imageBytes = bytes;
//         });
//         await _runInference(bytes);
//       } else {
//         setState(() {
//           _result = "No image selected.";
//         });
//       }
//     } catch (e) {
//       print('Image selection error: $e');
//       setState(() {
//         _result = "Error selecting image.";
//       });
//     }
//   }

//   /// Preprocess the image for the model
//   List<List<List<double>>> _preprocessImage(Uint8List imageBytes) {
//     final image = img.decodeImage(imageBytes);
//     if (image == null) {
//       throw Exception("Invalid image file.");
//     }

//     final resizedImage = img.copyResize(image, width: 224, height: 224);

//     return List.generate(
//       224,
//       (y) => List.generate(
//         224,
//         (x) {
//           final pixel = resizedImage.getPixel(x, y);
//           final luminance = img.getLuminance(pixel) / 255.0;
//           return [luminance];
//         },
//       ),
//     );
//   }

//   /// Run inference on the image
//   Future<void> _runInference(Uint8List imageBytes) async {
//     if (_interpreter == null) {
//       setState(() {
//         _result = "Model is not loaded.";
//       });
//       return;
//     }

//     try {
//       final input = _preprocessImage(imageBytes);
//       final output =
//           List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

//       _interpreter!.run(input, output);

//       // Get the highest confidence label
//       final resultIndex = output[0].indexWhere(
//           (value) => value == output[0].reduce((a, b) => a > b ? a : b));
//       final confidence = output[0][resultIndex];

//       setState(() {
//         _result =
//             "Result: ${_labels[resultIndex]} with confidence: ${(confidence * 100).toStringAsFixed(2)}%";
//       });
//     } catch (e) {
//       print('Failed to run inference: $e');
//       setState(() {
//         _result = "Inference failed.";
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Model CNN Page"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _imageBytes != null
//                 ? Image.memory(_imageBytes!)
//                 : const Text("No image selected."),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text("Pick Image"),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _result,
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
