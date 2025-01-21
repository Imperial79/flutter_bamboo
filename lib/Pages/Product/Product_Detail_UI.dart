import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kCarousel.dart';
import 'package:flutter_bamboo/Helper/appLink.dart';
import 'package:flutter_bamboo/Helper/data.dart';
import 'package:flutter_bamboo/Models/Product_Detail_Model.dart';
import 'package:flutter_bamboo/Repository/product_repo.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class Product_Detail_UI extends ConsumerStatefulWidget {
  final int id;
  final String? referCode;
  const Product_Detail_UI({
    super.key,
    required this.id,
    this.referCode,
  });

  @override
  ConsumerState<Product_Detail_UI> createState() => _Product_Detail_UIState();
}

class _Product_Detail_UIState extends ConsumerState<Product_Detail_UI> {
  String selectedDescriptionType = "About Item";
  int selectedVariant = 0;
  bool showLess = false;
  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productDetailsFuture(widget.id));

    return KScaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.go("/"), icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              String productLink =
                  createProductPath(productId: 200, referCode: "ABC12817");
              Share.share(
                "Checkout this product $productLink",
                subject: "ABCD",
              );
            },
            icon: SvgPicture.asset(
              "$kIconPath/share.svg",
              height: 22,
              colorFilter: kSvgColor(LColor.fadeText),
            ),
          ),
          width10,
          Badge(
            backgroundColor: Colors.pink,
            label: Label("1").regular,
            child: IconButton(
              onPressed: () => context.push("/cart"),
              icon: SvgPicture.asset(
                "$kIconPath/shopping-bag.svg",
                height: 22,
                colorFilter: kSvgColor(LColor.fadeText),
              ),
            ),
          ),
          width10,
        ],
      ),
      body: SafeArea(
        child: productData.when(
          data: (data) => data != null
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(kPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      KCarousel(
                        isLooped: false,
                        images: data.images,
                        height: 300,
                      ),
                      height10,
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            kCatgeoryMap[data.category] ?? Icons.apps,
                            size: 20,
                            color: LColor.fadeText,
                          ),
                          Label(
                            data.category,
                            fontSize: 17,
                            color: LColor.fadeText,
                          ).regular,
                        ],
                      ),
                      Label(data.name, weight: 700, fontSize: 17, height: 1.3)
                          .title,
                      height5,
                      Row(
                        spacing: 7,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber.shade700,
                          ),
                          Label(
                            "${data.totalRatings} Ratings • ${data.totalReviews} Reviews • ${data.totalSell} Sold",
                            weight: 600,
                            fontSize: 17,
                            color: LColor.fadeText,
                          ).title,
                        ],
                      ),
                      height5,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("₹", fontSize: 20, height: 1.2).regular,
                          Flexible(
                            child: Label(
                              kCurrencyFormat(
                                data.product_variants![selectedVariant]
                                    ["salePrice"],
                                symbol: "",
                              ),
                              fontSize: 30,
                              height: 1,
                              weight: 600,
                            ).title,
                          ),
                          width10,
                          Label(
                            "-${((parseToDouble(data.product_variants![selectedVariant]["salePrice"]) / parseToDouble(data.product_variants![selectedVariant]["mrp"])) * 100).round()}%",
                            fontSize: 20,
                            height: 1,
                            weight: 400,
                            color: kColor(context).error,
                          ).title,
                        ],
                      ),
                      Label(
                        "MRP ${kCurrencyFormat(data.product_variants![selectedVariant]["mrp"])}",
                        decoration: TextDecoration.lineThrough,
                      ).regular,
                      Row(
                        spacing: 5,
                        children: [
                          Label(
                            "Variant:",
                            fontSize: 16,
                          ).regular,
                          Flexible(
                            child: Label(
                              data.product_variants![selectedVariant]
                                  ["attributeValue"],
                              fontSize: 16,
                              weight: 800,
                            ).regular,
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8,
                          children: List.generate(
                            data.product_variants!.length,
                            (index) => _variantCard(
                              index: index,
                              label: data.product_variants![selectedVariant]
                                  ["attributeValue"],
                              amount: kCurrencyFormat(
                                data.product_variants![selectedVariant]
                                    ["salePrice"],
                              ),
                              mrp: kCurrencyFormat(
                                data.product_variants![selectedVariant]["mrp"],
                                symbol: "MRP ",
                              ),
                            ),
                          ),
                        ),
                      ),
                      height10,
                      Row(
                        children: [
                          descriptionSelectBtn("About Item"),
                          descriptionSelectBtn("Reviews"),
                        ],
                      ),
                      if (selectedDescriptionType == "About Item")
                        ...aboutItemTab(data)
                      else
                        ...reviewsTab(),
                      height10,
                      Label(
                        "Products you may like",
                        weight: 900,
                        fontSize: 17,
                      ).regular,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 10,
                          children: [
                            // ProductPreviewCard(
                            //   cardWidth: 200,
                            // ),
                            // ProductPreviewCard(
                            //   cardWidth: 200,
                            // ),
                            // ProductPreviewCard(
                            //   cardWidth: 200,
                            // ),
                            // ProductPreviewCard(
                            //   cardWidth: 200,
                            // ),
                            // ProductPreviewCard(
                            //   cardWidth: 200,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Label("No data!").regular,
                ),
          error: (error, stackTrace) => Center(
            child: Label("$error").regular,
          ),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: productData.hasValue && productData.value != null
          ? Container(
              padding: EdgeInsets.all(kPadding),
              decoration: BoxDecoration(
                color: LColor.scaffold,
                boxShadow: [
                  BoxShadow(
                    color: kOpacity(LColor.secondary, .1),
                    blurRadius: 20,
                    spreadRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Label("Total Price").regular,
                          Label(
                            "INR 190",
                            weight: 800,
                            fontSize: 25,
                            color: LColor.primary,
                          ).title,
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        KSnackbar(
                          context,
                          message: "Product added to cart.",
                        );
                      },
                      child: Container(
                        height: 55,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: LColor.primary,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(7),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              "$kIconPath/shopping-bag.svg",
                              height: 20,
                              colorFilter: kSvgColor(Colors.white),
                            ),
                            Label(
                              "1",
                              fontSize: 20,
                              weight: 700,
                              height: 1,
                              color: Colors.white,
                            ).regular,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        color: LColor.secondary,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(7),
                        ),
                      ),
                      child: FittedBox(
                        child: Label("Buy Now",
                                fontSize: 20, weight: 700, color: Colors.white)
                            .regular,
                      ),
                    )
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Widget _variantCard(
      {required int index,
      required String label,
      required String amount,
      required String mrp}) {
    bool selected = selectedVariant == index;
    return KCard(
      onTap: () => setState(() {
        selectedVariant = index;
      }),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderColor: selected ? kColor(context).primary : LColor.card,
      color: selected ? kColor(context).primaryContainer : LColor.card,
      borderWidth: 1.5,
      radius: 10,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Label(label, fontSize: 17, weight: 800).regular),
              KCard(
                borderWidth: 2,
                color: kOpacity(Colors.white, .8),
                radius: 5,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Label(
                  amount,
                  fontSize: 15,
                  weight: 800,
                ).regular,
              ),
            ],
          ),
          Label(
            mrp,
            decoration: TextDecoration.lineThrough,
          ).regular,
        ],
      ),
    );
  }

  List<Widget> aboutItemTab(ProductDetailModel product) {
    return [
      Label(
        "Description",
        weight: 900,
        fontSize: 17,
      ).regular,
      Text.rich(
        style: TextStyle(
            fontVariations: [FontVariation.weight(500)], fontSize: 16),
        TextSpan(
          children: [
            TextSpan(
              text: product.description.substring(
                  0,
                  showLess
                      ? product.description.length
                      : product.description.length < 50
                          ? product.description.length
                          : 50),
            ),
            if (product.description.length > 50)
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      showLess = !showLess;
                    });
                  },
                text: showLess ? "...read less" : "...read more",
                style: TextStyle(
                    fontVariations: [FontVariation.weight(900)],
                    color: kColor(context).primary),
              ),
          ],
        ),
      ),
    ];
  }

  List<Widget> reviewsTab() {
    return [
      height20,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 10,
        children: [
          Label("4.9", fontSize: 50, height: 1, weight: 900).title,
          Label("/ 5.0").title,
        ],
      ),
      StarRating(
        rating: 4.9,
        allowHalfRating: false,
        color: Colors.amber.shade800,
        // onRatingChanged: (rating) => setState(() => this.rating = rating),
      ),
      Center(
        child: Label(
          "2.8k Reviews",
          weight: 500,
          fontSize: 17,
          textAlign: TextAlign.center,
        ).regular,
      ),
      height20,
      Label(
        "Reviews & Ratings",
        weight: 900,
        fontSize: 17,
      ).regular,
      KCard(
        radius: 0,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 15,
                ),
                Expanded(
                    child: Label(
                  "User N***e",
                  weight: 800,
                  fontSize: 17,
                ).regular),
                Icon(
                  Icons.star,
                  color: Colors.amber.shade700,
                ),
                Label(
                  "5.0",
                  weight: 800,
                  fontSize: 17,
                ).regular
              ],
            ),
            Label(
              "\"The product is more than my expectations\"",
              fontSize: 16,
            ).regular,
          ],
        ),
      )
    ];
  }

  Widget descriptionSelectBtn(String label) {
    bool selected = selectedDescriptionType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDescriptionType = label;
          });
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 10, left: 20),
          decoration: BoxDecoration(
            color: LColor.scaffold,
            border: Border(
              bottom: BorderSide(
                  color: selected ? LColor.primary : Colors.grey.shade300,
                  width: 3),
            ),
          ),
          child: Label(
            label,
            weight: selected ? 900 : 700,
            color: selected ? LColor.primary : Colors.grey.shade400,
          ).title,
        ),
      ),
    );
  }
}
