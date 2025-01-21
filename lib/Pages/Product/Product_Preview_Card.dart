import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Models/Product_Model.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Components/Label.dart';
import '../../Models/Cart_Item_Model.dart';
import '../../Repository/cart_repo.dart';
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
    final cartData = ref.watch(cartProvider);
    final inCart = cartData.any((item) => item.productId == product.id);
    return InkWell(
      onTap: () => context.push("/product/${product.id}"),
      child: KCard(
        padding: EdgeInsets.all(0),
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
                        product.images[0],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (!inCart) {
                      ref.read(cartProvider.notifier).addItem(
                            CartItemModel(
                              quantity: 1,
                              image: product.images[0],
                              name: product.name,
                              price: product.salePrice,
                              productId: product.id,
                              totalPrice: product.mrp,
                              rating: product.totalRatings,
                              actualPrice: product.salePrice,
                            ),
                          );
                    } else {
                      ref.read(cartProvider.notifier).removeItem(product.id);
                    }
                  },
                  icon: Icon(
                    inCart ? Icons.favorite : Icons.favorite_border,
                    size: 25,
                    color: inCart ? LColor.primary : null,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(product.category, weight: 600).subtitle,
                  Label(
                    product.name,
                    fontSize: 16,
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
                        "${product.totalRatings} | ${product.totalSell}",
                        weight: 500,
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
                        fontSize: 22,
                        // height: 1,
                      ).title,
                      Label(
                        "MRP ${kCurrencyFormat(product.mrp)}",
                        weight: 700,
                        fontSize: 17,
                        color: LColor.fadeText,
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
