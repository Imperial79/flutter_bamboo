import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_bamboo/Models/address_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addressFuture = FutureProvider<List<AddressModel>>((ref) async {
  final res = await apiCallBack(path: "/address/fetch");

  if (!res.error) {
    return (res.data as List).map((e) => AddressModel.fromMap(e)).toList();
  }
  return [];
});

final addressRepo = Provider(
  (ref) => AddressRepo(),
);

class AddressRepo {
  Future<ResponseModel> addAddress(AddressModel address) async {
    try {
      final res = await apiCallBack(
        path: "/address/save",
        body: address.toMap(),
      );
      if (res.error) throw res.message;
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
