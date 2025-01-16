import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

import '../Resources/commons.dart';

class KCarousel extends StatefulWidget {
  final List<dynamic> images;
  final List<Widget> children;
  final double? height;
  final bool isLooped;
  final double indicatorSpace;
  final bool showIndicator;
  const KCarousel({
    super.key,
    this.children = const [],
    this.height,
    required this.isLooped,
    this.indicatorSpace = 0,
    this.images = const [],
    this.showIndicator = true,
  });

  static Widget item({
    void Function()? onTap,
    EdgeInsetsGeometry? padding,
    required String url,
    double? radius,
    bool showShadow = true,
    bool isCached = false,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: isCached
            ? CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    boxShadow: showShadow
                        ? [
                            const BoxShadow(
                              color: DColor.border,
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                    borderRadius: kRadius(radius ?? 15),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  boxShadow: showShadow
                      ? [
                          const BoxShadow(
                            color: DColor.border,
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                  borderRadius: kRadius(radius ?? 15),
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  State<KCarousel> createState() => _KCarouselState();
}

class _KCarouselState extends State<KCarousel> {
  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: widget.indicatorSpace),
          child: FlutterCarousel(
            options: FlutterCarouselOptions(
              height: 200.0,
              viewportFraction: 1,
              showIndicator: false,
              floatingIndicator: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  activePage = index;
                });
              },
            ),
            items: widget.images.isNotEmpty
                ? List.generate(
                    widget.images.length,
                    (index) => KCarousel.item(
                      isCached: true,
                      onTap: () async {
                        // if (widget.images[index]["action"] == "External Link") {
                        //   await launchUrl(
                        //       Uri.parse(widget.images[index]["remarks"]));
                        // } else if (widget.images[index]["action"] ==
                        //     "App Screen") {
                        //   navPush(context,
                        //       kScreenMap[widget.images[index]["remarks"]]!);
                        // }
                      },
                      showShadow: false,
                      radius: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      url: widget.images[index],
                    ),
                  )
                : widget.children,
          ),
        ),
        if (widget.showIndicator)
          _indicator(
            context,
            activeImage: activePage,
            length: widget.images.isNotEmpty
                ? widget.images.length
                : widget.children.length,
          ),
      ],
    );
  }

  Widget _indicator(
    BuildContext context, {
    required int activeImage,
    required int length,
  }) {
    return KCard(
      radius: 100,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          length,
          (index) => AnimatedScale(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            scale: activeImage == index ? 2 : 1,
            child: Container(
              height: 4,
              width: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
