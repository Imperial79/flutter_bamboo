// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kTextfield.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Repository/cart_repo.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../Resources/theme.dart';

class Cart_UI extends ConsumerStatefulWidget {
  const Cart_UI({super.key});

  @override
  ConsumerState<Cart_UI> createState() => _Cart_UIState();
}

class _Cart_UIState extends ConsumerState<Cart_UI> {
  final isLoading = ValueNotifier(false);

  updateCart(int variantId, int qty, int index) async {
    try {
      isLoading.value = true;
      final res = await ref.read(cartRepo).updateCart({
        "productVariantId": variantId,
        "qty": qty,
      });

      if (!res.error) {
        await ref.refresh(cartFuture.future);
      }
      KSnackbar(context, message: res.message, error: res.error);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  deleteItem(int productVariantId) async {
    try {
      isLoading.value = true;
      final res = await ref.read(cartRepo).deleteCartItem(productVariantId);
      if (!res.error) {
        await ref.refresh(cartFuture.future);
      }
      KSnackbar(context, message: res.message, error: res.error);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartFuture);
    return KScaffold(
      isLoading: isLoading,
      appBar: AppBar(
        title: Label("Cart").regular,
        centerTitle: true,
      ),
      body: SafeArea(
          child: cartData.when(
        data: (data) => data.isNotEmpty
            ? SingleChildScrollView(
                padding: EdgeInsets.all(kPadding),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label("Shipping Address", fontSize: 17).title,
                    KCard(
                      radius: 10,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Label("ABC Street, Durgapur Bazaar - 713201",
                                    weight: 600)
                                .regular,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: KColor.fadeText,
                          ),
                        ],
                      ),
                    ),
                    height10,
                    Label("Products Summary", fontSize: 17).title,
                    cartData.when(
                      data: (data) => Column(
                        spacing: 15,
                        children: data
                            .map(
                              (e) => buildCartItem(data.indexOf(e), e),
                            )
                            .toList(),
                      ),
                      error: (error, stackTrace) => kNoData(context),
                      loading: () => CircularProgressIndicator(),
                    ),
                    height10,
                    Label("Coupons & Promotional", fontSize: 17).title,
                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: KTextfield(
                            hintText: "Enter Coupon Code",
                            textCapitalization: TextCapitalization.characters,
                          ).regular,
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Label(
                        "Browse Coupons",
                        weight: 600,
                        color: kScheme.tertiary,
                      ).regular,
                    ),
                    selectedCoupon(context),
                    height10,
                    Label('Price Breakdown', fontSize: 17).title,
                    KCard(
                      child: Column(
                        spacing: 5,
                        children: [
                          _row("Price (2 Items)", "₹ 200"),
                          _row("Discount", "-₹ 20", isDiscount: true),
                          _row("Coupon Discount", "-₹ 20", isDiscount: true),
                          div,
                          _row("Sub-Total", "₹ 230"),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kNoData(context,
                      title: "Cart is empty!",
                      subtitle: "Add products to cart."),
                ],
              ),
        error: (error, stackTrace) => kNoData(context),
        loading: () => CircularProgressIndicator(),
      )),
      bottomNavigationBar: cartData.hasValue && cartData.value!.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: KColor.card,
                  border: Border(top: BorderSide(color: KColor.border))),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("Sub-Total", weight: 600).regular,
                          height5,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label("₹", fontSize: 20, height: 1.2).regular,
                              Expanded(
                                child: Label(
                                  "230.00",
                                  fontSize: 25,
                                  height: 1,
                                  weight: 600,
                                ).title,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    KButton(
                      onPressed: () {},
                      label: "Proceed",
                      radius: 10,
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Widget selectedCoupon(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        KCard(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: kScheme.primaryContainer,
          child: Row(
            spacing: 15,
            children: [
              Icon(
                Icons.local_offer,
                color: kScheme.primary,
              ),
              Expanded(
                child: Label(
                  "Offer Applied! Get extra 20% OFF on first order.",
                  color: kScheme.primary,
                  weight: 600,
                  fontSize: 15,
                ).regular,
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 12,
          backgroundColor: kScheme.primary,
          foregroundColor: KColor.scaffold,
          child: Icon(
            Icons.close,
            size: 15,
          ),
        ),
      ],
    );
  }

  Widget _row(String text1, String text2, {bool isDiscount = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Label(text1, weight: 500).regular,
          Label(text2,
                  color: isDiscount ? StatusText.success : null, weight: 600)
              .regular,
        ],
      );

  Widget buildCartItem(int index, Map data) {
    return InkWell(
      onTap: () =>
          context.push("/product/${data["name"]}/${data["productVariantId"]}"),
      borderRadius: kRadius(10),
      child: Ink(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: kRadius(10),
                color: KColor.card,
                image: DecorationImage(
                  image: NetworkImage(
                    data["images"].split("#_#")[0],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Label(data["name"], maxLines: 2, weight: 600, fontSize: 13)
                      .regular,
                  height5,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label("₹", fontSize: 12, height: 1.2).regular,
                      Expanded(
                        child: Label(
                          kCurrencyFormat(data["salePrice"], symbol: ""),
                          height: 1,
                          weight: 600,
                        ).title,
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          StarRating(
                            mainAxisAlignment: MainAxisAlignment.end,
                            rating: parseToDouble(data["totalRatings"]),
                            size: 15,
                            color: Colors.amber.shade800,
                          ),
                          Label(
                            "(${thoundsandToK(data["totalReviews"])})",
                            weight: 500,
                          ).regular
                        ],
                      )
                    ],
                  ),
                  height5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      KCard(
                        borderWidth: 1,
                        radius: 7,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: DropdownButton(
                          isDense: true,
                          value: int.parse("${data["qty"]}"),
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
                            updateCart(data["productVariantId"], value!, index);
                          },
                        ),
                      ),
                      KCard(
                        onTap: () => deleteItem(data["productVariantId"]),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        radius: 7,
                        color: kScheme.errorContainer,
                        child: Icon(
                          Icons.delete,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
