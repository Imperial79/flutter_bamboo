import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

class AffiliateModel {
  int id = 0;
  String name = "";
  int qty = 0;
  double subTotal = 0;
  double commissionAmount = 0;
  String commissionStatus = "";
  String orderDate = "";
  List<String> images = [];
  AffiliateModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.subTotal,
    required this.commissionAmount,
    required this.commissionStatus,
    required this.orderDate,
    required this.images,
  });

  AffiliateModel copyWith({
    int? id,
    String? name,
    int? qty,
    double? subTotal,
    double? commissionAmount,
    String? commissionStatus,
    String? orderDate,
    List<String>? images,
  }) {
    return AffiliateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      subTotal: subTotal ?? this.subTotal,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      commissionStatus: commissionStatus ?? this.commissionStatus,
      orderDate: orderDate ?? this.orderDate,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'subTotal': subTotal,
      'commissionAmount': commissionAmount,
      'commissionStatus': commissionStatus,
      'orderDate': orderDate,
      'images': images,
    };
  }

  factory AffiliateModel.fromMap(Map<String, dynamic> map) {
    return AffiliateModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      qty: map['qty']?.toInt() ?? 0,
      subTotal: parseToDouble(map['subTotal']),
      commissionAmount: parseToDouble(map['commissionAmount']),
      commissionStatus: map['commissionStatus'] ?? '',
      orderDate: map['orderDate'] ?? '',
      images: List<String>.from(map['images'].split("#_#")),
    );
  }

  String toJson() => json.encode(toMap());

  factory AffiliateModel.fromJson(String source) =>
      AffiliateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AffiliateModel(id: $id, name: $name, qty: $qty, subTotal: $subTotal, commissionAmount: $commissionAmount, commissionStatus: $commissionStatus, orderDate: $orderDate, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AffiliateModel &&
        other.id == id &&
        other.name == name &&
        other.qty == qty &&
        other.subTotal == subTotal &&
        other.commissionAmount == commissionAmount &&
        other.commissionStatus == commissionStatus &&
        other.orderDate == orderDate &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        qty.hashCode ^
        subTotal.hashCode ^
        commissionAmount.hashCode ^
        commissionStatus.hashCode ^
        orderDate.hashCode ^
        images.hashCode;
  }
}
