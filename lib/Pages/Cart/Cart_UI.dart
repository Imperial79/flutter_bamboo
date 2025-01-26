// ignore_for_file: unused_result

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Models/Cart/coupon_model.dart';
import 'package:flutter_bamboo/Models/address_model.dart';
import 'package:flutter_bamboo/Repository/address_repo.dart';
import 'package:flutter_bamboo/Repository/cart_repo.dart';
import 'package:flutter_bamboo/Repository/coupon_repo.dart';
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
  double totalMrp = 0;
  double totalSalePrice = 0;
  int totalItems = 0;
  Map<String, dynamic> breakdown = {
    "price": 0,
    "couponDiscount": 0,
    "discount": 0,
    "subTotal": 0,
    "totalQty": 0,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _refresh();
      },
    );
  }

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

  setAddress() async {
    final addressData = await ref.watch(addressFuture.future);
    if (ref.read(selectedAddressProvider) == null) {
      if (addressData.isNotEmpty) {
        for (AddressModel e in addressData) {
          if (e.isPrimary!) {
            ref.read(selectedAddressProvider.notifier).state = e;
            break;
          }
        }
      }
    }
  }

  calculatePriceBreakdown() async {
    try {
      // if (totalMrp == 0 || totalSalePrice == 0) {
      totalMrp = 0;
      totalSalePrice = 0;
      totalItems = 0;
      final cartData = await ref.read(cartFuture.future);
      for (var element in cartData) {
        totalMrp +=
            (parseToDouble(element["mrp"]) * int.parse("${element["qty"]}"));
        totalSalePrice += (parseToDouble(element["salePrice"]) *
            int.parse("${element["qty"]}"));

        totalItems += int.parse("${element["qty"]}");
      }
      final discount = totalMrp - totalSalePrice;
      double couponDiscount = 0;

      final coupon = ref.read(selectedCouponProvider);

      if (coupon != null) {
        if (totalSalePrice >= coupon.minPurchase) {
          couponDiscount = totalSalePrice * coupon.offPercent;
          if (couponDiscount > coupon.uptoAmount) {
            couponDiscount = coupon.uptoAmount;
          }
        } else {
          KSnackbar(context,
              message:
                  "Coupon Removed! Min. purchase must be ${kCurrencyFormat(coupon.minPurchase)}",
              error: true);
          ref.read(selectedCouponProvider.notifier).state = null;
        }
      }

      breakdown["price"] = totalMrp;
      breakdown["totalQty"] = totalItems;
      breakdown["discount"] = discount;
      breakdown["couponDiscount"] = couponDiscount;
      breakdown["subTotal"] = totalSalePrice - couponDiscount;

      setState(() {});
    } catch (e) {
      log("$e");
    }
  }

  _refresh() async {
    await ref.refresh(cartFuture.future);
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartFuture);
    final selectedAddress = ref.watch(selectedAddressProvider);
    final selectedCoupon = ref.watch(selectedCouponProvider);
    setAddress();

    calculatePriceBreakdown();

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
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
                      if (selectedAddress != null)
                        KCard(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            builder: (context) => addressModal(),
                          ),
                          radius: 10,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Label("${selectedAddress.name}",
                                            weight: 500)
                                        .regular,
                                    Label("+91 ${selectedAddress.phone}",
                                            weight: 500)
                                        .regular,
                                    Label("${selectedAddress.address} - ${selectedAddress.pincode}",
                                            weight: 600)
                                        .regular,
                                  ],
                                ),
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
                      if (selectedCoupon == null)
                        KCard(
                          onTap: () async {
                            Map<String, dynamic>? data = await context
                                .push("/cart/coupons") as Map<String, dynamic>?;
                            if (data != null) {
                              final coupon = CouponModel.fromMap(data);

                              if (breakdown["subTotal"] >= coupon.minPurchase) {
                                ref
                                    .read(selectedCouponProvider.notifier)
                                    .state = coupon;
                                KSnackbar(context,
                                    message: "Hooraay! Offer Applied!");
                              } else {
                                KSnackbar(
                                  context,
                                  message:
                                      "Oops Offer not Applied! Min. purchase must be ${kCurrencyFormat(coupon.minPurchase)}",
                                  error: true,
                                );
                              }
                            }
                          },
                          borderWidth: 1,
                          borderColor: kOpacity(kScheme.primary, .5),
                          color: kOpacity(kScheme.primaryContainer, .1),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: kOpacity(kScheme.primary, .5),
                                  size: 30,
                                ),
                                Label(
                                  "Add a coupon",
                                  color: kOpacity(kScheme.primary, .5),
                                  fontSize: 15,
                                ).regular,
                              ],
                            ),
                          ),
                        )
                      else
                        selectedCouponCard(context),
                      height10,
                      Label('Price Breakdown', fontSize: 17).title,
                      KCard(
                        child: Column(
                          spacing: 5,
                          children: [
                            _row("Price (2 Items)",
                                kCurrencyFormat(breakdown["price"])),
                            _row("Discount",
                                kCurrencyFormat(breakdown["discount"]),
                                isDiscount: true),
                            if (breakdown["couponDiscount"] != 0)
                              _row("Coupon Discount",
                                  kCurrencyFormat(breakdown["couponDiscount"]),
                                  isDiscount: true),
                            div,
                            _row("Sub-Total",
                                kCurrencyFormat(breakdown["subTotal"])),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        onPressed: () {},
                        label: "Proceed",
                        radius: 7,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  Widget addressModal() {
    return StatefulBuilder(
      builder: (context, setState) => Consumer(builder: (context, ref, _) {
        final selectedAddress = ref.watch(selectedAddressProvider);
        final addressData = ref.watch(addressFuture);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: KCard(
              radius: 25,
              padding: EdgeInsets.all(kPadding),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Label("Select Address").title),
                        TextButton(
                            onPressed: () =>
                                context.push("/profile/saved-address"),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: kScheme.primary,
                                ),
                                Label("Add", color: kScheme.primary).regular,
                              ],
                            ))
                      ],
                    ),
                    height10,
                    addressData.when(
                      data: (data) => data.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) => height10,
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => KCard(
                                  onTap: () {
                                    ref
                                        .read(selectedAddressProvider.notifier)
                                        .state = data[index];
                                    Navigator.pop(context);
                                  },
                                  borderColor: selectedAddress == data[index]
                                      ? kScheme.primary
                                      : KColor.scaffold,
                                  borderWidth:
                                      selectedAddress == data[index] ? 1 : 0,
                                  color: selectedAddress == data[index]
                                      ? kScheme.primaryContainer
                                      : KColor.scaffold,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Label(data[index].name!).regular,
                                            Label("+91 ${data[index].phone!}")
                                                .regular,
                                            Label(data[index].address!).regular,
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          : kNoData(context),
                      error: (error, stackTrace) => kNoData(context),
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget selectedCouponCard(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final selectedCoupon = ref.watch(selectedCouponProvider);
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
                    "Offer Applied! ${selectedCoupon?.description ?? ""}",
                    color: kScheme.primary,
                    weight: 600,
                    fontSize: 15,
                  ).regular,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(selectedCouponProvider.notifier).state = null,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: kScheme.primary,
              foregroundColor: KColor.scaffold,
              child: Icon(
                Icons.close,
                size: 15,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _row(String text1, String text2, {bool isDiscount = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Label(
            text1,
            weight: isDiscount ? 600 : 500,
            color: isDiscount ? StatusText.success : null,
          ).regular,
          Label((isDiscount ? " - " : "") + text2,
                  color: isDiscount ? StatusText.success : null, weight: 600)
              .regular,
        ],
      );

  Widget buildCartItem(int index, Map data) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          GestureDetector(
            onTap: () => context
                .push("/product/${data["name"]}/${data["productVariantId"]}"),
            child: CachedNetworkImage(
              imageUrl: data["images"].split("#_#")[0],
              errorWidget: (context, url, error) => KCard(
                height: 100,
                width: 100,
                radius: 10,
                child: Center(
                  child: Icon(
                    Icons.info_outline,
                    color: KColor.fadeText,
                  ),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: kRadius(10),
                  color: KColor.card,
                  image: DecorationImage(
                    image: imageProvider,
                  ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            kCurrencyFormat(data["salePrice"], symbol: ""),
                            height: 1,
                            weight: 600,
                          ).title,
                          height5,
                          Label("MRP ${kCurrencyFormat(data["mrp"])}",
                                  height: 1,
                                  weight: 600,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough)
                              .subtitle,
                        ],
                      ),
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
    );
  }
}
