import 'package:flutter/material.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/beranda.dart';
import 'package:wellpage/pet/penjualan.dart';
import 'package:wellpage/pet/profile.dart'; // Ensure this is correct
import 'package:wellpage/pet/layanantrue.dart'; // Ensure this is correct
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
      home: Layanan1(), // Change this to use Profile
    );
  }
}