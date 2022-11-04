import 'package:flutter/material.dart';
import 'package:vocabulary_notebook/db/database.dart';
import 'screens/home_screen.dart';

late MyDatabase database;
void main() {
  database = MyDatabase();
  runApp(MyApp());
}

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
