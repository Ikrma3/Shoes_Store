import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_app/screens/BillingAddressScreen.dart';

class CartScreen extends StatelessWidget {
  final String userId;

  CartScreen({required this.userId});

  Future<List<dynamic>> fetchCartItems() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:4000/cart'),
      body: json.encode({'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['cartItems'];
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Your Cart'),
      ),
      body: FutureBuilder(
        future: fetchCartItems(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> cartItems = snapshot.data ?? [];
            double totalPrice = cartItems.fold(
              0.0,
              (previousValue, element) => previousValue + double.parse(element['price'].toString()),
            );
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Image.network(cartItems[index]['imageUrl']),
                            Text(cartItems[index]['name']),
                            Text(cartItems[index]['price']),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillingAddressScreen(userId: userId),
      ),
                     );          
                    // Add your order button functionality here
                  },
                  child: Text('Order'),
                ),
                SizedBox(height: 16.0),
              ],
            );
          }
        },
      ),
    );
  }
}
