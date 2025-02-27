import 'dart:convert';

class AddressModel {
  int? id = 0;
  int? customerId = 0;
  String? name = "";
  String? phone = "";
  String? address = "";
  String? city = "";
  String? pincode = "";
  String? state = "";
  bool? isPrimary = false;
  AddressModel({
    this.id,
    this.customerId,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.pincode,
    this.state,
    this.isPrimary,
  });

  AddressModel copyWith({
    int? id,
    int? customerId,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? pincode,
    String? state,
    bool? isPrimary,
  }) {
    return AddressModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      state: state ?? this.state,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'pincode': pincode,
      'state': state,
      'isPrimary': isPrimary,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id']?.toInt(),
      customerId: map['customerId']?.toInt(),
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      pincode: map['pincode'],
      state: map['state'],
      isPrimary: map['isPrimary'] == "Y",
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, customerId: $customerId, name: $name, phone: $phone, address: $address, city: $city, pincode: $pincode, state: $state, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.customerId == customerId &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.city == city &&
        other.pincode == pincode &&
        other.state == state &&
        other.isPrimary == isPrimary;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        city.hashCode ^
        pincode.hashCode ^
        state.hashCode ^
        isPrimary.hashCode;
  }
}
