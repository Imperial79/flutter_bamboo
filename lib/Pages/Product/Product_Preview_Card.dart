import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Models/Product_Model.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Components/Label.dart';
import '../../Resources/colors.dart';
import '../../Resources/commons.dart';

class ProductPreviewCard extends ConsumerWidget {
  final double? cardWidth;
  final ProductModel product;
  const ProductPreviewCard({
    super.key,
    this.cardWidth,
    required this.product,
  });

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      onTap: () => context.push("/product/abcd/${product.id}"),
      child: KCard(
        padding: EdgeInsets.all(0),
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product.images[0],
              imageBuilder: (context, imageProvider) => Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: kRadius(15),
                  color: kOpacity(KColor.fadeText, .5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => KCard(
                color: KColor.scaffold,
                height: 150,
                child: Center(
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: KColor.fadeText,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    product.category,
                    weight: 500,
                    fontSize: 12,
                    color: KColor.fadeText,
                  ).subtitle,
                  Label(
                    "${product.name}\n",
                    maxLines: 2,
                    weight: 600,
                  ).regular,
                  height10,
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber.shade700,
                      ),
                      Label(
                        "${product.totalRatings} | ${thousandToK(product.totalSell)}",
                        weight: 600,
                        fontSize: 12,
                        color: KColor.fadeText,
                      ).regular,
                    ],
                  ),
                  height5,
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 5,
                    children: [
                      Label(
                        kCurrencyFormat(product.salePrice),
                        weight: 600,
                        height: 1.2,
                        fontSize: 20,
                      ).title,
                      Label(
                        "-${calculateDiscount(product.mrp, product.salePrice)}%",
                        weight: 500,
                        fontSize: 15,
                        color: StatusText.danger,
                      ).title,
                      width5,
                      Label(
                        "MRP ${kCurrencyFormat(product.mrp)}",
                        weight: 500,
                        fontSize: 12,
                        color: KColor.fadeText,
                        decoration: TextDecoration.lineThrough,
                      ).regular,
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
