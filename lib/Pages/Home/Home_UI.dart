// ignore_for_file: unused_result

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Pages/Home/Buy_Membership_Card.dart';
import 'package:ngf_organic/Pages/Product/Product_Preview_Card.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Repository/product_repo.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:ngf_organic/main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Components/kCard.dart';
import '../../Components/kCarousel.dart';
import '../../Resources/colors.dart';

class Home_UI extends ConsumerStatefulWidget {
  const Home_UI({super.key});

  @override
  ConsumerState<Home_UI> createState() => _Home_UIState();
}

class _Home_UIState extends ConsumerState<Home_UI> {
  final carouselKey = GlobalKey();
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
    final asyncData = ref.watch(productListFuture(
      jsonEncode(
        {"pageNo": 0, "searchKey": "", "category": selectedCategory},
      ),
    ));

    final products = ref.watch(productsList);
    final offersData = ref.watch(offersFuture);
    final user = ref.watch(userProvider);

    return KScaffold(
      isLoading: isLoading,
      body: SafeArea(
        child: Column(
          children: [
            KCard(
              color: Kolor.scaffold,
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
                      color: Kolor.scaffold,
                      borderWidth: 1,
                      radius: 10,
                      child: Row(
                        spacing: 10,
                        children: [
                          SvgPicture.asset(
                            "$kIconPath/search.svg",
                            height: 20,
                            colorFilter: kSvgColor(Kolor.fadeText),
                          ),
                          Flexible(
                            child: Label(
                              "Search products",
                              fontSize: 15,
                              weight: 600,
                              color: Kolor.fadeText,
                            ).title,
                          ),
                        ],
                      ),
                    ),
                  ),
                  KCartIcon(),
                ],
              ),
            ),
            offersData.when(
              data: (data) => data != null
                  ? KCard(
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
                  : SizedBox(),
              error: (error, stackTrace) => SizedBox(),
              loading: () => kHeight(30),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refresh(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      offersData.when(
                        data: (data) => data != null
                            ? BuyMembershipCard(
                                fees: data["settings"]["membershipFees"],
                                loadingStatus: (value) {
                                  isLoading.value = value;
                                },
                              )
                            : SizedBox(),
                        error: (error, stackTrace) => SizedBox(),
                        loading: () => SizedBox(),
                      ),
                      offersData.when(
                        data: (data) => data != null
                            ? LayoutBuilder(
                                builder: (context, constraints) {
                                  double aspectRatio =
                                      16 / 9; // Custom aspect ratio
                                  double height =
                                      constraints.maxWidth / aspectRatio;
                                  return KCarousel(
                                    height: height,
                                    isLooped: true,
                                    children: List.generate(
                                      data["banners"].length,
                                      (index) => GestureDetector(
                                        onTap: () async {
                                          String? url =
                                              data["banners"][index]["link"];
                                          if (url != null) {
                                            await launchUrlString(
                                                data["banners"][index]["link"]);
                                          }
                                        },
                                        child: Container(
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
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                        error: (error, stackTrace) => SizedBox(),
                        loading: () => Skeletonizer(
                          child: KCard(
                            width: double.infinity,
                            height: 250,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kPadding, vertical: kPadding),
                        child: Row(
                          spacing: 10,
                          children: [
                            _categoryBtn(Icons.apps, "All", Colors.black),
                            _categoryBtn(Icons.male, "Men", Colors.blue),
                            _categoryBtn(Icons.female, "Women", Colors.pink),
                            _categoryBtn(Icons.child_care, "Kids",
                                Colors.amber.shade900),
                          ],
                        ),
                      ),
                      if (user != null && user.phone == null)
                        KCard(
                          onTap: () => context.push("/profile/edit"),
                          margin: EdgeInsets.all(15),
                          child: Row(
                            spacing: 15,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 30,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Label("Add Phone Number",
                                            fontSize: 16, weight: 650)
                                        .title,
                                    Label(
                                      "Complete your profile by adding your phone number in profile section.",
                                    ).subtitle,
                                  ],
                                ),
                              ),
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
                                    weight: 600,
                                    color: kColor(context).primary,
                                  ).regular,
                                ),
                              ],
                            ),
                            ValueListenableBuilder(
                              valueListenable: hasConnection,
                              builder: (context, hasInternet, _) {
                                if (hasInternet) {
                                  if (asyncData.isLoading) {
                                    return loadingProducts();
                                  }
                                  return MasonryGridView.count(
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
                                  );
                                } else {
                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      loadingProducts(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kPadding),
                                        child: KButton(
                                          onPressed: () {
                                            _refresh();
                                          },
                                          label: "Retry",
                                          radius: 5,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingProducts() {
    return Skeletonizer(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return KCard(
            padding: EdgeInsets.all(0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KCard(
                  color: Kolor.scaffold,
                  height: 150,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        "category",
                        weight: 500,
                        fontSize: 12,
                        color: Kolor.fadeText,
                      ).subtitle,
                      Label(
                        "name",
                        maxLines: 2,
                        weight: 600,
                      ).regular,
                      height10,
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber.shade700,
                          ),
                          Label(
                            "Ratings | Sale",
                            weight: 600,
                            fontSize: 12,
                            color: Kolor.fadeText,
                          ).regular,
                        ],
                      ),
                      height5,
                      FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 5,
                          children: [
                            Label(
                              "Price",
                              weight: 600,
                              height: 1.2,
                              fontSize: 20,
                            ).title,
                            Label(
                              "-0%",
                              weight: 500,
                              fontSize: 15,
                              color: StatusText.danger,
                            ).title,
                            width5,
                            Label(
                              "MRP 1000",
                              weight: 500,
                              fontSize: 12,
                              color: Kolor.fadeText,
                              decoration: TextDecoration.lineThrough,
                            ).regular,
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
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
