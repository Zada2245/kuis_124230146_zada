import 'package:flutter/material.dart';
import 'package:belajar/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'belajar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
