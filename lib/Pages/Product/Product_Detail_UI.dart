// ignore_for_file: unused_result
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kCarousel.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Helper/data.dart';
import 'package:ngf_organic/Helper/share_product.dart';
import 'package:ngf_organic/Models/Product_Detail_Model.dart';
import 'package:ngf_organic/Models/Product_Variant_Model.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Repository/cart_repo.dart';
import 'package:ngf_organic/Repository/product_repo.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Product_Detail_UI extends ConsumerStatefulWidget {
  final int id;
  final String? referCode;
  final String? sku;
  const Product_Detail_UI({
    super.key,
    required this.id,
    this.referCode,
    this.sku,
  });

  @override
  ConsumerState<Product_Detail_UI> createState() => _Product_Detail_UIState();
}

class _Product_Detail_UIState extends ConsumerState<Product_Detail_UI> {
  String selectedDescriptionType = "About Item";
  bool showLess = false;
  final isLoading = ValueNotifier(false);

  ProductVariantModel selectedVariant = ProductVariantModel.fromMap({});

  addToCart(int variantId) async {
    try {
      final isLoggedIn = ref.read(userProvider) != null;
      if (isLoggedIn) {
        isLoading.value = true;
        await ref.read(cartRepo).updateCart({
          "productVariantId": variantId,
          "qty": 1,
        });

        await ref.refresh(cartFuture.future);
      } else {
        context.push("/login", extra: {
          "redirectPath": "/product/abc/${widget.id}?sku=${widget.sku}",
          "referCode": widget.referCode,
        });
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  buyNow(user) async {
    if (user != null) {
      await addToCart(selectedVariant.id);
      context.push("/cart");
    } else {
      log("Refercode (Product Detail) - ${widget.referCode} | SKU (Product Detail) - ${widget.sku}");
      context.push("/login", extra: {
        "redirectPath": "/product/abc/${widget.id}?sku=${widget.sku}",
        "referCode": widget.referCode,
      });
    }
  }

  shareProduct(ProductDetailModel product) async {
    try {
      isLoading.value = true;
      final user = ref.read(userProvider);

      await ProductHelper().shareProduct(product,
          sku: selectedVariant.sku,
          referCode: user != null && user.affiliateStatus == "Active"
              ? user.referCode
              : null);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productDetailsFuture(widget.id));
    final cartData = ref.watch(cartFuture);

    productData.whenData(
      (value) {
        if (value != null && selectedVariant.id == -1) {
          selectedVariant =
              ProductVariantModel.fromMap(value.product_variants[0]);
        }
      },
    );
    return KScaffold(
      isLoading: isLoading,
      appBar: productData.hasValue && productData.value != null
          ? KAppBar(
              context,
              actions: [
                IconButton(
                  onPressed: () => shareProduct(productData.value!),
                  icon: SvgPicture.asset(
                    "$kIconPath/share.svg",
                    height: 20,
                  ),
                ),
                width10,
                KCartIcon(),
                width10,
              ],
            )
          : null,
      body: SafeArea(
        child: productData.when(
          data: (product) => product != null
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KCarousel(
                              isLooped: false,
                              images: product.images,
                              height: 300,
                            ),
                            height20,
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  kCatgeoryMap[product.category] ?? Icons.apps,
                                  size: 20,
                                  color: Kolor.fadeText,
                                ),
                                Label(
                                  product.category,
                                  fontSize: 15,
                                  weight: 600,
                                  color: Kolor.fadeText,
                                ).regular,
                              ],
                            ),
                            height5,
                            Label(product.name,
                                    weight: 700, fontSize: 17, height: 1.3)
                                .title,
                            height10,
                            Row(
                              spacing: 7,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade700,
                                ),
                                Expanded(
                                  child: Label(
                                    "${product.totalRatings} Ratings • ${thousandToK(product.totalReviews)} Reviews • ${thousandToK(product.totalSell)} Sold",
                                    weight: 500,
                                    fontSize: 15,
                                    color: Kolor.fadeText,
                                  ).title,
                                ),
                              ],
                            ),
                            height20,
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Label("₹", fontSize: 20, height: 1.2)
                                          .regular,
                                      Flexible(
                                        child: Label(
                                          kCurrencyFormat(
                                            selectedVariant.salePrice,
                                            symbol: "",
                                          ),
                                          fontSize: 30,
                                          height: 1,
                                          weight: 600,
                                        ).title,
                                      ),
                                      width10,
                                      Label(
                                        "-${calculateDiscount(selectedVariant.mrp, selectedVariant.salePrice)}%",
                                        fontSize: 20,
                                        height: 1,
                                        weight: 500,
                                        color: kColor(context).error,
                                      ).title,
                                    ],
                                  ),
                                ),

                                // DropdownButton(
                                //   isDense: true,
                                //   value: selectedQty,
                                //   icon: Icon(
                                //     Icons.keyboard_arrow_down_rounded,
                                //     size: 20,
                                //   ),
                                //   menuMaxHeight: 300,
                                //   borderRadius: kRadius(10),
                                //   elevation: 1,
                                //   items: List.generate(
                                //     9,
                                //     (index) => DropdownMenuItem(
                                //         value: index + 1,
                                //         child: Label("${index + 1}").regular),
                                //   ),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       selectedQty = value!;
                                //     });
                                //   },
                                // ),
                              ],
                            ),
                            height5,
                            Label(
                              "MRP ${kCurrencyFormat(selectedVariant.mrp)}",
                              weight: 600,
                              color: Kolor.fadeText,
                              decoration: TextDecoration.lineThrough,
                            ).regular,
                            Label("Inclusive of all taxes",
                                    color: Kolor.fadeText, weight: 600)
                                .subtitle,
                            height20,
                            Row(
                              spacing: 5,
                              children: [
                                Label("Variant:", fontSize: 16, weight: 600)
                                    .regular,
                                Flexible(
                                  child: selectedVariant.attributeType ==
                                          "Color"
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Color(int.parse(
                                              selectedVariant.attributeValue
                                                  .replaceFirst('#', '0xff'))),
                                        )
                                      : Label(
                                          selectedVariant.attributeValue,
                                          fontSize: 16,
                                          weight: 700,
                                        ).regular,
                                ),
                              ],
                            ),
                            height20,
                            KCard(
                              width: double.infinity,
                              borderWidth: 1,
                              color: Kolor.scaffold,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15,
                                children: [
                                  // Row(
                                  //   spacing: 12,
                                  //   children: [
                                  //     SvgPicture.asset(
                                  //       '$kIconPath/shipping-fast.svg',
                                  //       height: 20,
                                  //     ),
                                  //     Label("Delivery Within").regular,
                                  //   ],
                                  // )
                                  _row("shipping-fast.svg", "Express delivery"),
                                  _row(
                                      "return.svg",
                                      product.returnDays != 0
                                          ? "${product.returnDays} days returnable"
                                          : "Non returnable"),
                                  _row("secure.svg", "Secure transaction"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // height5,
                      // SingleChildScrollView(
                      //   padding: EdgeInsets.symmetric(horizontal: kPadding),
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     spacing: 8,
                      //     children: List.generate(
                      //       product.product_variants.length,
                      //       (index) {
                      //         return _variantCard(
                      //           ProductVariantModel.fromMap(
                      //               product.product_variants[index]),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height20,
                            Row(
                              children: [
                                descriptionSelectBtn("About Item"),
                                descriptionSelectBtn("Reviews"),
                              ],
                            ),
                            height20,
                            if (selectedDescriptionType == "About Item")
                              ...aboutItemTab(product)
                            else
                              reviewsTab(product),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : kNoData(context),
          error: (error, stackTrace) => kNoData(context),
          loading: () => kSmallLoading,
        ),
      ),
      bottomNavigationBar: productData.hasValue && productData.value != null
          ? selectedVariant.stock == 0
              ? KCard(
                  width: double.infinity,
                  child: SafeArea(
                      child: Label(
                    "Out Of Stock",
                    textAlign: TextAlign.center,
                    color: StatusText.danger,
                  ).regular),
                )
              : footer(productData.value!, cartData.value ?? [])
          : null,
    );
  }

  Widget _row(String iconPath, String text) {
    return Row(
      spacing: 12,
      children: [
        SvgPicture.asset(
          '$kIconPath/$iconPath',
          height: 20,
        ),
        Label(text, weight: 500).regular,
      ],
    );
  }

  Widget footer(ProductDetailModel product, List cart) {
    return Consumer(
      builder: (context, ref, child) {
        final inCart =
            cart.any((item) => item["productVariantId"] == selectedVariant.id);
        final user = ref.watch(userProvider);
        return Container(
          padding: EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            color: Kolor.scaffold,
            boxShadow: [
              BoxShadow(
                color: kOpacity(Kolor.secondary, .1),
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
                      Label("Total Price", fontSize: 12).regular,
                      Label(
                        kCurrencyFormat(
                          selectedVariant.salePrice,
                          symbol: "INR ",
                        ),
                        weight: 700,
                        fontSize: 20,
                        color: Kolor.secondary,
                      ).title,
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!inCart) {
                      addToCart(selectedVariant.id);
                    } else {
                      context.push("/cart");
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Kolor.primary,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(7),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        if (!inCart)
                          SvgPicture.asset(
                            "$kIconPath/shopping-bag.svg",
                            height: 20,
                            colorFilter: kSvgColor(Colors.white),
                          ),
                        if (cart.isNotEmpty && !inCart)
                          Label(
                            "${cart.length}",
                            fontSize: 20,
                            weight: 700,
                            height: 1,
                            color: Colors.white,
                          ).regular,
                        if (inCart)
                          Label("Go to cart", color: Colors.white).regular
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    buyNow(user);
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Kolor.secondary,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(7),
                      ),
                    ),
                    child: FittedBox(
                      child: Label("Buy Now",
                              fontSize: 17, weight: 600, color: Colors.white)
                          .regular,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _variantCard(ProductVariantModel data) {
  //   bool selected = selectedVariant == data;
  //   bool isColor = data.attributeType == "Color";
  //   return KCard(
  //     onTap: () => setState(() {
  //       selectedVariant = data;
  //     }),
  //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     borderColor: selected ? kColor(context).primary : KColor.card,
  //     color: selected ? kOpacity(kColor(context).primaryContainer, .7) : KColor.card,
  //     borderWidth: 1.5,
  //     radius: 10,
  //     width: 200,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           spacing: 10,
  //           children: [
  //             Flexible(
  //               child: isColor
  //                   ? CircleAvatar(
  //                       radius: 10,
  //                       backgroundColor: Color(int.parse(
  //                           data.attributeValue.replaceFirst('#', '0xff'))),
  //                     )
  //                   : Label(data.attributeValue,
  //                           fontSize: 17, weight: 700, maxLines: 1)
  //                       .regular,
  //             ),
  //             KCard(
  //               borderWidth: 2,
  //               color: kOpacity(Colors.white, .8),
  //               radius: 5,
  //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
  //               child: Label(
  //                 kCurrencyFormat(data.salePrice),
  //                 fontSize: 12,
  //               ).regular,
  //             ),
  //           ],
  //         ),
  //         Label(kCurrencyFormat(data.mrp),
  //                 decoration: TextDecoration.lineThrough,
  //                 color: KColor.fadeText)
  //             .regular,
  //       ],
  //     ),
  //   );
  // }

  List<Widget> aboutItemTab(ProductDetailModel product) {
    return [
      Label(
        "Description",
      ).regular,
      Text.rich(
        style: TextStyle(fontVariations: [FontVariation.weight(500)]),
        TextSpan(
          children: [
            TextSpan(
              text: product.description.substring(
                  0,
                  showLess
                      ? product.description.length
                      : product.description.length < 500
                          ? product.description.length
                          : 500),
            ),
            if (product.description.length > 500)
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      showLess = !showLess;
                    });
                  },
                text: showLess ? "...read less" : "...read more",
                style: TextStyle(
                  fontVariations: [FontVariation.weight(660)],
                  color: Kolor.primary,
                ),
              ),
          ],
        ),
      ),
      height20,
    ];
  }

  reviewsTab(ProductDetailModel product) {
    return Consumer(
      builder: (context, ref, child) {
        final reviewData = ref.watch(productReviewsFuture(product.id));
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  Label(
                    "${product.totalRatings}",
                    fontSize: 40,
                    height: 1,
                    weight: 800,
                  ).title,
                  Label(
                    "/ 5.0",
                    fontSize: 17,
                  ).title,
                ],
              ),
              StarRating(
                rating: product.totalRatings,
                allowHalfRating: false,
                color: Colors.amber.shade800,
              ),
              Center(
                child: Label(
                  "${thousandToK(product.totalReviews)} Reviews",
                  weight: 500,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ).regular,
              ),
              height20,
              height15,
              ...reviewData.when(
                data: (data) => data.isNotEmpty
                    ? [
                        Label(
                          "Reviews & Ratings",
                        ).regular,
                        height10,
                        ...data.map(
                          (review) => KCard(
                            margin: EdgeInsets.only(bottom: 10),
                            radius: 0,
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 5,
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      child: Label(
                                              review["name"][0].toUpperCase(),
                                              fontSize: 12,
                                              weight: 500)
                                          .regular,
                                    ),
                                    width5,
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Label(
                                          review["name"],
                                          fontSize: 15,
                                        ).regular,
                                        Label(kDateFormat(review["date"]),
                                                fontSize: 10)
                                            .subtitle
                                      ],
                                    )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RatingBar.builder(
                                          itemSize: 15,
                                          initialRating:
                                              parseToDouble(review["rating"]),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Kolor.primary,
                                          ),
                                          unratedColor: Colors.grey.shade300,
                                          onRatingUpdate: (value) {},
                                        ),
                                        Label(
                                          "${review["rating"]}",
                                          fontSize: 10,
                                        ).regular
                                      ],
                                    ),
                                  ],
                                ),
                                Label("\"${review["feedback"]}\"",
                                        fontSize: 13, weight: 600)
                                    .subtitle,
                              ],
                            ),
                          ),
                        )
                      ]
                    : [
                        const SizedBox(),
                      ],
                error: (error, stackTrace) => [
                  kNoData(context, subtitle: "$error"),
                ],
                loading: () => [kSmallLoading],
              ),
            ],
          ),
        );
      },
    );
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
            color: Kolor.scaffold,
            border: Border(
              bottom: BorderSide(
                color: selected ? Kolor.primary : Colors.grey.shade300,
                width: selected ? 3 : 2,
              ),
            ),
          ),
          child: Label(
            label,
            weight: selected ? 700 : 500,
            color: selected ? Kolor.primary : Kolor.fadeText,
          ).title,
        ),
      ),
    );
  }
}
