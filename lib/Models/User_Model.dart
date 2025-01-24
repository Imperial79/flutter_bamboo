import 'dart:convert';

import 'package:flutter_bamboo/Resources/constants.dart';

class UserModel {
  int id = 0;
  String name = "";
  String image = "";
  String? phone = "";
  String email = "";
  String? googleId = "";
  String? appleId = "";
  String? referrerCode = "";
  String? referCode = "";
  double wallet = 0;
  String affiliateStatus = "";
  bool isMember = false;
  String status = "";
  String fcmToken = "";
  String date = "";
  UserModel({
    required this.id,
    required this.name,
    required this.image,
    this.phone,
    required this.email,
    this.googleId,
    this.appleId,
    this.referrerCode,
    this.referCode,
    required this.wallet,
    required this.affiliateStatus,
    required this.isMember,
    required this.status,
    required this.fcmToken,
    required this.date,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? image,
    String? phone,
    String? email,
    String? googleId,
    String? appleId,
    String? referrerCode,
    String? referCode,
    double? wallet,
    String? affiliateStatus,
    bool? isMember,
    String? status,
    String? fcmToken,
    String? date,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      googleId: googleId ?? this.googleId,
      appleId: appleId ?? this.appleId,
      referrerCode: referrerCode ?? this.referrerCode,
      referCode: referCode ?? this.referCode,
      wallet: wallet ?? this.wallet,
      affiliateStatus: affiliateStatus ?? this.affiliateStatus,
      isMember: isMember ?? this.isMember,
      status: status ?? this.status,
      fcmToken: fcmToken ?? this.fcmToken,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'phone': phone,
      'email': email,
      'googleId': googleId,
      'appleId': appleId,
      'referrerCode': referrerCode,
      'referCode': referCode,
      'wallet': wallet,
      'affiliateStatus': affiliateStatus,
      'isMember': isMember,
      'status': status,
      'fcmToken': fcmToken,
      'date': date,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      phone: map['phone'],
      email: map['email'] ?? '',
      googleId: map['googleId'],
      appleId: map['appleId'],
      referrerCode: map['referrerCode'],
      referCode: map['referCode'],
      wallet: parseToDouble(map['wallet']),
      affiliateStatus: map['affiliateStatus'] ?? '',
      isMember: map['isMember'] == "Y",
      status: map['status'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, image: $image, phone: $phone, email: $email, googleId: $googleId, appleId: $appleId, referrerCode: $referrerCode, referCode: $referCode, wallet: $wallet, affiliateStatus: $affiliateStatus, isMember: $isMember, status: $status, fcmToken: $fcmToken, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.phone == phone &&
        other.email == email &&
        other.googleId == googleId &&
        other.appleId == appleId &&
        other.referrerCode == referrerCode &&
        other.referCode == referCode &&
        other.wallet == wallet &&
        other.affiliateStatus == affiliateStatus &&
        other.isMember == isMember &&
        other.status == status &&
        other.fcmToken == fcmToken &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        googleId.hashCode ^
        appleId.hashCode ^
        referrerCode.hashCode ^
        referCode.hashCode ^
        wallet.hashCode ^
        affiliateStatus.hashCode ^
        isMember.hashCode ^
        status.hashCode ^
        fcmToken.hashCode ^
        date.hashCode;
  }
}
