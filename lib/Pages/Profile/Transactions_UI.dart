import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

class Transactions_UI extends StatefulWidget {
  const Transactions_UI({super.key});

  @override
  State<Transactions_UI> createState() => _Transactions_UIState();
}

class _Transactions_UIState extends State<Transactions_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("Transactions").regular,
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
