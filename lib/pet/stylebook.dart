import 'package:flutter/material.dart';

Color gradient1 = const Color.fromARGB(255, 217, 72, 247);
Color gradient2 = const Color.fromARGB(255, 163, 1, 165);
Color background = const Color.fromARGB(255, 255, 0, 230);

class Styless {
  Styless._();

  static Color gradient1Color = gradient1;
  static Color gradient2Color = gradient2;
  static Color backgroundColor = background;
  static Color buttonColor = const Color(0xFF8371D0);
  static Color appBarColor = const Color.fromARGB(255, 255, 126, 242);
  static Color highlightColor = const Color(0xFF6F5EB4);
  static Color yellowColor = const Color(0xFFFFDB65);

  static imagePath(name) => 'assets/images/$name';
}