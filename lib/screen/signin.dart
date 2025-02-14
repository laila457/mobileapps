import 'package:flutter/material.dart';
import 'package:wellpage/widgets/custom_scaffold.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('Sign in'),
    );
  }
}
