import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../Resources/colors.dart';

class Confirmation_UI extends StatefulWidget {
  final String orderId;
  final int deliveryDays;
  final int totalItems;
  const Confirmation_UI(
      {super.key,
      required this.orderId,
      required this.deliveryDays,
      required this.totalItems});

  @override
  State<Confirmation_UI> createState() => _Confirmation_UIState();
}

class _Confirmation_UIState extends State<Confirmation_UI> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => context.go("/"),
      child: Scaffold(
        body: Stack(
          children: [
            Lottie.asset(
              "assets/animations/success.json",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            body(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: KButton(
              onPressed: () => context.go("/"),
              label: "Go Home",
              backgroundColor: kColor(context).primaryContainer,
              foregroundColor: kColor(context).onPrimaryContainer,
              style: KButtonStyle.expanded,
            ),
          ),
        ),
      ),
    );
  }

  body() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "$kIconPath/success.svg",
                height: 100,
              ),
              height20,
              Label("Thank you!", fontSize: 27, weight: 700).title,
              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label("Order ID: ", weight: 500, fontSize: 17).title,
                  Flexible(
                    child:
                        Label("#${widget.orderId}", weight: 700, fontSize: 17)
                            .title,
                  )
                ],
              ),
              height10,
              Label("Your order is placed successfully, please go to the orders page to manage status.",
                      weight: 500, fontSize: 15, textAlign: TextAlign.center)
                  .title,
              height20,
              div,
              height20,
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Badge(
                    label: Label("${widget.totalItems}").regular,
                    backgroundColor: Colors.blue,
                    child: SvgPicture.asset(
                      "$kIconPath/packing.svg",
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Label("Arriving").regular,
                        Label(DateFormat("dd, MMM yyyy").format(DateTime.now()
                                .add(Duration(days: widget.deliveryDays))))
                            .title,
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go("/profile/orders"),
                    child: Label("Track", weight: 700).regular,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
