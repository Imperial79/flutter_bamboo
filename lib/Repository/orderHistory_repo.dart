import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
import 'package:flutter_bamboo/Models/order_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderHistoryFuture = FutureProvider.autoDispose.family<List, int>(
  (ref, pageNo) async {
    final res =
        await apiCallBack(path: "/shopping/history", body: {"pageNo": pageNo});
    ref.keepAlive();
    if (!res.error) {
      return res.data as List;
    }
    return [];
  },
);

final orderDetailFuture =
    FutureProvider.autoDispose.family<OrderDetailModel?, String>(
  (ref, orderId) async {
    final res = await apiCallBack(
      path: "/shopping/order-details",
      body: {"orderedItemId": orderId},
    );

    if (!res.error) {
      return OrderDetailModel.fromMap(res.data);
    }
    return null;
  },
);

final orderHistoryRepo = Provider((ref) {
  return OrderhistoryRepo();
});

class OrderhistoryRepo {
  Future<ResponseModel> shareRatings({
    required String orderedItemId,
    required double rate,
    required String feedback,
  }) async {
    try {
      final res = await apiCallBack(
        path: "/shopping/share-rating",
        body: {
          "orderedItemId": orderedItemId,
          "rate": rate,
          "feedback": feedback,
        },
      );

      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
