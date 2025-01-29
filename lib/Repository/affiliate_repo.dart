import 'dart:convert';

import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_bamboo/Models/affiliate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final affiliateRepo = Provider(
  (ref) => AffiliateRepo(),
);

final affiliateListProvider = StateProvider<List<AffiliateModel>>(
  (ref) => [],
);

final affiliateFuture = FutureProvider.autoDispose.family<void, String>(
  (ref, params) async {
    final data = jsonDecode(params);
    final pageNo = data["pageNo"];
    final res = await apiCallBack(
      path: "/affiliate/commission-history",
      body: data,
    );

    if (!res.error) {
      final dataList = (res.data as List).map(
        (e) => AffiliateModel.fromMap(e),
      );
      if (pageNo == 0) {
        ref.read(affiliateListProvider.notifier).state = [];
      }
      ref.read(affiliateListProvider.notifier).state.addAll(dataList);
    }
  },
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
