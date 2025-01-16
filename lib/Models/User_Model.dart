import 'dart:convert';

class UserModel {
  int id = 0;
  String name = "";
  String image = "";
  String? phone = "";
  String email = "";
  String? googleId = "";
  String? appleId = "";
  String? fcmToken = "";
  String status = "";
  String date = "";
  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    this.googleId,
    this.appleId,
    this.fcmToken,
    required this.status,
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
    String? fcmToken,
    String? status,
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
      fcmToken: fcmToken ?? this.fcmToken,
      status: status ?? this.status,
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
      'fcmToken': fcmToken,
      'status': status,
      'date': date,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      googleId: map['googleId'] ?? '',
      appleId: map['appleId'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      status: map['status'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, image: $image, phone: $phone, email: $email, googleId: $googleId, appleId: $appleId, fcmToken: $fcmToken, status: $status, date: $date)';
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
        other.fcmToken == fcmToken &&
        other.status == status &&
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
        fcmToken.hashCode ^
        status.hashCode ^
        date.hashCode;
  }
}
