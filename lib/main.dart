import 'package:api_ogren/screens/api_screen.dart';
import 'package:api_ogren/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'api_ogren',
      debugShowCheckedModeBanner: false,
      home: ApiScreen(),
    );
  }
}
