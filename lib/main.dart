import 'package:flutter/material.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/beranda.dart';
import 'package:wellpage/pet/adopted.dart';
import 'package:wellpage/screen/profile.dart'; // Ensure this is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(), // Change this to use Profile
    );
  }
}