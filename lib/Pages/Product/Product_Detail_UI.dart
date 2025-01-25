// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kCarousel.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Helper/data.dart';
import 'package:flutter_bamboo/Helper/share_product.dart';
import 'package:flutter_bamboo/Models/Product_Detail_Model.dart';
import 'package:flutter_bamboo/Models/Product_Variant_Model.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
import 'package:flutter_bamboo/Repository/cart_repo.dart';
import 'package:flutter_bamboo/Repository/product_repo.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../Models/User_Model.dart';
import '../../Resources/theme.dart';

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
  // int selectedVariant = -1;
  bool showLess = false;
  final isLoading = ValueNotifier(false);
  int selectedQty = 1;

  ProductVariantModel variant = ProductVariantModel.fromMap({});

  addToCart(int variantId) async {
    try {
      isLoading.value = true;
      final res = await ref.read(cartRepo).updateCart({
        "productVariantId": variantId,
        "qty": selectedQty,
      });
      if (!res.error) {
        await ref.refresh(cartFuture.future);
      }
      KSnackbar(
        context,
        message: res.message,
        error: res.error,
      );
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  _signInWithGoogle() async {
    try {
      isLoading.value = true;
      final res = await ref.read(authRepository).signInWithGoogle(ref);

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
        Navigator.pop(context);
      } else {
        KSnackbar(context, message: res.message, error: res.error);
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  buyNow(user) {
    if (user != null) {
    } else {
      // context.push("/login");
      showModalBottomSheet(
        context: context,
        isDismissible: !isLoading.value,
        builder: (context) => loginModal(),
      );
    }
  }

  shareProduct(ProductDetailModel product) async {
    try {
      isLoading.value = true;
      await ProductHelper().shareProduct(
        product,
        variantId: variant.id,
      );
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productDetailsFuture(widget.id));
    // final cartData = ref.watch(cartProvider);
    final cartData = ref.watch(cartFuture);

    productData.whenData(
      (value) {
        if (value != null && variant.id == -1) {
          variant = ProductVariantModel.fromMap(value.product_variants[0]);
          // selectedVariant = value.product_variants
          //     .indexWhere((item) => item["sku"] == widget.sku);
          // if (selectedVariant == -1) {
          //   selectedVariant = 0;
          // }
        }
      },
    );
    return KScaffold(
      isLoading: isLoading,
      appBar: productData.hasValue && productData.value != null
          ? AppBar(
              leading: IconButton(
                  onPressed: () => context.go("/"),
                  icon: Icon(Icons.arrow_back)),
              actions: [
                IconButton(
                  onPressed: () => shareProduct(productData.value!),
                  icon: SvgPicture.asset(
                    "$kIconPath/share.svg",
                    height: 22,
                  ),
                ),
                width10,
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
                ),
                width10,
              ],
            )
          : null,
      body: SafeArea(
        child: productData.when(
          data: (data) => data != null
              ? SingleChildScrollView(
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
                              images: data.images,
                              height: 300,
                            ),
                            height20,
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  kCatgeoryMap[data.category] ?? Icons.apps,
                                  size: 20,
                                  color: KColor.fadeText,
                                ),
                                Label(
                                  data.category,
                                  fontSize: 15,
                                  weight: 600,
                                  color: KColor.fadeText,
                                ).regular,
                              ],
                            ),
                            height5,
                            Label(data.name,
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
                                    "${data.totalRatings} Ratings • ${thoundsandToK(data.totalReviews)} Reviews • ${thoundsandToK(data.totalSell)} Sold",
                                    weight: 500,
                                    fontSize: 15,
                                    color: KColor.fadeText,
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
                                            variant.salePrice,
                                            symbol: "",
                                          ),
                                          fontSize: 30,
                                          height: 1,
                                          weight: 600,
                                        ).title,
                                      ),
                                      width10,
                                      Label(
                                        "-${calculateDiscount(variant.mrp, variant.salePrice)}%",
                                        fontSize: 20,
                                        height: 1,
                                        weight: 500,
                                        color: kScheme.error,
                                      ).title,
                                    ],
                                  ),
                                ),
                                KCard(
                                  borderWidth: 1,
                                  radius: 10,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: DropdownButton(
                                    isDense: true,
                                    value: selectedQty,
                                    icon: Icon(
                                      Icons.inventory,
                                      size: 15,
                                    ),
                                    menuMaxHeight: 300,
                                    borderRadius: kRadius(10),
                                    elevation: 1,
                                    underline: SizedBox(),
                                    items: List.generate(
                                      9,
                                      (index) => DropdownMenuItem(
                                          value: index + 1,
                                          child: Label("${index + 1}").regular),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedQty = value!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            height5,
                            Label(
                              "MRP ${kCurrencyFormat(variant.mrp)}",
                              weight: 600,
                              color: KColor.fadeText,
                              decoration: TextDecoration.lineThrough,
                            ).regular,
                            Label("Inclusive of all taxes",
                                    color: KColor.fadeText, weight: 600)
                                .subtitle,
                            height20,
                            Row(
                              spacing: 5,
                              children: [
                                Label("Variant:", fontSize: 16, weight: 600)
                                    .regular,
                                Flexible(
                                  child: variant.attributeType == "Color"
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Color(int.parse(
                                              variant.attributeValue
                                                  .replaceFirst('#', '0xff'))),
                                        )
                                      : Label(
                                          variant.attributeValue,
                                          fontSize: 16,
                                          weight: 700,
                                        ).regular,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      height5,
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: kPadding),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8,
                          children: List.generate(data.product_variants.length,
                              (index) {
                            log("${data.product_variants[index]}");
                            return _variantCard(
                              ProductVariantModel.fromMap(
                                  data.product_variants[index]),
                              // index: index,
                              // label: data.product_variants[index]
                              //     ["attributeValue"],
                              // amount: kCurrencyFormat(
                              //   data.product_variants[index]["salePrice"],
                              // ),
                              // mrp: kCurrencyFormat(
                              //   data.product_variants[index]["mrp"],
                              //   symbol: "MRP ",
                              // ),
                              // type: data.product_variants[index]
                              //     ["attributeType"],
                            );
                          }),
                        ),
                      ),

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
                              ...aboutItemTab(data)
                            else
                              ...reviewsTab(),
                          ],
                        ),
                      )
                      // height20,
                      // Label(
                      //   "Products you may like",
                      // ).regular,
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     spacing: 10,
                      //     children: [
                      //       // ProductPreviewCard(
                      //       //   cardWidth: 200,
                      //       // ),
                      //       // ProductPreviewCard(
                      //       //   cardWidth: 200,
                      //       // ),
                      //       // ProductPreviewCard(
                      //       //   cardWidth: 200,
                      //       // ),
                      //       // ProductPreviewCard(
                      //       //   cardWidth: 200,
                      //       // ),
                      //       // ProductPreviewCard(
                      //       //   cardWidth: 200,
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              : kNoData(context),
          error: (error, stackTrace) => kNoData(context),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: productData.hasValue && productData.value != null
          ? variant.stock == 0
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

  loginModal() {
    return StatefulBuilder(builder: (context, setState) {
      return ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            return SingleChildScrollView(
              child: KCard(
                width: double.infinity,
                padding: EdgeInsets.all(kPadding),
                radius: 20,
                child: SafeArea(
                  child: !loading
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: KCard(
                                height: 7,
                                width: 50,
                                radius: 100,
                                color: KColor.fadeText,
                              ),
                            ),
                            height20,
                            Label("Login to continue").title,
                            Label(
                              "Please login to order products and track your orders.",
                              fontSize: 16,
                            ).subtitle,
                            height20,
                            googleLoginButton(onPressed: _signInWithGoogle),
                          ],
                        )
                      : Center(
                          child: Column(
                            children: [
                              Label("Logging in").title,
                              height20,
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: CircularProgressIndicator(
                                      color: KColor.primary,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "$kIconPath/glogo.svg",
                                    height: 50,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            );
          });
    });
  }

  Widget footer(ProductDetailModel product, List cart) {
    return Consumer(
      builder: (context, ref, child) {
        final inCart =
            cart.any((item) => item["productVariantId"] == product.id);
        final user = ref.watch(userProvider);
        return Container(
          padding: EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            color: KColor.scaffold,
            boxShadow: [
              BoxShadow(
                color: kOpacity(KColor.secondary, .1),
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
                        kCurrencyFormat(
                          variant.salePrice,
                          symbol: "INR ",
                        ),
                        weight: 700,
                        fontSize: 25,
                        color: KColor.secondary,
                      ).title,
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!inCart) {
                      addToCart(variant.id);
                    } else {
                      context.push("/cart");
                    }
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: KColor.primary,
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
                    height: 55,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    decoration: BoxDecoration(
                      color: KColor.secondary,
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

  Widget _variantCard(ProductVariantModel data
      // required int index,
      // required String label,
      // required String amount,
      // required String mrp,
      // required String type,

      ) {
    bool selected = variant == data;
    bool isColor = data.attributeType == "Color";
    return KCard(
      onTap: () => setState(() {
        variant = data;
      }),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderColor: selected ? kScheme.primary : KColor.card,
      color: selected ? kOpacity(kScheme.primaryContainer, .7) : KColor.card,
      borderWidth: 1.5,
      radius: 10,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Flexible(
                child: isColor
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(int.parse(
                            data.attributeValue.replaceFirst('#', '0xff'))),
                      )
                    : Label(data.attributeValue,
                            fontSize: 17, weight: 700, maxLines: 1)
                        .regular,
              ),
              KCard(
                borderWidth: 2,
                color: kOpacity(Colors.white, .8),
                radius: 5,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Label(
                  kCurrencyFormat(data.salePrice),
                  fontSize: 12,
                ).regular,
              ),
            ],
          ),
          Label(kCurrencyFormat(data.mrp),
                  decoration: TextDecoration.lineThrough,
                  color: KColor.fadeText)
              .regular,
        ],
      ),
    );
  }

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
                    color: kScheme.primary),
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
          Label("4.9", fontSize: 50, height: 1, weight: 700).title,
          Label("/ 5.0").title,
        ],
      ),
      StarRating(
        rating: 4.9,
        allowHalfRating: false,
        color: Colors.amber.shade800,
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
      ).regular,
      height15,
      KCard(
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
                ),
                width5,
                Expanded(
                    child: Label(
                  "User N***e",
                  fontSize: 15,
                ).regular),
                Icon(
                  Icons.star,
                  color: Colors.amber.shade700,
                ),
                Label(
                  "5.0",
                  fontSize: 15,
                ).regular
              ],
            ),
            Label("\"The product is more than my expectations\"",
                    fontSize: 13, weight: 600)
                .subtitle,
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
            color: KColor.scaffold,
            border: Border(
              bottom: BorderSide(
                color: selected ? KColor.primary : Colors.grey.shade300,
                width: selected ? 3 : 2,
              ),
            ),
          ),
          child: Label(
            label,
            weight: selected ? 700 : 500,
            color: selected ? KColor.primary : KColor.fadeText,
          ).title,
        ),
      ),
    );
  }
}
