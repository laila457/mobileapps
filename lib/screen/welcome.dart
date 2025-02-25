import 'package:flutter/material.dart';
import 'package:wellpage/screen/signup.dart';
import 'package:wellpage/screen/signin.dart';
import 'package:wellpage/widgets/custom_scaffold.dart';
import 'package:wellpage/widgets/welcome_button.dart';
import 'package:wellpage/widgets/custom_scaffold.dart' show CustomScaffold;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: ' \n',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.green, // Warna hijau untuk teks
                        ),
                      ),
                      TextSpan(
                        text: '\n ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green, // Warna hijau untuk teks
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttontext: 'Sign in',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signin()),
                        );
                      },
                      color: Colors.white, // Warna putih untuk tombol
                      textColor: Colors.green, // Warna hijau untuk teks tombol
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttontext: 'Sign Up',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      color: Colors.white, // Warna putih untuk tombol
                      textColor: Colors.green, // Warna hijau untuk teks tombol
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}