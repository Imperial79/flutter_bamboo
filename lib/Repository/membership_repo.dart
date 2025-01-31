import 'package:ngf_organic/Helper/api_config.dart';
import 'package:ngf_organic/Models/Response_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final membershipRepo = Provider(
  (ref) => MembershipRepo(),
);

class MembershipRepo {
  Future<ResponseModel> generateOrder() async {
    try {
      final res = await apiCallBack(path: "/membership/generate-payment-order");
      if (res.error) throw res.message;
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> verify(String paymentId) async {
    try {
      final res = await apiCallBack(path: "/membership/verify-payment", body: {
        "paymentId": paymentId,
      });
      if (res.error) throw res.message;
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
