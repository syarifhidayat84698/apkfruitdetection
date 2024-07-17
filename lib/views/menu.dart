import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Fruit Image'),
        ),
        body: Center(
          child: Image.asset(
            'images/fruits.png', // Replace with your image path
          ),
        ),
      ),
    );
  }
}
