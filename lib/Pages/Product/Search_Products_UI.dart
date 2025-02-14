// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/KSearchbar.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
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
  final pageNo = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        pageNo.value += 1;
        ref.refresh(productListFuture(jsonEncode({
          'pageNo': pageNo.value,
          'searchKey': searchKey.text.trim(),
          'category': widget.category,
        })).future);
        log("${pageNo.value}");
      }
    }
  }

  Future<void> _refresh() async {
    pageNo.value = 0;
    String apiData = jsonEncode({
      'pageNo': pageNo.value,
      'searchKey': searchKey.text.trim(),
      'category': widget.category,
    });
    await ref.refresh(productListFuture(apiData).future);
    setState(() {});
  }

  @override
  void dispose() {
    searchKey.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(productListFuture(jsonEncode({
      "pageNo": pageNo.value,
      "searchKey": searchKey.text.trim(),
      "category": widget.category
    })));
    final products = ref.watch(productsList);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: KScaffold(
        appBar: KAppBar(
          context,
          title: widget.category == "All"
              ? "Our Products"
              : "Showing products for ${widget.category}",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
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
                  MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ProductPreviewCard(
                        product: products[index],
                      );
                    },
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Label("Sorry :(", weight: 500, fontSize: 25).title,
                        Label("No products found!", color: Kolor.fadeText)
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
