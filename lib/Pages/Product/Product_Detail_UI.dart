import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Product_Detail_UI extends ConsumerStatefulWidget {
  final String id;
  const Product_Detail_UI({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<Product_Detail_UI> createState() => _Product_Detail_UIState();
}

class _Product_Detail_UIState extends ConsumerState<Product_Detail_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label(widget.id).regular,
      ),
      body: SafeArea(
        child: SingleChildScrollView(),
      ),
    );
  }
}
