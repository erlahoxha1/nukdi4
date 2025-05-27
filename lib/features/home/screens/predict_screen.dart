import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PredictScreen extends StatefulWidget {
  const PredictScreen({Key? key}) : super(key: key);

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  File? _image;
  String _result = '';
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = '';
      });
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _loading = true;
    });

    final uri = Uri.parse('http://localhost:3000/api/predict');
    print('Sending request to $uri');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();
      print('Response status: ${response.statusCode}');

      final respStr = await response.stream.bytesToString();
      print('Response body: $respStr');

      if (response.statusCode == 200) {
        final jsonResp = jsonDecode(respStr);
        setState(() {
          _result = jsonResp['detected'].join(', ');
        });
      } else {
        setState(() {
          _result = 'Failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _result = 'Error: $e';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Part Identification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : _image != null
                    ? Column(
                        children: [
                          Image.file(_image!, height: 200),
                          const SizedBox(height: 10),
                          Text('Result: $_result'),
                        ],
                      )
                    : const Text('No image selected yet.'),
          ],
        ),
      ),
    );
  }
}
