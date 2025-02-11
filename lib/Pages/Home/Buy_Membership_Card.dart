// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Repository/membership_repo.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../Resources/constants.dart';

class BuyMembershipCard extends ConsumerStatefulWidget {
  final void Function(bool isLoading) loadingStatus;
  final int fees;
  const BuyMembershipCard({
    super.key,
    required this.loadingStatus,
    required this.fees,
  });

  @override
  ConsumerState<BuyMembershipCard> createState() => _BuyMembershipCardState();
}

class _BuyMembershipCardState extends ConsumerState<BuyMembershipCard> {
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
    final user = ref.read(userProvider);
    log("$user");
    if (user != null) {
      Map prefillMap = {};
      if (user.phone != null) {
        prefillMap = {'contact': user.phone};
      } else {
        prefillMap = {'email': user.email};
      }
      var options = {
        'key': dotenv.get('RAZORPAY_KEY'),
        'amount': amount,
        'name': 'NGF Organic',
        'description': 'Payment for Membership ${user.id}',
        'order_id': orderId,
        'prefill': prefillMap,
        'external': {
          'wallets': ['paytm', 'phonepe']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        rethrow;
      }
    } else {
      context.push("/login");
    }
  }

  generatePaymentOrder() async {
    try {
      widget.loadingStatus(true);

      final res = await ref.read(membershipRepo).generateOrder();

      openCheckout(res.data["paymentOrderId"], res.data["amountInPaise"]);
    } catch (error) {
      KSnackbar(context, message: "$error", error: true);
    } finally {
      widget.loadingStatus(false);
    }
  }

  verifyPayment(String paymentId) async {
    try {
      widget.loadingStatus(true);

      await ref.read(membershipRepo).verify(paymentId);
      ref.read(userProvider.notifier).update(
            (state) => state!.copyWith(isMember: true),
          );
      showDialog(
        context: context,
        builder: (context) => successDialog(),
      );
    } catch (e) {
      KSnackbar(context,
          message: "Error while verifiying payment! $e", error: true);
    } finally {
      widget.loadingStatus(false);
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Visibility(
      visible: user != null && !user.isMember,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("$kImagePath/premium-bg.jpg"),
            fit: BoxFit.cover,
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
                  Label("Membership", color: Colors.white, fontSize: 25).title,
                ],
              ),
            ),
            KButton(
              onPressed: generatePaymentOrder,
              label: "Join@${kCurrencyFormat(widget.fees)}",
              radius: 5,
              fontSize: 12,
              backgroundColor: StatusText.warning,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
          ],
        ),
      ),
    );
  }

  successDialog() {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        backgroundColor: KColor.scaffold,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 400),
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset("assets/animations/success.json", height: 200),
                    SvgPicture.asset(
                      "$kIconPath/party-popper.svg",
                      height: 150,
                    ),
                  ],
                ),
                height20,
                Label("Congratulations!", weight: 900, fontSize: 30).title,
                Label("🎉You are now a member🎉", weight: 600).regular,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
