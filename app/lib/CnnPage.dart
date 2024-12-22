// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// class PageCnnModel extends StatefulWidget {
//   const PageCnnModel({super.key});

//   @override
//   State<PageCnnModel> createState() => _PageCnnModelState();
// }

// class _PageCnnModelState extends State<PageCnnModel> {
//   late Interpreter _interpreter;
//   String _result = "No result yet.";
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   /// Load the TFLite model
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset("cnn_model.tflite");
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Failed to load model: $e');
//       setState(() {
//         _result = "Failed to load model.";
//       });
//     }
//   }

//   /// Pick an image using the Image Picker
//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//         await _runInference();
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
//   List<List<List<double>>> _preprocessImage(File imageFile) {
//     final image = img.decodeImage(imageFile.readAsBytesSync());
//     if (image == null) {
//       throw Exception("Invalid image file.");
//     }

//     // Resize the image to the model's expected size (e.g., 224x224)
//     final resizedImage = img.copyResize(image, width: 224, height: 224);

//     // Convert image to a 3D list (height x width x channels) and normalize pixel values
//     final input = List.generate(
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

//     return input;
//   }

//   /// Run inference on the image
//   Future<void> _runInference() async {
//     if (_imageFile == null) return;

//     try {
//       final input = _preprocessImage(_imageFile!);

//       // Prepare the output tensor
//       final output = List.filled(1 * 10, 0.0)
//           .reshape([1, 10]); // Adjust to your model's output shape

//       _interpreter.run([input], output);

//       setState(() {
//         _result = "Inference result: ${output[0].toString()}";
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
//     _interpreter.close();
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
//             _imageFile != null
//                 ? Image.file(_imageFile!)
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
