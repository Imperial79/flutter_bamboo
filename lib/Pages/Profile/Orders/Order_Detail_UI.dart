import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_stepper/easy_stepper.dart';

class Order_Detail_UI extends ConsumerStatefulWidget {
  final String orderId;
  const Order_Detail_UI({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<Order_Detail_UI> createState() => _Order_Detail_UIState();
}

class _Order_Detail_UIState extends ConsumerState<Order_Detail_UI> {
  int activeStep = 0;

  List<String> statusList = [
    "Ordered",
    "Shipped",
    "Delivered",
    // "Return Pending",
    // "Refunded",
  ];

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("#${widget.orderId}").regular,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("ORDER ID - OD1827HK129", weight: 600, fontSize: 12)
                  .subtitle,
              div,
              kHeight(50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: EasyStepper(
                  activeStep: activeStep,
                  lineStyle: LineStyle(
                    lineType: LineType.normal,
                    lineWidth: 0,
                    lineSpace: 0,
                    lineLength: 100,
                    lineThickness: 3,
                    unreachedLineColor: Colors.grey.shade300,
                    activeLineColor: KColor.primary,
                    defaultLineColor: KColor.border,
                    finishedLineColor: kScheme.primary,
                  ),
                  fitWidth: true,
                  disableScroll: true,
                  internalPadding: 10,
                  showLoadingAnimation: false,
                  stepRadius: 8,
                  showStepBorder: false,
                  steps: statusList
                      .map(
                        (e) => EasyStep(
                          customStep: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor:
                                  activeStep >= statusList.indexOf(e)
                                      ? KColor.primary
                                      : Colors.grey.shade300,
                            ),
                          ),
                          customTitle: Label(e).regular,
                          topTitle: statusList.indexOf(e) % 2 == 0,
                        ),
                      )
                      .toList(),
                  onStepReached: (index) => setState(() => activeStep = index),
                ),
              ),
              height10,
              div,
              height10,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label("text").regular,
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    color: KColor.card,
                  ),
                ],
              ),
              Label("SKU-AS-6").subtitle,
              Label(kCurrencyFormat(252), fontSize: 17).regular,
              height20,
              Label("Shipping Details").regular,
              div,
              Label("User Name").subtitle,
              Label("A/76, Aesby More, Netaji Colony").subtitle,
              Label("Pin Code - 18129").subtitle,
              Label("Dhanbad - Bihar").subtitle,
              Label("Phone number - 1928901829").subtitle,
              height20,
              Label("Price Details").regular,
              div,
            ],
          ),
        ),
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
}
