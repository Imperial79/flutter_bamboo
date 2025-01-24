// ignore_for_file: unused_result

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Preview_Card.dart';
import 'package:flutter_bamboo/Repository/product_repo.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import '../../Components/kCard.dart';
import '../../Components/kCarousel.dart';
import '../../Repository/cart_repo.dart';
import '../../Resources/colors.dart';

class Home_UI extends ConsumerStatefulWidget {
  const Home_UI({super.key});

  @override
  ConsumerState<Home_UI> createState() => _Home_UIState();
}

class _Home_UIState extends ConsumerState<Home_UI> {
  int pageNo = 0;
  String selectedCategory = "All";
  Future<void> _refresh() async {
    pageNo = 0;
    String apiData = jsonEncode({
      'pageNo': pageNo,
      'searchKey': "",
      'category': selectedCategory,
    });
    await ref.refresh(productListFuture(apiData).future);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(productListFuture(
      jsonEncode(
        {"pageNo": 0, "searchKey": "", "category": selectedCategory},
      ),
    ));

    final products = ref.watch(productsList);
    final cartLength = ref.watch(cartProvider).length;
    return KScaffold(
      body: SafeArea(
        child: Column(
          children: [
            KCard(
              color: LColor.scaffold,
              radius: 0,
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: KCard(
                      onTap: () => context.push("/search-products").then(
                        (value) {
                          _refresh();
                        },
                      ),
                      color: LColor.scaffold,
                      borderWidth: 1,
                      radius: 10,
                      child: Row(
                        spacing: 10,
                        children: [
                          SvgPicture.asset(
                            "$kIconPath/search.svg",
                            height: 20,
                            colorFilter: kSvgColor(LColor.fadeText),
                          ),
                          Flexible(
                            child: Label(
                              "Search products",
                              fontSize: 15,
                              weight: 600,
                              color: LColor.fadeText,
                            ).title,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Badge(
                    offset: Offset(-1, 20),
                    isLabelVisible: cartLength > 0,
                    label: Label("$cartLength").regular,
                    child: IconButton(
                      onPressed: () => context.push("/cart"),
                      icon: SvgPicture.asset(
                        cartLength > 0
                            ? "$kIconPath/shopping-bag-filled.svg"
                            : "$kIconPath/shopping-bag.svg",
                        height: 22,
                        colorFilter: kSvgColor(
                          cartLength > 0 ? LColor.primary : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            KCard(
              radius: 0,
              padding: EdgeInsets.symmetric(vertical: 5),
              height: 30,
              child: Marquee(
                text:
                    'Mega Offer! Get Instant 20% OFF* on Selected Products. Mega Offer! Get Instant 20% OFF* on Selected Products.',
                style: TextStyle(
                  fontVariations: [
                    FontVariation.weight(600),
                  ],
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 50.0,
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.decelerate,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    KCarousel(
                      height: 250,
                      isLooped: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1736776256361-360f071c2540?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1736344319749-93bc29f03d5d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      child: Row(
                        spacing: 20,
                        children: [
                          _categoryBtn(Icons.apps, "All", Colors.black),
                          _categoryBtn(Icons.male, "Men", Colors.blue),
                          _categoryBtn(Icons.female, "Women", Colors.pink),
                          _categoryBtn(
                              Icons.child_care, "Kids", Colors.amber.shade900),
                        ],
                      ),
                    ),
                    KCard(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Label(
                                  "Best Sale Products",
                                  fontWeight: FontWeight.w700,
                                ).title,
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.push("/search-products"),
                                child: Label(
                                  "See More",
                                  fontSize: 16,
                                  weight: 700,
                                ).regular,
                              ),
                            ],
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
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryBtn(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => context.push('/search-products?category=$label').then(
            (value) => _refresh(),
          ),
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          KCard(
            radius: 15,
            child: Icon(
              icon,
              color: color,
            ),
          ),
          Label(label, fontSize: 12).regular,
        ],
      ),
    );
  }
}
