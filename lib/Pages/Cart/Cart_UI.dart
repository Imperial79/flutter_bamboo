import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kTextfield.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:go_router/go_router.dart';

class Cart_UI extends StatefulWidget {
  const Cart_UI({super.key});

  @override
  State<Cart_UI> createState() => _Cart_UIState();
}

class _Cart_UIState extends State<Cart_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("Cart").regular,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("Shipping Address").title,
              KCard(
                radius: 10,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Label(
                        "ABC Street, Durgapur Bazaar - 713201",
                        fontSize: 17,
                        color: Colors.grey.shade700,
                      ).regular,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: LColor.fadeText,
                    ),
                  ],
                ),
              ),
              height10,
              Label("Products Summary").title,
              Column(
                spacing: 15,
                children: [1, 2]
                    .map(
                      (e) => buildCartItem(),
                    )
                    .toList(),
              ),
              height10,
              Label("Coupons & Promotional").title,
              Row(
                spacing: 10,
                children: [
                  Flexible(
                    child: KTextfield(
                      hintText: "Enter Coupon Code",
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
              Text.rich(
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () async {},
                  text: "Browse Coupons",
                  style: TextStyle(
                    color: kColor(context).primary,
                    fontSize: 17,
                    fontVariations: [
                      FontVariation.weight(700),
                    ],
                  ),
                ),
              ),
              _selectedCouponCard(context),
              height10,
              Label('Price Breakdown').title,
              KCard(
                child: Column(
                  children: [
                    _row("Price (2 Items)", "₹ 200"),
                    _row("Discount", "-₹ 20"),
                    _row("Delivery Charges", "₹ 50"),
                    div,
                    _row("Total", "₹ 230"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: LColor.card,
            border: Border(top: BorderSide(color: LColor.border))),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label("Total").regular,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCouponCard(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        KCard(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: kColor(context).primaryContainer,
          child: Row(
            spacing: 15,
            children: [
              Icon(
                Icons.local_offer,
                color: kColor(context).primary,
              ),
              Expanded(
                child: Label(
                  "Offer Applied! Get extra 20% OFF on first order.",
                  color: kColor(context).primary,
                  weight: 700,
                  fontSize: 15,
                ).regular,
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 12,
          backgroundColor: kColor(context).primary,
          foregroundColor: LColor.scaffold,
          child: Icon(
            Icons.close,
            size: 15,
          ),
        ),
      ],
    );
  }

  Widget _row(String text1, String text2) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Label(text1).regular,
          Label(text2, color: text1 == "Discount" ? StatusText.success : null)
              .regular,
        ],
      );

  Widget buildCartItem() {
    return InkWell(
      onTap: () => context.push("/product/200"),
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
                color: LColor.card,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Label(
                    "NIGHTBIRDES HUB Bamboo Toothbrush With Charcoal Activated Soft Bristles | Treated With Neem Oil | For Fungus Protection | Bpa Free, Biodegradable And Compostable Handle | Eco-friendly |Pack of 3",
                    maxLines: 2,
                  ).regular,
                  height5,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label("₹", fontSize: 20, height: 1.2).regular,
                      Expanded(
                        child: Label(
                          "190",
                          fontSize: 25,
                          height: 1,
                          weight: 600,
                        ).title,
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          StarRating(
                            mainAxisAlignment: MainAxisAlignment.end,
                            rating: 4.9,
                            size: 15,
                            color: Colors.amber.shade800,
                          ),
                          Label(
                            "(36)",
                            weight: 500,
                          ).regular
                        ],
                      )
                    ],
                  ),
                  height5,
                  Row(
                    spacing: 10,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: kColor(context).primaryContainer,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(5),
                          ),
                        ),
                        height: 25,
                        child: FittedBox(
                          child: Icon(
                            Icons.horizontal_rule_rounded,
                            size: 15,
                          ),
                        ),
                      ),
                      Label("1").regular,
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: kColor(context).primaryContainer,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(5),
                          ),
                        ),
                        height: 25,
                        child: FittedBox(
                          child: Icon(
                            Icons.add,
                            size: 15,
                          ),
                        ),
                      ),
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
