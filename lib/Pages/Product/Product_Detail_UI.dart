import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kCarousel.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Helper/appLink.dart';
import 'package:flutter_bamboo/Helper/data.dart';
import 'package:flutter_bamboo/Models/Cart_Item_Model.dart';
import 'package:flutter_bamboo/Models/Product_Detail_Model.dart';
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
import 'package:share_plus/share_plus.dart';

import '../../Models/User_Model.dart';
import '../../Resources/theme.dart';

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
  final isLoading = ValueNotifier(false);

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
                                color: LColor.fadeText,
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
                                      color: LColor.primary,
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

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productDetailsFuture(widget.id));
    final cartData = ref.watch(cartProvider);
    return KScaffold(
      // isLoading: isLoading,
      appBar: productData.hasValue && productData.value != null
          ? AppBar(
              leading: IconButton(
                  onPressed: () => context.go("/"),
                  icon: Icon(Icons.arrow_back)),
              actions: [
                IconButton(
                  onPressed: () {
                    String productLink = createProductPath(
                        productId: productData.value!.id,
                        referCode: "ABC12817");
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
                IconButton(
                  onPressed: () => context.push("/cart"),
                  icon: Badge(
                    isLabelVisible: cartData.isNotEmpty,
                    offset: Offset(10, -10),
                    label: Label("${cartData.length}", fontSize: 10).regular,
                    child: SvgPicture.asset(
                      "$kIconPath/shopping-bag.svg",
                      height: 22,
                      colorFilter: kSvgColor(LColor.fadeText),
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
                  padding: EdgeInsets.all(kPadding),
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
                            color: LColor.fadeText,
                          ),
                          Label(
                            data.category,
                            fontSize: 15,
                            weight: 600,
                            color: LColor.fadeText,
                          ).regular,
                        ],
                      ),
                      height5,
                      Label(data.name, weight: 700, fontSize: 17, height: 1.3)
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
                              color: LColor.fadeText,
                            ).title,
                          ),
                        ],
                      ),
                      height20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("₹", fontSize: 20, height: 1.2).regular,
                          Flexible(
                            child: Label(
                              kCurrencyFormat(
                                data.product_variants[selectedVariant]
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
                            "-${calculateDiscount(data.product_variants[selectedVariant]["mrp"], data.product_variants[selectedVariant]["salePrice"])}%",
                            fontSize: 20,
                            height: 1,
                            weight: 500,
                            color: kScheme.error,
                          ).title,
                        ],
                      ),
                      height5,
                      Label(
                        "MRP ${kCurrencyFormat(data.product_variants[selectedVariant]["mrp"])}",
                        weight: 600,
                        color: LColor.fadeText,
                        decoration: TextDecoration.lineThrough,
                      ).regular,
                      Label("Inclusive of all taxes",
                              color: LColor.fadeText, weight: 600)
                          .subtitle,
                      height20,
                      Row(
                        spacing: 5,
                        children: [
                          Label("Variant:", fontSize: 16, weight: 600).regular,
                          Flexible(
                            child: Label(
                              data.product_variants[selectedVariant]
                                  ["attributeValue"],
                              fontSize: 16,
                              weight: 700,
                            ).regular,
                          ),
                        ],
                      ),
                      height5,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8,
                          children: List.generate(
                            data.product_variants.length,
                            (index) => _variantCard(
                              index: index,
                              label: data.product_variants[index]
                                  ["attributeValue"],
                              amount: kCurrencyFormat(
                                data.product_variants[index]["salePrice"],
                              ),
                              mrp: kCurrencyFormat(
                                data.product_variants[index]["mrp"],
                                symbol: "MRP ",
                              ),
                            ),
                          ),
                        ),
                      ),
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
          ? footer(productData.value!)
          : null,
    );
  }

  Widget footer(ProductDetailModel product) {
    return Consumer(
      builder: (context, ref, child) {
        final cartData = ref.watch(cartProvider);
        final inCart = cartData.any((item) => item.productId == product.id);
        final user = ref.watch(userProvider);
        return Container(
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
                        kCurrencyFormat(
                          product.product_variants[selectedVariant]
                              ["salePrice"],
                          symbol: "INR ",
                        ),
                        weight: 700,
                        fontSize: 25,
                        color: LColor.secondary,
                      ).title,
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!inCart) {
                      KSnackbar(
                        context,
                        message: "Product added to cart.",
                      );
                      ref.read(cartProvider.notifier).addItem(CartItemModel(
                            quantity: 1,
                            productId: product.id,
                          ));
                    }
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        if (!inCart)
                          SvgPicture.asset(
                            "$kIconPath/shopping-bag.svg",
                            height: 20,
                            colorFilter: kSvgColor(Colors.white),
                          ),
                        if (cartData.isNotEmpty && !inCart)
                          Label(
                            "${cartData.length}",
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
                      color: LColor.secondary,
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
      borderColor: selected ? kScheme.primary : LColor.card,
      color: selected ? kOpacity(kScheme.primaryContainer, .7) : LColor.card,
      borderWidth: 1.5,
      radius: 10,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Label(label, fontSize: 17, weight: 700, maxLines: 1)
                    .regular,
              ),
              KCard(
                borderWidth: 2,
                color: kOpacity(Colors.white, .8),
                radius: 5,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Label(
                  amount,
                  fontSize: 15,
                  weight: 700,
                ).regular,
              ),
            ],
          ),
          Label(mrp,
                  decoration: TextDecoration.lineThrough,
                  color: LColor.fadeText)
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
            color: LColor.scaffold,
            border: Border(
              bottom: BorderSide(
                color: selected ? LColor.primary : Colors.grey.shade300,
                width: selected ? 3 : 2,
              ),
            ),
          ),
          child: Label(
            label,
            weight: selected ? 700 : 500,
            color: selected ? LColor.primary : LColor.fadeText,
          ).title,
        ),
      ),
    );
  }
}
