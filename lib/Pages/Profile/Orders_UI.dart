import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

class Orders_UI extends StatefulWidget {
  const Orders_UI({super.key});

  @override
  State<Orders_UI> createState() => _Orders_UIState();
}

class _Orders_UIState extends State<Orders_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("Orders").regular,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
        ),
      ),
    );
  }
}
