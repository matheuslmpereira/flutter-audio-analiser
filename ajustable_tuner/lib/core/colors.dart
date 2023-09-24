import 'package:flutter/material.dart';

MaterialColor colorToMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: Color.fromRGBO(color.red, color.green, color.blue, .1),
    100: Color.fromRGBO(color.red, color.green, color.blue, .2),
    200: Color.fromRGBO(color.red, color.green, color.blue, .3),
    300: Color.fromRGBO(color.red, color.green, color.blue, .4),
    400: Color.fromRGBO(color.red, color.green, color.blue, .5),
    500: Color.fromRGBO(color.red, color.green, color.blue, .6),
    600: Color.fromRGBO(color.red, color.green, color.blue, .7),
    700: Color.fromRGBO(color.red, color.green, color.blue, .8),
    800: Color.fromRGBO(color.red, color.green, color.blue, .9),
    900: Color.fromRGBO(color.red, color.green, color.blue, 1),
  });
}

// General Palette
final primarySwatch = colorToMaterialColor(const Color(0xFF323232));
final secondarySwatch = colorToMaterialColor(const Color(0xFF323232));

// Auditory Feedback
const componentBackground = Color(0xFF464850);
const comfortAudioColor =  Color(0xFF2E7D32);
const heavyNoiseColor = Color(0xFFFF6B6B);
const successGreen = Color(0xFF0cce19);

// Neon Colors for Notes
const neonC = Color(0xFF8BC34A);
const neonCSharp = Color(0xFF00BCD4);
const neonD = Color(0xFF2196F3);
const neonDSharp = Color(0xFF5570FF);
const neonE = Color(0xFF853DFF);
const neonF = Color(0xFFE830F6);
const neonFSharp = Color(0xFFf44336);
const neonG = Color(0xFFFF5722);
const neonGSharp = Color(0xFFFF9800);
const neonA = Color(0xFFFFC107);
const neonASharp = Color(0xFFFFEB3B);
const neonB = Color(0xFFCDDC39);
