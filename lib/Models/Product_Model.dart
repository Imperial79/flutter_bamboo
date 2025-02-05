import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ngf_organic/Resources/constants.dart';

class ProductModel {
  int id = 0;
  String name = "";
  String description = "";
  String category = "";
  double totalRatings = 0;
  int totalReviews = 0;
  int totalSell = 0;
  int returnDays = 0;
  double mrp = 0;
  double salePrice = 0;
  List<String> images = [];
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.totalRatings,
    required this.totalReviews,
    required this.totalSell,
    required this.returnDays,
    required this.mrp,
    required this.salePrice,
    required this.images,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    double? totalRatings,
    int? totalReviews,
    int? totalSell,
    int? returnDays,
    double? mrp,
    double? salePrice,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      totalRatings: totalRatings ?? this.totalRatings,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSell: totalSell ?? this.totalSell,
      returnDays: returnDays ?? this.returnDays,
      mrp: mrp ?? this.mrp,
      salePrice: salePrice ?? this.salePrice,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'totalRatings': totalRatings,
      'totalReviews': totalReviews,
      'totalSell': totalSell,
      'returnDays': returnDays,
      'mrp': mrp,
      'salePrice': salePrice,
      'images': images,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      totalRatings: parseToDouble(map['totalRatings']),
      totalReviews: map['totalReviews']?.toInt() ?? 0,
      totalSell: map['totalSell']?.toInt() ?? 0,
      returnDays: map['returnDays']?.toInt() ?? 0,
      mrp: parseToDouble(map['mrp']),
      salePrice: parseToDouble(map['salePrice']),
      images: List<String>.from(map['images'].split("#_#")),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, category: $category, totalRatings: $totalRatings, totalReviews: $totalReviews, totalSell: $totalSell, returnDays: $returnDays, mrp: $mrp, salePrice: $salePrice, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.totalRatings == totalRatings &&
        other.totalReviews == totalReviews &&
        other.totalSell == totalSell &&
        other.returnDays == returnDays &&
        other.mrp == mrp &&
        other.salePrice == salePrice &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        category.hashCode ^
        totalRatings.hashCode ^
        totalReviews.hashCode ^
        totalSell.hashCode ^
        returnDays.hashCode ^
        mrp.hashCode ^
        salePrice.hashCode ^
        images.hashCode;
  }
}
