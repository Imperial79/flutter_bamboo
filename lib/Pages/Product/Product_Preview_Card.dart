import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Components/Label.dart';
import '../../Resources/colors.dart';
import '../../Resources/commons.dart';

class ProductPreviewCard extends StatelessWidget {
  final double cardWidth;
  const ProductPreviewCard({super.key, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push("/product/100"),
      child: Ink(
        child: SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: LColor.scaffold,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.squarespace-cdn.com/content/v1/5e5cd082c50ea102c52e5bb0/1597664315847-43NTZ4032GM9Y6003ZJZ/reusable-bamboo-dinnerware.jpg",
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      size: 20,
                      color: Colors.pink,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label("Shirt", weight: 600).subtitle,
                    Label(
                      "Item Title with color details and some more data",
                      fontSize: 16,
                      maxLines: 2,
                      weight: 700,
                    ).regular,
                    height20,
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.amber.shade700,
                        ),
                        Label("4.8 | 2336", color: LColor.fadeText, weight: 900)
                            .regular,
                        Expanded(
                          child: Label("₹ 2000",
                                  color: LColor.primary,
                                  weight: 900,
                                  textAlign: TextAlign.end)
                              .title,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
