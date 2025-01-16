import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';

class Login_UI extends StatefulWidget {
  const Login_UI({super.key});

  @override
  State<Login_UI> createState() => _Login_UIState();
}

class _Login_UIState extends State<Login_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("Login").regular,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
