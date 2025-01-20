import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

class Checkout_UI extends StatefulWidget {
  const Checkout_UI({super.key});

  @override
  State<Checkout_UI> createState() => _Checkout_UIState();
}

class _Checkout_UIState extends State<Checkout_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label('Checkout').regular,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
