import 'dart:convert';

import 'package:flutter_bamboo/Resources/constants.dart';

class CouponModel {
  int id = 0;
  String coupon = "";
  String description = "";
  double minPurchase = 0;
  double offPercent = 0;
  double uptoAmount = 0;
  String startDate = "";
  String endDate = "";
  CouponModel({
    required this.id,
    required this.coupon,
    required this.description,
    required this.minPurchase,
    required this.offPercent,
    required this.uptoAmount,
    required this.startDate,
    required this.endDate,
  });

  CouponModel copyWith({
    int? id,
    String? coupon,
    String? description,
    double? minPurchase,
    double? offPercent,
    double? uptoAmount,
    String? startDate,
    String? endDate,
  }) {
    return CouponModel(
      id: id ?? this.id,
      coupon: coupon ?? this.coupon,
      description: description ?? this.description,
      minPurchase: minPurchase ?? this.minPurchase,
      offPercent: offPercent ?? this.offPercent,
      uptoAmount: uptoAmount ?? this.uptoAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coupon': coupon,
      'description': description,
      'minPurchase': minPurchase,
      'offPercent': offPercent,
      'uptoAmount': uptoAmount,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id']?.toInt() ?? 0,
      coupon: map['coupon'] ?? '',
      description: map['description'] ?? '',
      minPurchase: parseToDouble(map['minPurchase']),
      offPercent: parseToDouble(map['offPercent']),
      uptoAmount: parseToDouble(map['uptoAmount']),
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CouponModel(id: $id, coupon: $coupon, description: $description, minPurchase: $minPurchase, offPercent: $offPercent, uptoAmount: $uptoAmount, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponModel &&
        other.id == id &&
        other.coupon == coupon &&
        other.description == description &&
        other.minPurchase == minPurchase &&
        other.offPercent == offPercent &&
        other.uptoAmount == uptoAmount &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        coupon.hashCode ^
        description.hashCode ^
        minPurchase.hashCode ^
        offPercent.hashCode ^
        uptoAmount.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }
}
