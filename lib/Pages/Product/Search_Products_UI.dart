import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/KSearchbar.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

class Search_Products_UI extends StatefulWidget {
  const Search_Products_UI({super.key});

  @override
  State<Search_Products_UI> createState() => _Search_Products_UIState();
}

class _Search_Products_UIState extends State<Search_Products_UI> {
  final searchKey = TextEditingController();

  @override
  void dispose() {
    searchKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KSearchbar(
                controller: searchKey,
                hintText: "Search all products",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
