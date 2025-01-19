import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/Cart_Item_Model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  // Method to add an item to the cart
  void addItem(CartItemModel item) {
    state = [...state, item];
  }

  // Method to remove an item from the cart by ID
  void removeItem(int productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  // Method to update the quantity of an item
  void updateQuantity(int productId, int newQuantity) {
    state = state.map((item) {
      if (item.productId == productId) {
        return CartItemModel(
          productId: item.productId,
          price: item.price,
          totalPrice: (item.price ?? 0) * newQuantity,
          name: item.name,
          image: item.image,
          quantity: newQuantity,
          actualPrice: item.actualPrice,
          rating: item.rating,
        );
      }
      return item;
    }).toList();
  }

  // Method to clear the cart
  void clearCart() {
    state = [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});
