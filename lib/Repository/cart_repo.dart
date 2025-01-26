import 'dart:developer';

import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartFuture = FutureProvider.autoDispose<List>((ref) async {
  final res = await apiCallBack(path: "/cart/fetch-details");
  if (!res.error) {
    log("${res.data}");
    return res.data;
  }
  return [];
});

final cartRepo = Provider(
  (ref) => CartRepo(),
);

class CartRepo {
  Future<ResponseModel> updateCart(Map<String, dynamic> body) async {
    try {
      final res = await apiCallBack(path: "/cart/update", body: body);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> deleteCartItem(int productVariantId) async {
    try {
      final res = await apiCallBack(path: "/cart/delete", body: {
        "productVariantId": productVariantId,
      });
      return res;
    } catch (e) {
      rethrow;
    }
  }
}

// class CartNotifier extends StateNotifier<List<CartItemModel>> {
//   CartNotifier() : super([]);

//   // Method to add an item to the cart
//   void addItem(CartItemModel item) {
//     state = [...state, item];
//   }

//   // Method to remove an item from the cart by ID
//   void removeItem(int productId) {
//     state = state.where((item) => item.productId != productId).toList();
//   }

//   // Method to update the quantity of an item
//   void updateQuantity(int productId, int newQuantity) {
//     state = state.map((item) {
//       if (item.productId == productId) {
//         return CartItemModel(
//           productId: item.productId,
//           quantity: newQuantity,
//         );
//       }
//       return item;
//     }).toList();
//   }

//   // Method to clear the cart
//   void clearCart() {
//     state = [];
//   }
// }

// final cartProvider =
//     StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
//   return CartNotifier();
// });
