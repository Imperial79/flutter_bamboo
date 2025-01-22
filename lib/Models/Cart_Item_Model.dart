import 'dart:convert';

import 'package:flutter_bamboo/Models/Product_Detail_Model.dart';

import '../Resources/constants.dart';

class CartItemModel {
  int? productId = 0;
  int quantity = 1;
  CartItemModel({
    this.productId,
    required this.quantity,
  });

  CartItemModel copyWith({
    int? productId,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId']?.toInt(),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemModel &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  String toString() =>
      'CartItemModel(productId: $productId, quantity: $quantity)';

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode;
}
