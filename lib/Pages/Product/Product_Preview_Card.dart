import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Models/Product_Model.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Components/Label.dart';
import '../../Resources/colors.dart';
import '../../Resources/commons.dart';

class ProductPreviewCard extends ConsumerWidget {
  final double cardWidth;
  final ProductModel product;
  const ProductPreviewCard({
    super.key,
    required this.cardWidth,
    required this.product,
  });

  @override
  Widget build(BuildContext context, ref) {
    // final cartData = ref.watch(cartProvider);
    // final inCart = cartData.any((item) => item.productId == product.id);

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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      product.category,
                      weight: 600,
                      fontSize: 12,
                      color: KColor.fadeText,
                    ).subtitle,
                    Label(
                      "${product.name}\n",
                      maxLines: 2,
                      weight: 700,
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
                          "${product.totalRatings} | ${thoundsandToK(product.totalSell)}",
                          weight: 600,
                          fontSize: 12,
                          color: KColor.fadeText,
                        ).regular,
                      ],
                    ),
                    height5,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Label(
                          kCurrencyFormat(product.salePrice),
                          weight: 700,
                          fontSize: 20,
                        ).title,
                        Label(
                          "-${calculateDiscount(product.mrp, product.salePrice)}%",
                          weight: 600,
                          fontSize: 15,
                          color: StatusText.danger,
                        ).title,
                        Label(
                          "MRP ${kCurrencyFormat(product.mrp)}",
                          weight: 600,
                          fontSize: 15,
                          color: KColor.fadeText,
                          decoration: TextDecoration.lineThrough,
                        ).regular,
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
