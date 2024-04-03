import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  ResponsiveScreen({required this.mobileLayout, required this.desktopLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          // Use mobile layout if screen width is less than 600 pixels
          return mobileLayout;
        } else {
          // Use desktop layout if screen width is 600 pixels or more
          return desktopLayout;
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Responsive Screen Example'),
      ),
      body: ResponsiveScreen(
        mobileLayout: MobileLayout(),
        desktopLayout: DesktopLayout(),
      ),
    ),
  ));
}

class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Text(
          'Mobile Layout',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        color: Colors.green,
        child: Text(
          'Desktop Layout',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
