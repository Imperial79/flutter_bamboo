import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ngf_organic/Resources/constants.dart';

class OrderDetailModel {
  int id = 0;
  int productId = 0;
  int shoppingOrderId = 0;
  String name = "";
  String sku = "";
  String attributeType = "";
  String attributeValue = "";
  String status = "";
  double mrp = 0;
  double salePrice = 0;
  double taxRate = 0;
  int qty = 0;
  double couponDiscount = 0;
  double subTotal = 0;
  double deliveryCharges = 0;
  double netPayable = 0;
  String orderDate = "";
  String shippingName = "";
  String shippingPhone = "";
  String shippingAddress = "";
  String shippingState = "";
  double rating = 0;
  String? feedback;
  String? deliveredOn;
  int returnDays = 0;
  String? returnReason;
  String paymentId = "";
  List<String> images = [];
  OrderDetailModel({
    required this.id,
    required this.productId,
    required this.shoppingOrderId,
    required this.name,
    required this.sku,
    required this.attributeType,
    required this.attributeValue,
    required this.status,
    required this.mrp,
    required this.salePrice,
    required this.taxRate,
    required this.qty,
    required this.couponDiscount,
    required this.subTotal,
    required this.deliveryCharges,
    required this.netPayable,
    required this.orderDate,
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
    required this.shippingState,
    required this.rating,
    this.feedback,
    this.deliveredOn,
    required this.returnDays,
    this.returnReason,
    required this.paymentId,
    required this.images,
  });

  OrderDetailModel copyWith({
    int? id,
    int? productId,
    int? shoppingOrderId,
    String? name,
    String? sku,
    String? attributeType,
    String? attributeValue,
    String? status,
    double? mrp,
    double? salePrice,
    double? taxRate,
    int? qty,
    double? couponDiscount,
    double? subTotal,
    double? deliveryCharges,
    double? netPayable,
    String? orderDate,
    String? shippingName,
    String? shippingPhone,
    String? shippingAddress,
    String? shippingState,
    double? rating,
    String? feedback,
    String? deliveredOn,
    int? returnDays,
    String? returnReason,
    String? paymentId,
    List<String>? images,
  }) {
    return OrderDetailModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      shoppingOrderId: shoppingOrderId ?? this.shoppingOrderId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      attributeType: attributeType ?? this.attributeType,
      attributeValue: attributeValue ?? this.attributeValue,
      status: status ?? this.status,
      mrp: mrp ?? this.mrp,
      salePrice: salePrice ?? this.salePrice,
      taxRate: taxRate ?? this.taxRate,
      qty: qty ?? this.qty,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      subTotal: subTotal ?? this.subTotal,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      netPayable: netPayable ?? this.netPayable,
      orderDate: orderDate ?? this.orderDate,
      shippingName: shippingName ?? this.shippingName,
      shippingPhone: shippingPhone ?? this.shippingPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingState: shippingState ?? this.shippingState,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      deliveredOn: deliveredOn ?? this.deliveredOn,
      returnDays: returnDays ?? this.returnDays,
      returnReason: returnReason ?? this.returnReason,
      paymentId: paymentId ?? this.paymentId,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'shoppingOrderId': shoppingOrderId,
      'name': name,
      'sku': sku,
      'attributeType': attributeType,
      'attributeValue': attributeValue,
      'status': status,
      'mrp': mrp,
      'salePrice': salePrice,
      'taxRate': taxRate,
      'qty': qty,
      'couponDiscount': couponDiscount,
      'subTotal': subTotal,
      'deliveryCharges': deliveryCharges,
      'netPayable': netPayable,
      'orderDate': orderDate,
      'shippingName': shippingName,
      'shippingPhone': shippingPhone,
      'shippingAddress': shippingAddress,
      'shippingState': shippingState,
      'rating': rating,
      'feedback': feedback,
      'deliveredOn': deliveredOn,
      'returnDays': returnDays,
      'returnReason': returnReason,
      'paymentId': paymentId,
      'images': images,
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      id: map['id']?.toInt() ?? 0,
      productId: map['productId']?.toInt() ?? 0,
      shoppingOrderId: map['shoppingOrderId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      attributeType: map['attributeType'] ?? '',
      attributeValue: map['attributeValue'] ?? '',
      status: map['status'] ?? '',
      mrp: parseToDouble(map['mrp']),
      salePrice: parseToDouble(map['salePrice']),
      taxRate: parseToDouble(map['taxRate']),
      qty: map['qty']?.toInt() ?? 0,
      couponDiscount: parseToDouble(map['couponDiscount']),
      subTotal: parseToDouble(map['subTotal']),
      deliveryCharges: parseToDouble(map['deliveryCharges']),
      netPayable: parseToDouble(map['netPayable']),
      orderDate: map['orderDate'] ?? '',
      shippingName: map['shippingName'] ?? '',
      shippingPhone: map['shippingPhone'] ?? '',
      shippingAddress: map['shippingAddress'] ?? '',
      shippingState: map['shippingState'] ?? '',
      rating: parseToDouble(map['rating']),
      feedback: map['feedback'],
      deliveredOn: map['deliveredOn'],
      returnDays: map['returnDays']?.toInt() ?? 0,
      returnReason: map['returnReason'],
      paymentId: map['paymentId'] ?? '',
      images: List<String>.from(map['images'].split("#_#")),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderDetailModel(id: $id, productId: $productId, shoppingOrderId: $shoppingOrderId, name: $name, sku: $sku, attributeType: $attributeType, attributeValue: $attributeValue, status: $status, mrp: $mrp, salePrice: $salePrice, taxRate: $taxRate, qty: $qty, couponDiscount: $couponDiscount, subTotal: $subTotal, deliveryCharges: $deliveryCharges, netPayable: $netPayable, orderDate: $orderDate, shippingName: $shippingName, shippingPhone: $shippingPhone, shippingAddress: $shippingAddress, shippingState: $shippingState, rating: $rating, feedback: $feedback, deliveredOn: $deliveredOn, returnDays: $returnDays, returnReason: $returnReason, paymentId: $paymentId, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderDetailModel &&
        other.id == id &&
        other.productId == productId &&
        other.shoppingOrderId == shoppingOrderId &&
        other.name == name &&
        other.sku == sku &&
        other.attributeType == attributeType &&
        other.attributeValue == attributeValue &&
        other.status == status &&
        other.mrp == mrp &&
        other.salePrice == salePrice &&
        other.taxRate == taxRate &&
        other.qty == qty &&
        other.couponDiscount == couponDiscount &&
        other.subTotal == subTotal &&
        other.deliveryCharges == deliveryCharges &&
        other.netPayable == netPayable &&
        other.orderDate == orderDate &&
        other.shippingName == shippingName &&
        other.shippingPhone == shippingPhone &&
        other.shippingAddress == shippingAddress &&
        other.shippingState == shippingState &&
        other.rating == rating &&
        other.feedback == feedback &&
        other.deliveredOn == deliveredOn &&
        other.returnDays == returnDays &&
        other.returnReason == returnReason &&
        other.paymentId == paymentId &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productId.hashCode ^
        shoppingOrderId.hashCode ^
        name.hashCode ^
        sku.hashCode ^
        attributeType.hashCode ^
        attributeValue.hashCode ^
        status.hashCode ^
        mrp.hashCode ^
        salePrice.hashCode ^
        taxRate.hashCode ^
        qty.hashCode ^
        couponDiscount.hashCode ^
        subTotal.hashCode ^
        deliveryCharges.hashCode ^
        netPayable.hashCode ^
        orderDate.hashCode ^
        shippingName.hashCode ^
        shippingPhone.hashCode ^
        shippingAddress.hashCode ^
        shippingState.hashCode ^
        rating.hashCode ^
        feedback.hashCode ^
        deliveredOn.hashCode ^
        returnDays.hashCode ^
        returnReason.hashCode ^
        paymentId.hashCode ^
        images.hashCode;
  }
}
