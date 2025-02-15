import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ngf_organic/Resources/constants.dart';

class CartModel {
  int productVariantId = 0;
  String attributeType = "";
  String attributeValue = "";
  double mrp = 0;
  double salePrice = 0;
  int stock = 0;
  int qty = 0;
  int productId = 0;
  String name = "";
  double avgRatings = 0;
  int totalReviews = 0;
  List<String> images = [];
  CartModel({
    required this.productVariantId,
    required this.attributeType,
    required this.attributeValue,
    required this.mrp,
    required this.salePrice,
    required this.stock,
    required this.qty,
    required this.productId,
    required this.name,
    required this.avgRatings,
    required this.totalReviews,
    required this.images,
  });

  CartModel copyWith({
    int? productVariantId,
    String? attributeType,
    String? attributeValue,
    double? mrp,
    double? salePrice,
    int? stock,
    int? qty,
    int? productId,
    String? name,
    double? avgRatings,
    int? totalReviews,
    List<String>? images,
  }) {
    return CartModel(
      productVariantId: productVariantId ?? this.productVariantId,
      attributeType: attributeType ?? this.attributeType,
      attributeValue: attributeValue ?? this.attributeValue,
      mrp: mrp ?? this.mrp,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      qty: qty ?? this.qty,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      avgRatings: avgRatings ?? this.avgRatings,
      totalReviews: totalReviews ?? this.totalReviews,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productVariantId': productVariantId,
      'attributeType': attributeType,
      'attributeValue': attributeValue,
      'mrp': mrp,
      'salePrice': salePrice,
      'stock': stock,
      'qty': qty,
      'productId': productId,
      'name': name,
      'avgRatings': avgRatings,
      'totalReviews': totalReviews,
      'images': images,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productVariantId: map['productVariantId']?.toInt() ?? 0,
      attributeType: map['attributeType'] ?? '',
      attributeValue: map['attributeValue'] ?? '',
      mrp: parseToDouble(map['mrp']),
      salePrice: parseToDouble(map['salePrice']),
      stock: int.parse("${map['stock']}"),
      qty: int.parse("${map['qty']}"),
      productId: int.parse("${map['productId']}"),
      name: map['name'] ?? '',
      avgRatings: parseToDouble(map['avgRatings']),
      totalReviews: int.parse("${map['totalReviews']}"),
      images: List<String>.from(map['images'].split("#_#")),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(productVariantId: $productVariantId, attributeType: $attributeType, attributeValue: $attributeValue, mrp: $mrp, salePrice: $salePrice, stock: $stock, qty: $qty, productId: $productId, name: $name, avgRatings: $avgRatings, totalReviews: $totalReviews, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.productVariantId == productVariantId &&
        other.attributeType == attributeType &&
        other.attributeValue == attributeValue &&
        other.mrp == mrp &&
        other.salePrice == salePrice &&
        other.stock == stock &&
        other.qty == qty &&
        other.productId == productId &&
        other.name == name &&
        other.avgRatings == avgRatings &&
        other.totalReviews == totalReviews &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return productVariantId.hashCode ^
        attributeType.hashCode ^
        attributeValue.hashCode ^
        mrp.hashCode ^
        salePrice.hashCode ^
        stock.hashCode ^
        qty.hashCode ^
        productId.hashCode ^
        name.hashCode ^
        avgRatings.hashCode ^
        totalReviews.hashCode ^
        images.hashCode;
  }
}
