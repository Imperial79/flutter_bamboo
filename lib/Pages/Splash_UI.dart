import 'package:flutter/material.dart';

class Splash_UI extends StatefulWidget {
  const Splash_UI({super.key});

  @override
  State<Splash_UI> createState() => _Splash_UIState();
}

class _Splash_UIState extends State<Splash_UI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
