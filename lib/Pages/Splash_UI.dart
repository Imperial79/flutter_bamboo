import 'package:flutter/material.dart';
import 'package:ngf_organic/Resources/constants.dart';

class Splash_UI extends StatefulWidget {
  const Splash_UI({super.key});

  @override
  State<Splash_UI> createState() => _Splash_UIState();
}

class _Splash_UIState extends State<Splash_UI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "$kImagePath/logo.png",
              height: 200,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
