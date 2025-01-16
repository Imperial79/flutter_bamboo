// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResponseModel {
  bool error = false;
  String message = "";
  dynamic data;
  dynamic action;
  ResponseModel({
    required this.error,
    required this.message,
    this.data,
    this.action,
  });

  ResponseModel copyWith({
    bool? error,
    String? message,
    dynamic data,
    dynamic action,
  }) {
    return ResponseModel(
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'message': message,
      'data': data,
      'action': action,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
      data: map['data'],
      action: map['action'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResponseModel(error: $error, message: $message, data: $data, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseModel &&
        other.error == error &&
        other.message == message &&
        other.data == data &&
        other.action == action;
  }

  @override
  int get hashCode {
    return error.hashCode ^ message.hashCode ^ data.hashCode ^ action.hashCode;
  }
}
