import 'package:ecommerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.red,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
