import 'package:flutter/material.dart';
import 'package:shop_app/screens/homeScreen.dart';
import 'package:shop_app/screens/loginScreen.dart';// Import your home screen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Set your home screen as the initial screen
    );
  }
}
