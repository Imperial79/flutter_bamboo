import 'package:flutter/material.dart';

import '../Components/Label.dart';

class Splash_UI extends StatefulWidget {
  const Splash_UI({super.key});

  @override
  State<Splash_UI> createState() => _Splash_UIState();
}

class _Splash_UIState extends State<Splash_UI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label("Login").regular,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
