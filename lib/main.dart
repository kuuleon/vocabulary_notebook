import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "my own frashcard",
      theme: ThemeData(brightness: Brightness.dark, fontFamily: "Lanobe"),
      home: HomeScreen(),
    );
  }
}
