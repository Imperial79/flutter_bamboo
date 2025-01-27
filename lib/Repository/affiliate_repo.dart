import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final affiliateRepo = Provider(
  (ref) => AffiliateRepo(),
);

class AffiliateRepo {
  Future<ResponseModel> applyForAffiliate(Map<String, dynamic> body) async {
    try {
      final res = await apiCallBack(path: "/affiliate/activate", body: body);
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
