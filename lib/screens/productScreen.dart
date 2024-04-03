import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScreen extends StatefulWidget {
  final String productId;
  final String userId; // Add user ID parameter

  ProductScreen({required this.productId, required this.userId}); // Update constructor
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic>? product;

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:4000/products/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          product = json.decode(response.body);
        });
      } else {
        // Handle errors if product details retrieval fails
        print('Failed to fetch product details: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error fetching product details: $error');
    }
  }

  Future<void> addToCart() async {
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:4000/product/addtocart/${widget.productId}'),
        // Pass user ID to backend
        body: json.encode({
          'userId': widget.userId,
          'productId': widget.productId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Show dialog with success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Added to Cart'),
            content: Text('Total: \$${product!['price']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle errors if adding to cart fails
        print('Failed to add to cart: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error adding to cart: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: product != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product!['imageUrl'] ?? '',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  Text(
                    product!['name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price: \$${product!['price'] ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product!['description'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addToCart,
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
