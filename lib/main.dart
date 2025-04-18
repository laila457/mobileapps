import 'package:flutter/material.dart';
import 'package:wellpage/controllers/register.dart';
import 'package:wellpage/pet/dasboard.dart';
import 'package:wellpage/pet/layanantrue.dart';
import 'package:wellpage/pet/rating.dart';
import 'package:wellpage/screen/signin.dart';
import 'package:wellpage/beranda.dart';
import 'package:wellpage/pet/penjualan.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/controllers/login_screen.dart'; // Ensure this import is correct
import 'package:wellpage/pet/formbooking.dart'; // Ensure this import is correct
import 'package:firebase_core/firebase_core.dart';
import 'package:wellpage/screen/welcome.dart ';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/pet/formbooking.dart';

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
      home: Dash()//en is called correctly
    );
  }
}