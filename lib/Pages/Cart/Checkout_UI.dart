import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_bamboo/Repository/address_repo.dart';
import 'package:flutter_bamboo/Repository/cart_repo.dart';
import 'package:flutter_bamboo/Resources/app_config.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Components/kCard.dart';
import '../../Components/kWidgets.dart';
import '../../Resources/theme.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout_UI extends ConsumerStatefulWidget {
  final ResponseModel checkoutData;
  final String? discountCoupon;
  const Checkout_UI(
      {super.key, required this.checkoutData, this.discountCoupon});

  @override
  ConsumerState<Checkout_UI> createState() => _Checkout_UIState();
}

class _Checkout_UIState extends ConsumerState<Checkout_UI> {
  final isLoading = ValueNotifier(false);
  late Razorpay _razorpay;
  String? shoppingOrderId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    log("Payment Success: ${response.paymentId}");
    if (response.paymentId != null) {
      verifyPayment(response.paymentId!);
    } else {
      KSnackbar(context,
          message: 'Payment Error! Please try again.', error: true);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    log("Payment Error: ${response.code} - ${response.message}");
    KSnackbar(context, message: "Payment Failed!", error: true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    log("External Wallet: ${response.walletName}");
    KSnackbar(context, message: "External Wallet Selected!");
  }

  void openCheckout(String orderId, int amount) {
    final selectedAddress = ref.read(selectedAddressProvider);
    var options = {
      'key': dotenv.get('RAZORPAY_KEY'),
      'amount': amount,
      'name': 'NGF Organic',
      'description': 'Payment for Order $orderId',
      'order_id': orderId,
      'prefill': {'contact': selectedAddress!.phone},
      'external': {
        'wallets': ['paytm', 'phonepe']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log("Error: $e");
    }
  }

  generatePaymentOrder() async {
    try {
      isLoading.value = true;
      final selectedAddress = ref.read(selectedAddressProvider);
      final res = await ref.read(cartRepo).generatePayment({
        "discountCoupon": widget.discountCoupon,
        "shippingName": selectedAddress!.name,
        "shippingPhone": selectedAddress.phone,
        "shippingAddress": selectedAddress.address,
        "shippingCity": selectedAddress.city,
        "shippingPincode": selectedAddress.pincode,
        "shippingState": selectedAddress.state
      });

      if (!res.error) {
        setState(() {
          final orderId = res.data["paymentOrderId"];
          int amountInPaise = int.parse("${res.data["amountInPaise"]}");
          shoppingOrderId = "${res.data["shoppingOrderId"]}";
          openCheckout(orderId, amountInPaise);
        });
      }
    } catch (error) {
      KSnackbar(context, message: "$error", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  verifyPayment(String paymentId) async {
    try {
      isLoading.value = true;

      final res = await ref.read(cartRepo).verifyPayment(
            paymentId: paymentId,
          );

      KSnackbar(context, message: "Payment Successful!");

      if (!res.error) {
        final masterdata = widget.checkoutData.data as Map<String, dynamic>;
        context.go(
          "/cart/confirmation",
          extra: {
            "orderId": "${res.data}",
            "deliveryDays": masterdata["paymentBreakdown"]["deliveryDays"],
            "totalItems": masterdata.length
          },
        );
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final masterdata = widget.checkoutData.data as Map<String, dynamic>;
    final paymentBreakdown = masterdata["paymentBreakdown"];

    return KScaffold(
      isLoading: isLoading,
      appBar: KAppBar(
        context,
        title: "Checkout",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("Shipping / Billing Address", fontSize: 17).title,
              addressCard(),
              height10,
              Label("Products (${masterdata["checkoutProducts"].length})",
                      fontSize: 17)
                  .title,
              KCard(
                borderWidth: 1,
                color: KColor.scaffold,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      productCard(masterdata["checkoutProducts"][index]),
                  separatorBuilder: (context, index) => Divider(height: 30),
                  itemCount: masterdata["checkoutProducts"].length,
                ),
              ),
              Label(
                "Your products will be delivered by ${DateFormat("dd, MMM yyyy").format(DateTime.now().add(Duration(days: paymentBreakdown["deliveryDays"])))}.",
                color: StatusText.success,
                fontSize: 15,
              ).regular,
              height10,
              Label('Price Breakdown', fontSize: 17).title,
              KCard(
                child: Column(
                  spacing: 5,
                  children: [
                    _row("Price (${paymentBreakdown["totalProducts"]} Items)",
                        kCurrencyFormat(paymentBreakdown["totalMrp"])),
                    _row("Discount",
                        kCurrencyFormat(paymentBreakdown["discount"]),
                        isDiscount: true),
                    _row("Sub-Total",
                        kCurrencyFormat(paymentBreakdown["subTotal"])),
                    if (parseToDouble(paymentBreakdown["couponDiscount"]) != 0)
                      _row("Coupon Discount",
                          kCurrencyFormat(paymentBreakdown["couponDiscount"]),
                          isDiscount: true),
                    _row(
                        "Delivery Charges",
                        paymentBreakdown["deliveryCharges"] == 0
                            ? "FREE"
                            : kCurrencyFormat(
                                paymentBreakdown["deliveryCharges"])),
                    div,
                    _row("Total",
                        kCurrencyFormat(paymentBreakdown["netPayable"])),
                  ],
                ),
              ),
              height20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: KColor.fadeText,
                      size: 30,
                    ),
                    Expanded(
                      child: Label(
                              "Safe and Secure Payments. Easy returns. 100% Authentic products.",
                              color: KColor.fadeText)
                          .regular,
                    ),
                  ],
                ),
              ),
              height20,
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: KColor.fadeText,
                    fontVariations: [FontVariation.weight(600)],
                  ),
                  children: [
                    const TextSpan(
                        text:
                            "By proceeding with the order, you agree that you are above 18 years of age and you agree to NGF Organic's "),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await launchUrlString(termsConditionLink);
                        },
                      text: "Terms & Conditions",
                      style: TextStyle(
                        fontVariations: [FontVariation.weight(700)],
                        color: kScheme.primary,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await launchUrlString(privacyPolicyLink);
                        },
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontVariations: [FontVariation.weight(700)],
                        color: kScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (paymentBreakdown["couponDiscount"] +
                  paymentBreakdown["discount"] >
              0)
            KCard(
              color: const Color(0xFFDAEEFF),
              radius: 0,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: 5),
              child: Row(
                spacing: 10,
                children: [
                  Label(
                    '🎉',
                    color: Colors.blue.shade900,
                  ).regular,
                  Expanded(
                    child: Label(
                      "You save a total of ${kCurrencyFormat(paymentBreakdown["couponDiscount"] + paymentBreakdown["discount"])} on this order!",
                      color: Colors.blue.shade900,
                    ).regular,
                  ),
                ],
              ),
            ),
          KCard(
            color: KColor.card,
            radius: 0,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(kCurrencyFormat(paymentBreakdown["totalMrp"]),
                                decoration: TextDecoration.lineThrough)
                            .subtitle,
                        Label(
                          kCurrencyFormat(paymentBreakdown["netPayable"]),
                        ).title
                      ],
                    ),
                  ),
                  KButton(
                    onPressed: generatePaymentOrder,
                    label: "Proceed",
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    radius: 5,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  productCard(Map<String, dynamic> productData) {
    return Row(
      spacing: 15,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: productData["images"].split("#_#")[0],
              imageBuilder: (context, imageProvider) => Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: kRadius(10),
                  color: KColor.card,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Label("QTY: ${productData["qty"]}", fontSize: 12).regular
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Label(productData["name"], maxLines: 1, weight: 600, fontSize: 13)
                  .regular,
              // height5,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kAmount(productData["salePrice"], fontSize: 20),
                        height5,
                        Label("MRP ${kCurrencyFormat(productData["mrp"])}",
                                height: 1,
                                weight: 500,
                                fontSize: 17,
                                decoration: TextDecoration.lineThrough)
                            .subtitle,
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber.shade800,
                        size: 17,
                      ),
                      Label(productData["totalRatings"]).regular,
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  addressCard() {
    return Consumer(
      builder: (context, ref, child) {
        final selectedAddress = ref.watch(selectedAddressProvider);
        return KCard(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(selectedAddress!.name!).regular,
              Label("+91 ${selectedAddress.phone!}").subtitle,
              Label("${selectedAddress.address!} - ${selectedAddress.pincode}")
                  .subtitle,
              Label("${selectedAddress.city!}, ${selectedAddress.state}")
                  .subtitle,
            ],
          ),
        );
      },
    );
  }
}
