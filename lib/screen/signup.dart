import 'package:flutter/material.dart';
import 'package:wellpage/widgets/custom_scaffold.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('Sign up'),
    );
  }
}
