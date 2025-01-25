// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/KSearchbar.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Repository/product_repo.dart';
import 'Product_Preview_Card.dart';

class Search_Products_UI extends ConsumerStatefulWidget {
  final String category;
  const Search_Products_UI({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<Search_Products_UI> createState() => _Search_Products_UIState();
}

class _Search_Products_UIState extends ConsumerState<Search_Products_UI> {
  final searchKey = TextEditingController();
  int pageNo = 0;

  Future<void> _refresh() async {
    pageNo = 0;
    String apiData = jsonEncode({
      'pageNo': pageNo,
      'searchKey': searchKey.text.trim(),
      'category': widget.category,
    });
    await ref.refresh(productListFuture(apiData).future);
    setState(() {});
  }

  @override
  void dispose() {
    searchKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(productListFuture(
      jsonEncode(
        {
          "pageNo": pageNo,
          "searchKey": searchKey.text.trim(),
          "category": widget.category
        },
      ),
    ));
    final products = ref.watch(productsList);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: KScaffold(
        appBar: AppBar(
          title: Label(
            widget.category == "All"
                ? "Our Products"
                : "Showing products for ${widget.category}",
            fontSize: 18,
          ).regular,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(kPadding),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KSearchbar(
                  controller: searchKey,
                  hintText: "Search products",
                  onClear: () {
                    _refresh();
                  },
                  onFieldSubmitted: (val) async {
                    _refresh();
                  },
                ),
                if (asyncData.isLoading) LinearProgressIndicator(),
                height10,
                if (products.isNotEmpty) ...[
                  Label(searchKey.text.isEmpty
                          ? "Top rated products"
                          : "Searching for \"${searchKey.text}\"")
                      .title,
                  height5,

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .59,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) => ProductPreviewCard(
                      cardWidth: double.infinity,
                      product: products[index],
                    ),
                  ),
                  // MasonryGridView.count(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 10,
                  //   crossAxisSpacing: 10,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: products.length,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) {
                  //     return ProductPreviewCard(
                  //       cardWidth: double.infinity,
                  //       product: products[index],
                  //     );
                  //   },
                  // ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Label("Sorry :(", weight: 500, fontSize: 25).title,
                        Label("No products found!", color: KColor.fadeText)
                            .title,
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
