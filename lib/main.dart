import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "reddit",
      debugShowCheckedModeBanner: false,
      theme: Pallete.darkModeAppTheme,
      home: const Scaffold(),
    );
  }
}
