import 'dart:convert';

import '../Resources/constants.dart';

class CartItemModel {
  int? id = 0;
  int? orderId = 0;
  int? productId = 0;
  double? price = 0;
  double? totalPrice = 0;
  String? name = "";
  String? image = "";
  int quantity = 1;
  double? rating = 0;
  double? actualPrice = 0;
  CartItemModel({
    this.id,
    this.orderId,
    this.productId,
    this.price,
    this.totalPrice,
    this.name,
    this.image,
    required this.quantity,
    this.rating,
    this.actualPrice,
  });

  CartItemModel copyWith({
    int? id,
    int? orderId,
    int? productId,
    double? price,
    double? totalPrice,
    String? name,
    String? image,
    int? quantity,
    double? rating,
    double? actualPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      name: name ?? this.name,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
      actualPrice: actualPrice ?? this.actualPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'price': price,
      'totalPrice': totalPrice,
      'name': name,
      'image': image,
      'quantity': quantity,
      'rating': rating,
      'actualPrice': actualPrice,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toInt(),
      orderId: map['orderId']?.toInt(),
      productId: map['productId']?.toInt(),
      price: parseToDouble(map['price']),
      totalPrice: parseToDouble(map['totalPrice']),
      name: map['name'],
      image: map['image'],
      quantity: map['quantity']?.toInt() ?? 0,
      rating: parseToDouble(map['rating']),
      actualPrice: parseToDouble(map['actualPrice']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemModel &&
        other.id == id &&
        other.orderId == orderId &&
        other.productId == productId &&
        other.price == price &&
        other.totalPrice == totalPrice &&
        other.name == name &&
        other.image == image &&
        other.quantity == quantity &&
        other.rating == rating &&
        other.actualPrice == actualPrice;
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, orderId: $orderId, productId: $productId, price: $price, totalPrice: $totalPrice, name: $name, image: $image, quantity: $quantity, rating: $rating, actualPrice: $actualPrice)';
  }
}
