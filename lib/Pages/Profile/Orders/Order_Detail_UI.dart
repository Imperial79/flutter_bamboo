// ignore_for_file: unused_result

import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kTextfield.dart';
import 'package:ngf_organic/Helper/pdf_invoice.dart';
import 'package:ngf_organic/Models/order_detail_model.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Repository/orderHistory_repo.dart';
import 'package:ngf_organic/Resources/app-data.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:go_router/go_router.dart';

class Order_Detail_UI extends ConsumerStatefulWidget {
  final String orderedItemId;
  const Order_Detail_UI({
    super.key,
    required this.orderedItemId,
  });

  @override
  ConsumerState<Order_Detail_UI> createState() => _Order_Detail_UIState();
}

class _Order_Detail_UIState extends ConsumerState<Order_Detail_UI> {
  double selectedRating = 0;
  final isLoading = ValueNotifier(false);
  final feedback = TextEditingController();
  List<String> selectedReasons = [];

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  List<String> statusList = [
    "Ordered",
    "Shipped",
    "Delivered",
  ];

  List<String> returnStatusList = [
    "Return Pending",
    "Refunded",
  ];

  _shareRatings() async {
    try {
      isLoading.value = true;

      final res = await ref.read(orderHistoryRepo).shareRatings(
            orderedItemId: widget.orderedItemId,
            rate: selectedRating,
            feedback: feedback.text,
          );

      if (!res.error) _refresh();

      KSnackbar(context, message: res.message, error: res.error);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  _refresh() async {
    await ref.refresh(orderDetailFuture(widget.orderedItemId).future);
  }

  _generateInvoice(invoiceData) async {
    try {
      final pdfFile = await PdfInvoiceApi.generate(orderDetails: invoiceData);
      await PdfInvoiceApi.openFile(pdfFile);
    } catch (e) {
      KSnackbar(context,
          message: "Error while generating invoice! $e", error: true);
    }
  }

  returnItem(int orderedItemId) async {
    try {
      isLoading.value = true;
      Navigator.pop(context);
      final res = await ref.read(orderHistoryRepo).requestReturn(
            orderedItemId: orderedItemId,
            returnReason: selectedReasons.join("\n"),
          );
      selectedReasons.clear();
      _refresh();
      KSnackbar(context, res: res);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderDetailFuture(widget.orderedItemId));

    final finalData =
        orderData.hasValue && orderData.value != null ? orderData.value : null;
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
        isLoading: isLoading,
        appBar: KAppBar(
          context,
          title: "Order Details",
          actions: finalData != null
              ? [
                  PopupMenuButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: kRadius(10)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          _generateInvoice(finalData);
                        },
                        enabled: finalData.status == "Delivered",
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
                        Label("ORDER ID - ${data.shoppingOrderId}",
                                weight: 600, fontSize: 12)
                            .subtitle,
                        Label("ORDER DATE - ${kDateFormat(data.orderDate, showTime: true)}",
                                weight: 600, fontSize: 12)
                            .subtitle,
                        if (data.deliveredOn != null)
                          Label("DELIVERED ON - ${kDateFormat(data.deliveredOn ?? "NA", showTime: true)}",
                                  weight: 600, fontSize: 12)
                              .subtitle,
                        div,
                        kHeight(50),
                        _stepper(data.status),
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
                                  Label(data.name).regular,
                                  height5,
                                  Label(data.attributeValue, fontSize: 12)
                                      .subtitle,
                                  Label(data.sku, fontSize: 12).subtitle,
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.push(
                                  "/product/abc/${data.productId}?sku=${data.sku}"),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Kolor.card,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      data.images[0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Label(kCurrencyFormat(data.salePrice), fontSize: 17)
                            .regular,
                        Label("${data.qty} Items", fontSize: 12).subtitle,
                        if (["Delivered", "Return Pending", "Refunded"]
                            .contains(data.status)) ...[
                          height20,
                          ratingsAndReview(data)
                        ],
                        height20,
                        ...shippingDetails(data),
                        height20,
                        ...priceDetails(data),
                        height20,
                        ...paymentDetails(data),
                        if (data.status == "Delivered" &&
                            data.deliveredOn != null &&
                            DateTime.now().isBefore(
                                DateTime.parse(data.deliveredOn!)
                                    .add(Duration(days: data.returnDays)))) ...[
                          height20,
                          ...returnDetails(data),
                        ]
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

  Widget _stepper(String status) {
    bool isReturn = ["Return Pending", "Refunded"].contains(status);
    final statusList0 = isReturn ? returnStatusList : statusList;
    final color0 = isReturn ? StatusText.warning : Kolor.primary;
    return EasyStepper(
      enableStepTapping: false,
      activeStep: statusList0.indexOf(status),
      lineStyle: LineStyle(
        lineType: LineType.normal,
        lineWidth: 0,
        lineSpace: 0,
        lineLength: 140,
        lineThickness: 3,
        unreachedLineColor: Kolor.card,
        activeLineColor: Kolor.card,
        defaultLineColor: Kolor.border,
        finishedLineColor: color0,
      ),
      finishedStepBackgroundColor: Colors.white,
      activeStepBackgroundColor: kColor(context).tertiary,
      fitWidth: true,
      disableScroll: true,
      internalPadding: 5,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      steps: List.generate(statusList0.length, (index) {
        bool active = statusList0.indexOf(status) == index;
        return EasyStep(
          customStep: CircleAvatar(
            radius: active ? 20 : 5,
            backgroundColor: statusList0.indexOf(status) >= index
                ? color0
                : Colors.grey.shade300,
          ),
          customTitle: Label(
            statusList0[index],
            fontSize: 12,
            textAlign: TextAlign.center,
          ).regular,
          topTitle: index % 2 == 0,
        );
      }),
    );
  }

  List<Widget> shippingDetails(OrderDetailModel data) => [
        Label("Shipping Details").regular,
        div,
        Label(data.shippingName).subtitle,
        Label(data.shippingAddress).subtitle,
        Label("Contact - +91 ${data.shippingPhone}").subtitle,
      ];

  List<Widget> priceDetails(OrderDetailModel data) => [
        Label("Price Details").regular,
        div,
        _row(
          "Price (${data.qty} Items)",
          kCurrencyFormat(parseToDouble(data.mrp) * int.parse("${data.qty}"),
              decimalDigits: 2),
        ),
        height5,
        _row(
          "Selling Price (${data.qty} Items)",
          kCurrencyFormat(data.subTotal, decimalDigits: 2),
        ),
        height5,
        _row(
          "Delivery Charges",
          kCurrencyFormat(data.deliveryCharges, decimalDigits: 2),
        ),
        height5,
        _row("Coupon Discount",
            kCurrencyFormat(data.couponDiscount, decimalDigits: 2),
            isDiscount: true),
        height5,
        div,
        _row(
          "Net Payable",
          kCurrencyFormat(data.netPayable, decimalDigits: 2),
        ),
      ];

  List<Widget> paymentDetails(OrderDetailModel data) => [
        Label("Payment Details").regular,
        div,
        Label("PAYMENT ID - ${data.paymentId}").subtitle
      ];

  List<Widget> returnDetails(OrderDetailModel data) => [
        Label("Want to request return/replacement ?").regular,
        div,
        Label("Returnable by", fontSize: 12, weight: 500).regular,
        Label(
          kDateFormat(DateTime.parse(data.deliveredOn!)
              .add(Duration(days: data.returnDays))
              .toString()),
          fontSize: 15,
          weight: 700,
        ).regular,
        height10,
        KButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Kolor.scaffold,
                builder: (context) => returnModal(data));
          },
          radius: 10,
          buttonWidth: double.infinity,
          style: KButtonStyle.outlined,
          backgroundColor: Kolor.scaffold,
          foregroundColor: Kolor.primary,
          label: "Return/Replace Items",
        )
      ];

  Widget returnModal(OrderDetailModel data) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.all(kPadding).copyWith(bottom: 0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("Select a reason").title,
                          Label("You can select multiple reasons that match your concerns.")
                              .subtitle,
                        ],
                      ),
                    ),
                  ],
                ),
                height15,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: returnReasons
                          .map(
                            (e) => Row(
                              spacing: 10,
                              children: [
                                Checkbox(
                                  value: selectedReasons.any(
                                    (element) => element == e,
                                  ),
                                  onChanged: (value) {
                                    if (value!) {
                                      setState(() {
                                        selectedReasons.add(e);
                                      });
                                    } else {
                                      setState(() {
                                        selectedReasons.remove(e);
                                      });
                                    }
                                  },
                                ),
                                Expanded(child: Label(e).regular)
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                height15,
                KButton(
                  onPressed: () => returnItem(data.id),
                  label: "Submit Request",
                  radius: 5,
                  buttonWidth: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ratingsAndReview(OrderDetailModel data) =>
      Consumer(builder: (context, ref, child) {
        final user = ref.watch(userProvider)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label("Share Ratings").regular,
            div,
            if (parseToDouble(data.rating) > 0)
              KCard(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.image),
                          radius: 12,
                        ),
                        Flexible(child: Label(user.name).regular)
                      ],
                    ),
                    height5,
                    StarRating(
                      mainAxisAlignment: MainAxisAlignment.start,
                      color: StatusText.warning,
                      size: 20,
                      rating: parseToDouble(data.rating),
                    ),
                    if (data.feedback != null)
                      Label(data.feedback ?? "NA", weight: 600, fontSize: 12)
                          .regular,
                  ],
                ),
              ),
            height20,
            Row(
              children: [
                Flexible(
                  child: Center(
                    child: RatingBar.builder(
                      initialRating: parseToDouble(data.rating),
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
                  onPressed: _shareRatings,
                  label: "Share",
                  style: KButtonStyle.regular,
                  radius: 5,
                  backgroundColor: Kolor.secondary,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                ),
              ],
            ),
            height20,
            KTextfield(
              controller: feedback,
              hintText: "Add a review (Optional)",
              maxLines: 2,
              minLines: 2,
            ).regular,
          ],
        );
      });

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
