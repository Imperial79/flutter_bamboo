// ignore_for_file: unused_result

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Preview_Card.dart';
import 'package:flutter_bamboo/Repository/product_repo.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
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
    // final localCart = ref.watch(cartProvider);
    final cartData = ref.watch(cartFuture);
    // cartData.whenData((value) {
    //   if (value.isNotEmpty) {
    //     for (Map e in value) {
    //       if (localCart
    //           .any((element) => element.productId != e["productVariantId"])) {
    //         ref.read(cartProvider.notifier).addItem(CartItemModel(
    //             productId: e["productVariantId"], quantity: e["qty"]));
    //       }
    //     }
    //   }
    // });
    return KScaffold(
      body: SafeArea(
        child: Column(
          children: [
            KCard(
              color: KColor.scaffold,
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
                      color: KColor.scaffold,
                      borderWidth: 1,
                      radius: 10,
                      child: Row(
                        spacing: 10,
                        children: [
                          SvgPicture.asset(
                            "$kIconPath/search.svg",
                            height: 20,
                            colorFilter: kSvgColor(KColor.fadeText),
                          ),
                          Flexible(
                            child: Label(
                              "Search products",
                              fontSize: 15,
                              weight: 600,
                              color: KColor.fadeText,
                            ).title,
                          ),
                        ],
                      ),
                    ),
                  ),
                  cartData.when(
                    data: (data) => Badge(
                      offset: Offset(-1, 20),
                      isLabelVisible: data.isNotEmpty,
                      label: Label("${data.length}").regular,
                      child: IconButton(
                        onPressed: () => context.push("/cart"),
                        icon: SvgPicture.asset(
                          data.isNotEmpty
                              ? "$kIconPath/shopping-bag-filled.svg"
                              : "$kIconPath/shopping-bag.svg",
                          height: 22,
                          colorFilter: kSvgColor(
                            data.isNotEmpty ? KColor.primary : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => IconButton(
                      onPressed: () => context.push("/cart"),
                      icon: SvgPicture.asset(
                        "$kIconPath/shopping-bag.svg",
                        height: 22,
                      ),
                    ),
                    loading: () => IconButton(
                      onPressed: () => context.push("/cart"),
                      icon: SvgPicture.asset(
                        "$kIconPath/shopping-bag.svg",
                        height: 22,
                      ),
                    ),
                  )
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
                        "https://static.vecteezy.com/system/resources/previews/001/381/216/non_2x/special-offer-sale-banner-with-megaphone-free-vector.jpg",
                        "https://img.freepik.com/free-vector/mega-sale-offers-banner-template_1017-31299.jpg",
                        "https://mir-s3-cdn-cf.behance.net/project_modules/hd/e0258724785543.5633a09ab2d1d.jpg",
                      ]
                          .map(
                            (e) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    e,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kScheme.primary,
                            KColor.primary,
                            kScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  "NGF Organic",
                                  color: Colors.white,
                                  fontSize: 15,
                                ).regular,
                                Label("Membership",
                                        color: Colors.white, fontSize: 25)
                                    .title,
                              ],
                            ),
                          ),
                          KButton(
                            onPressed: () {},
                            label: "Pay Now",
                            radius: 5,
                            fontSize: 12,
                            backgroundColor: kScheme.secondary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      child: Row(
                        spacing: 10,
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
                                child: Label("Best Sale Products",
                                        weight: 700, fontSize: 17)
                                    .title,
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.push("/search-products"),
                                child: Label(
                                  "See More",
                                  weight: 700,
                                  color: KColor.primary,
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
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push('/search-products?category=$label').then(
              (value) => _refresh(),
            ),
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            KCard(
              width: double.infinity,
              radius: 15,
              child: Icon(
                icon,
                color: color,
              ),
            ),
            Label(label, fontSize: 12, weight: 600).regular,
          ],
        ),
      ),
    );
  }
}
