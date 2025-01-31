import 'package:ngf_organic/Helper/api_config.dart';
import 'package:ngf_organic/Models/Response_Model.dart';
import 'package:ngf_organic/Models/address_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedAddressProvider = StateProvider<AddressModel?>(
  (ref) => null,
);

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

  Future<ResponseModel> makePrimary(int addressId) async {
    try {
      final res = await apiCallBack(
        path: "/address/make-primary",
        body: {"addressId": addressId},
      );
      if (res.error) throw res.message;
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> delete(int addressId) async {
    try {
      final res = await apiCallBack(
        path: "/address/delete",
        body: {"addressId": addressId},
      );
      if (res.error) throw res.message;
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
