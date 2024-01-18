import 'package:amptive/screens/splash.dart';
import 'package:amptive/screens/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AmptiveApp());
}

class AmptiveApp extends StatelessWidget {
  const AmptiveApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}


