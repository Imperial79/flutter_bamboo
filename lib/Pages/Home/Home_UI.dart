import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Preview_Card.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../Components/kCard.dart';
import '../../Components/kCarousel.dart';
import '../../Resources/colors.dart';

class Home_UI extends StatefulWidget {
  const Home_UI({super.key});

  @override
  State<Home_UI> createState() => _Home_UIState();
}

class _Home_UIState extends State<Home_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      body: SafeArea(
        child: Column(
          children: [
            KCard(
              color: LColor.scaffold,
              radius: 0,
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: KCard(
                    onTap: () => context.push("/search-products"),
                    radius: 10,
                    child: Row(
                      spacing: 10,
                      children: [
                        SvgPicture.asset(
                          "$kIconPath/search.svg",
                          height: 20,
                          colorFilter: kSvgColor(LColor.fadeText),
                        ),
                        Flexible(
                          child: Label(
                            "Search products",
                            fontSize: 17,
                            color: LColor.fadeText,
                          ).title,
                        ),
                      ],
                    ),
                  )),
                  IconButton(
                    onPressed: () => context.push("/cart"),
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    KCarousel(
                      height: 250,
                      isLooped: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1736776256361-360f071c2540?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1736344319749-93bc29f03d5d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      child: Row(
                        spacing: 20,
                        children: [
                          Column(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              KCard(
                                radius: 15,
                                child: Icon(
                                  Icons.apps,
                                ),
                              ),
                              Label("Category").regular,
                            ],
                          ),
                          Column(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              KCard(
                                radius: 15,
                                child: Icon(
                                  Icons.male,
                                  color: Colors.blue,
                                ),
                              ),
                              Label("Men").regular,
                            ],
                          ),
                          Column(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              KCard(
                                radius: 15,
                                child: Icon(
                                  Icons.female,
                                  color: Colors.pink,
                                ),
                              ),
                              Label("Women").regular,
                            ],
                          ),
                          Column(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              KCard(
                                radius: 15,
                                child: Icon(
                                  Icons.child_care,
                                  color: Colors.yellow.shade900,
                                ),
                              ),
                              Label("Kids").regular,
                            ],
                          ),
                        ],
                      ),
                    ),
                    KCard(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Label(
                                  "Best Sale Products",
                                  fontWeight: FontWeight.w700,
                                ).title,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Label(
                                  "See More",
                                  fontSize: 16,
                                  color: LColor.primary,
                                  fontWeight: FontWeight.w700,
                                ).regular,
                              ),
                            ],
                          ),
                          MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ProductPreviewCard(
                                cardWidth: double.infinity,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
