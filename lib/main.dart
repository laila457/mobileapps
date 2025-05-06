import 'package:flutter/material.dart';
import 'package:wellpage/controllers/register.dart';
import 'package:wellpage/pet/dasboard.dart';
import 'package:wellpage/pet/layanantrue.dart';
import 'package:wellpage/pet/bookpenitipan.dart';
import 'package:wellpage/screen/signin.dart';
import 'package:wellpage/pet/penjualan.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/controllers/login_screen.dart';
import 'package:wellpage/pet/formbooking.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/screens/hotel_form.dart';
import 'package:wellpage/screens/grooming_form.dart';
import 'package:wellpage/screens/hotel_form.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        fontFamily: 'Roboto',  // Using a safe default font
      ),
      home: const WelcomeScreen(),
    );
  }
}