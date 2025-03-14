import 'package:flutter/material.dart';

// Replace this with your actual sign up screen widget
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: const Center(child: Text('Sign Up Screen')),
    );
  }
}

// Replace this with your actual login screen widget
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen')),
    );
  }
}

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WelcomeButton(
          buttontext: "Sign Up",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          color: Colors.orange,
          textColor: Colors.white, // Assuming you want to set a text color
        ),
        const SizedBox(height: 10), // Space between buttons
        WelcomeButton(
          buttontext: "Login",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          color: Colors.white,
          textColor: Colors.black, // Assuming you want to set a text color
        ),
        const SizedBox(height: 20), // Space below buttons
        const Text(
          'Forgot your password?',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttontext,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  final String buttontext;
  final VoidCallback onTap; // Change to VoidCallback
  final Color color;
  final Color textColor; // Add textColor parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the function directly
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          buttontext,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: textColor, // Use the textColor parameter
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}