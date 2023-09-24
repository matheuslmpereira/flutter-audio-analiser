import 'package:adjustable_tuner/presenter/screen/tuner_screen.dart';
import 'package:flutter/material.dart';

import 'core/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experience Tuner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch
        ).copyWith(
            secondary: secondarySwatch[500],
            background: secondarySwatch[800]
        ),
        canvasColor: secondarySwatch[800],
        scaffoldBackgroundColor: secondarySwatch[800],
      ),
      home: const TunerScreenWidget(),
    );
  }
}
