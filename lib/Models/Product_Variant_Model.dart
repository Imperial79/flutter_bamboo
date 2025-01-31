import 'dart:convert';

import 'package:ngf_organic/Resources/constants.dart';

class ProductVariantModel {
  int id = -1;
  String attributeType = "";
  String attributeValue = "";
  String sku = "";
  int stock = 0;
  double mrp = 0;
  double salePrice = 0;
  ProductVariantModel({
    required this.id,
    required this.attributeType,
    required this.attributeValue,
    required this.sku,
    required this.stock,
    required this.mrp,
    required this.salePrice,
  });

  ProductVariantModel copyWith({
    int? id,
    String? attributeType,
    String? attributeValue,
    String? sku,
    int? stock,
    double? mrp,
    double? salePrice,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      attributeType: attributeType ?? this.attributeType,
      attributeValue: attributeValue ?? this.attributeValue,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      mrp: mrp ?? this.mrp,
      salePrice: salePrice ?? this.salePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attributeType': attributeType,
      'attributeValue': attributeValue,
      'sku': sku,
      'stock': stock,
      'mrp': mrp,
      'salePrice': salePrice,
    };
  }

  factory ProductVariantModel.fromMap(Map<String, dynamic> map) {
    return ProductVariantModel(
      id: map['id']?.toInt() ?? -1,
      attributeType: map['attributeType'] ?? '',
      attributeValue: map['attributeValue'] ?? '',
      sku: map['sku'] ?? '',
      stock: map['stock']?.toInt() ?? 0,
      mrp: parseToDouble(map['mrp']),
      salePrice: parseToDouble(map['salePrice']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductVariantModel.fromJson(String source) =>
      ProductVariantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, attributeType: $attributeType, attributeValue: $attributeValue, sku: $sku, stock: $stock, mrp: $mrp, salePrice: $salePrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductVariantModel &&
        other.id == id &&
        other.attributeType == attributeType &&
        other.attributeValue == attributeValue &&
        other.sku == sku &&
        other.stock == stock &&
        other.mrp == mrp &&
        other.salePrice == salePrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        attributeType.hashCode ^
        attributeValue.hashCode ^
        sku.hashCode ^
        stock.hashCode ^
        mrp.hashCode ^
        salePrice.hashCode;
  }
}
