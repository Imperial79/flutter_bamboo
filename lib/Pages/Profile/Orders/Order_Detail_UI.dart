// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kTextfield.dart';
import 'package:flutter_bamboo/Helper/pdf_invoice.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Repository/orderHistory_repo.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:go_router/go_router.dart';

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
  double selectedRating = 0;

  List<String> statusList = [
    "Ordered",
    "Shipped",
    "Delivered",
    // "Return Pending",
    // "Refunded",
  ];

  _refresh() async {
    await ref.refresh(orderDetailFuture(widget.orderId).future);
  }

  _generateInvoice(invoiceData) async {
    try {
      final pdfFile = await PdfInvoiceApi.generate(orderDetails: invoiceData);
      await PdfInvoiceApi.openFile(pdfFile);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderDetailFuture(widget.orderId));

    final finalData =
        orderData.hasValue && orderData.value != null ? orderData.value : null;
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
        appBar: AppBar(
          title:
              finalData != null ? Label("Order Details").regular : SizedBox(),
          actions: finalData != null
              ? [
                  IconButton(
                    icon: Icon(Icons.pause_presentation),
                    onPressed: () {
                      _generateInvoice(finalData);
                    },
                  ),
                  PopupMenuButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: kRadius(10)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {},
                        child: Label("Invoice").regular,
                      ),
                      PopupMenuItem(
                        onTap: () => context.push("/chat"),
                        child: Label("Chat with us").regular,
                      ),
                    ],
                  ),
                ]
              : null,
        ),
        body: SafeArea(
          child: orderData.when(
            data: (data) => data != null
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(kPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label("ORDER ID - ${data["shoppingOrderId"]}",
                                weight: 600, fontSize: 12)
                            .subtitle,
                        Label("ORDER DATE - ${kDateFormat(data["orderDate"], showTime: true)}",
                                weight: 600, fontSize: 12)
                            .subtitle,
                        if (data["deliveredOn"] != null)
                          Label("DELIVERED ON - ${kDateFormat(data["deliveredOn"], showTime: true)}",
                                  weight: 600, fontSize: 12)
                              .subtitle,
                        div,
                        kHeight(50),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kPadding),
                          child: EasyStepper(
                            activeStep: statusList.indexOf(data["status"]),
                            lineStyle: LineStyle(
                              lineType: LineType.normal,
                              lineWidth: 0,
                              lineSpace: 0,
                              lineLength: 100,
                              lineThickness: 3,
                              unreachedLineColor: Colors.grey.shade300,
                              activeLineColor: KColor.card,
                              defaultLineColor: KColor.border,
                              finishedLineColor: KColor.primary,
                            ),
                            fitWidth: true,
                            disableScroll: true,
                            internalPadding: 5,
                            showLoadingAnimation: false,
                            stepRadius: 8,
                            showStepBorder: false,
                            steps: List.generate(
                              statusList.length,
                              (index) => EasyStep(
                                customStep: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor:
                                        statusList.indexOf(data["status"]) >=
                                                index
                                            ? KColor.primary
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                customTitle: Label(statusList[index]).regular,
                                topTitle: index % 2 == 0,
                              ),
                            ),
                          ),
                        ),
                        height20,
                        Label("Product Details").regular,
                        div,
                        height10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(data["name"]).regular,
                                  height5,
                                  Label(data["attributeValue"], fontSize: 12)
                                      .subtitle,
                                  Label("${data["sku"]}", fontSize: 12)
                                      .subtitle,
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: KColor.card,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    data["images"].split("#_#")[0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Label(kCurrencyFormat(data["salePrice"]), fontSize: 17)
                            .regular,
                        Label("${data["qty"]} Items", fontSize: 12).subtitle,
                        height20,
                        ...shareRatings(data),
                        height20,
                        ...shippingDetails(data),
                        height20,
                        ...priceDetails(data),
                        height20,
                        ...paymentDetails(data),
                      ],
                    ),
                  )
                : kNoData(context),
            error: (error, stackTrace) => kNoData(context, subtitle: "$error"),
            loading: () => kSmallLoading,
          ),
        ),
      ),
    );
  }

  List<Widget> shippingDetails(data) => [
        Label("Shipping Details").regular,
        div,
        Label(data["shippingName"]).subtitle,
        Label(data["shippingAddress"]).subtitle,
        Label("Phone number - ${data["shippingPhone"]}").subtitle,
      ];

  List<Widget> priceDetails(data) => [
        Label("Price Details").regular,
        div,
        _row(
          "Price (${data["qty"]} Items)",
          kCurrencyFormat(
              parseToDouble(data["mrp"]) * int.parse("${data["qty"]}"),
              decimalDigits: 2),
        ),
        height5,
        _row(
          "Selling Price (${data["qty"]} Items)",
          kCurrencyFormat(data["subTotal"], decimalDigits: 2),
        ),
        height5,
        _row("Coupon Discount",
            kCurrencyFormat(data["couponDiscount"], decimalDigits: 2),
            isDiscount: true),
        height5,
        div,
        _row(
          "Net Payable",
          kCurrencyFormat(data["netPayable"], decimalDigits: 2),
        ),
      ];

  List<Widget> paymentDetails(data) => [
        Label("Payment Details").regular,
        div,
        Label("PAYMENT ID - ${data["paymentId"]}").subtitle
      ];

  List<Widget> shareRatings(data) => [
        Label("Share Ratings").regular,
        div,
        height20,
        Row(
          children: [
            Flexible(
              child: Center(
                child: RatingBar.builder(
                  initialRating: parseToDouble(data["ratings"]),
                  minRating: 1,
                  glow: false,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: Colors.grey.shade300,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: StatusText.warning,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                ),
              ),
            ),
            KButton(
              onPressed: () {},
              label: "Share",
              style: KButtonStyle.regular,
              radius: 5,
              backgroundColor: KColor.secondary,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            ),
          ],
        ),
        height20,
        KTextfield(
          hintText: "Add a review",
          maxLines: 2,
          minLines: 2,
        ).regular,
      ];

  Widget _row(
    String text1,
    String text2, {
    bool isDiscount = false,
  }) =>
      Row(
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
