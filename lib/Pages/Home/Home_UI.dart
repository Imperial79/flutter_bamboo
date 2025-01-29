// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Pages/Home/Buy_Membership_Card.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Preview_Card.dart';
import 'package:flutter_bamboo/Repository/product_repo.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
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
  final isLoading = ValueNotifier(false);
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
    final cartData = ref.watch(cartFuture);
    final offersData = ref.watch(offersFuture);
    log("$offersData");
    return KScaffold(
      isLoading: isLoading,
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
            // BuyMembershipCard(
            //   loadingStatus: (value) {
            //     isLoading.value = value;
            //   },
            // ),
            ...offersData.when(
              data: (data) => data != null
                  ? [
                      BuyMembershipCard(
                        fees: data["settings"]["membershipFees"],
                        loadingStatus: (value) {
                          isLoading.value = value;
                        },
                      ),
                      KCard(
                        radius: 0,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        height: 30,
                        child: Marquee(
                          text: data["settings"]["offerMarquee"],
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
                          accelerationDuration: Duration(seconds: 0),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.decelerate,
                        ),
                      )
                    ]
                  : [SizedBox()],
              error: (error, stackTrace) => [SizedBox()],
              loading: () => [kHeight(30)],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    offersData.when(
                      data: (data) => data != null
                          ? KCarousel(
                              height: 250,
                              isLooped: true,
                              children: List.generate(
                                data["banners"].length,
                                (index) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data["banners"][index]["image"],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      error: (error, stackTrace) => SizedBox(),
                      loading: () => KCard(
                        width: double.infinity,
                        height: 250,
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
