import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillingAddressScreen extends StatefulWidget {
  final String userId;

  BillingAddressScreen({required this.userId});

  @override
  _BillingAddressScreenState createState() => _BillingAddressScreenState();
}

class _BillingAddressScreenState extends State<BillingAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> submitOrder() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String address = _addressController.text;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:4000/completeorder'),
      body: jsonEncode({
        'userId': widget.userId,
        'name': name,
        'email': email,
        'address': address,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Order submitted successfully, navigate back to home screen
      Navigator.of(context).pop();
      print('Order submitted successfully');
    } else {
      // Failed to submit order, show error message
      print('Failed to submit order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Address'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                submitOrder();
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
