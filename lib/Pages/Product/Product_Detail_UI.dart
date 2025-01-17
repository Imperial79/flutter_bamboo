import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Helper/data.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Preview_Card.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Product_Detail_UI extends ConsumerStatefulWidget {
  final String id;
  const Product_Detail_UI({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<Product_Detail_UI> createState() => _Product_Detail_UIState();
}

class _Product_Detail_UIState extends ConsumerState<Product_Detail_UI> {
  String selectedDescriptionType = "About Item";
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        // title: Label(widget.id).regular,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(
          //     "$kIconPath/like.svg",
          //     height: 22,
          //     colorFilter: kSvgColor(LColor.fadeText),
          //   ),
          // ),
          // width10,
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "$kIconPath/share.svg",
              height: 22,
              colorFilter: kSvgColor(LColor.fadeText),
            ),
          ),
          width10,
          Badge(
            backgroundColor: Colors.pink,
            label: Label("1").regular,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "$kIconPath/shopping-bag.svg",
                height: 22,
                colorFilter: kSvgColor(LColor.fadeText),
              ),
            ),
          ),
          width10,
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: LColor.card,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/5e5cd082c50ea102c52e5bb0/1597664315847-43NTZ4032GM9Y6003ZJZ/reusable-bamboo-dinnerware.jpg",
                    ),
                  ),
                ),
              ),
              height10,
              Row(
                spacing: 10,
                children: [
                  Icon(
                    kCatgeoryMap["Man"] ?? Icons.apps,
                    size: 20,
                    color: LColor.fadeText,
                  ),
                  Label("Man", fontSize: 17, color: LColor.fadeText).regular,
                ],
              ),
              Label("NIGHTBIRDES HUB Bamboo Toothbrush With Charcoal Activated Soft Bristles | Treated With Neem Oil | For Fungus Protection | Bpa Free, Biodegradable And Compostable Handle | Eco-friendly |Pack of 3",
                      // "Essential Men's Short Sleeve Crewneck T-Shirt",
                      weight: 700,
                      fontSize: 17,
                      height: 1.3)
                  .title,
              height10,
              Row(
                spacing: 7,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber.shade700,
                  ),
                  Label("4.9 Ratings • 2.3k Reviews • 2.9k Sold",
                          weight: 600, fontSize: 17, color: LColor.fadeText)
                      .title,
                ],
              ),
              height10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label("₹", fontSize: 20, height: 1.2).regular,
                  Flexible(
                    child: Label(
                      "190",
                      fontSize: 30,
                      height: 1,
                      weight: 600,
                    ).title,
                  ),
                  width10,
                  Label(
                    "-59%",
                    fontSize: 30,
                    height: 1,
                    weight: 400,
                    color: kColor(context).primary,
                  ).title,
                ],
              ),
              height10,
              Row(
                spacing: 8,
                children: [
                  Label(
                    "Variant:",
                    fontSize: 20,
                  ).regular,
                  Flexible(
                      child: Label("Blue", fontSize: 20, weight: 800).regular),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    KCard(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("Blue", fontSize: 20, weight: 800).regular,
                          Label("₹900.00", fontSize: 20, weight: 800).regular,
                          Label("MRP 1000.00").regular,
                        ],
                      ),
                    ),
                    KCard(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("Blue", fontSize: 20, weight: 800).regular,
                          Label("₹900.00", fontSize: 20, weight: 800).regular,
                          Label("MRP 1000.00").regular,
                        ],
                      ),
                    ),
                    KCard(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label("Blue", fontSize: 20, weight: 800).regular,
                          Label("₹900.00", fontSize: 20, weight: 800).regular,
                          Label("MRP 1000.00").regular,
                        ],
                      ),
                    )
                  ],
                ),
              ),
              height10,
              Row(
                children: [
                  descriptionSelectBtn("About Item"),
                  descriptionSelectBtn("Reviews"),
                ],
              ),
              if (selectedDescriptionType == "About Item")
                ...aboutItemTab()
              else
                ...reviewsTab(),
              height10,
              Label(
                "Products you may like",
                weight: 900,
                fontSize: 17,
              ).regular,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: [
                    ProductPreviewCard(
                      cardWidth: 200,
                    ),
                    ProductPreviewCard(
                      cardWidth: 200,
                    ),
                    ProductPreviewCard(
                      cardWidth: 200,
                    ),
                    ProductPreviewCard(
                      cardWidth: 200,
                    ),
                    ProductPreviewCard(
                      cardWidth: 200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(kPadding),
        decoration: BoxDecoration(
          color: LColor.scaffold,
          boxShadow: [
            BoxShadow(
              color: LColor.card,
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
                    Label("INR 190",
                            weight: 800, fontSize: 25, color: LColor.primary)
                        .title,
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  KSnackbar(
                    context,
                    message: "Product added to cart.",
                  );
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
                      SvgPicture.asset(
                        "$kIconPath/shopping-bag.svg",
                        height: 20,
                        colorFilter: kSvgColor(Colors.white),
                      ),
                      Label("1", fontSize: 25, weight: 700, color: Colors.white)
                          .regular,
                    ],
                  ),
                ),
              ),
              Container(
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
                          fontSize: 15, weight: 700, color: Colors.white)
                      .regular,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> aboutItemTab() {
    return [
      Label(
        "Description",
        weight: 900,
        fontSize: 17,
      ).regular,
      Label(
        "What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        weight: 500,
        fontSize: 16,
        color: Colors.black,
      ).subtitle,
      TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Label("See Less", color: LColor.primary, weight: 800, fontSize: 16)
                .regular,
            Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 25,
              color: LColor.fadeText,
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
          Label("4.9", fontSize: 50, height: 1, weight: 900).title,
          Label("/ 5.0").title,
        ],
      ),
      StarRating(
        rating: 4.9,
        allowHalfRating: false,
        color: Colors.amber.shade800,
        // onRatingChanged: (rating) => setState(() => this.rating = rating),
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
        weight: 900,
        fontSize: 17,
      ).regular,
      KCard(
        radius: 0,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 15,
                ),
                Expanded(
                    child: Label(
                  "User N***e",
                  weight: 800,
                  fontSize: 17,
                ).regular),
                Icon(
                  Icons.star,
                  color: Colors.amber.shade700,
                ),
                Label(
                  "5.0",
                  weight: 800,
                  fontSize: 17,
                ).regular
              ],
            ),
            Label(
              "\"The product is more than my expectations\"",
              fontSize: 16,
            ).regular,
          ],
        ),
      )
    ];
  }

  Widget descriptionSelectBtn(String label) {
    bool selected = selectedDescriptionType == label;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDescriptionType = label;
          });
        },
        child: Ink(
          padding: EdgeInsets.only(bottom: 10, left: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: selected ? LColor.primary : Colors.grey.shade300,
                  width: 3),
            ),
          ),
          child: Label(
            label,
            weight: selected ? 900 : 700,
            color: selected ? LColor.primary : Colors.grey.shade400,
          ).title,
        ),
      ),
    );
  }
}
