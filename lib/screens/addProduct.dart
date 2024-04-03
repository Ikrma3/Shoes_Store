import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _imageDataUrl;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    final imageDataUrl = 'data:image/png;base64,${base64Encode(bytes)}';
    setState(() {
      _imageDataUrl = imageDataUrl;
    });
  }
}

  Future<void> _addProduct() async {
    try {
      final String name = _nameController.text.trim();
      final String price = _priceController.text.trim();
      final String description = _descriptionController.text.trim();

      if (name.isEmpty || price.isEmpty || description.isEmpty || _imageDataUrl == null) {
        // Validate input fields
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please fill all fields and select an image.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
 final response = await http.post(
      Uri.parse('http://127.0.0.1:4000/admin/addProduct'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'imageUrl': _imageDataUrl,
      }),
    );

  } catch (error) {
    print('Error adding product: $error');
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            _imageDataUrl != null
                ? Image.memory(
                    _decodeImageDataUrl(_imageDataUrl!),
                    height: 200,
                    width: 200,
                  )
                : ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List _decodeImageDataUrl(String dataUrl) {
    final base64String = dataUrl.substring(dataUrl.indexOf(',') + 1);
    return base64Decode(base64String);
  }
}
