import 'package:flutter_bamboo/Helper/api_config.dart';
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
    FutureProvider.autoDispose.family<Map<String, dynamic>?, String>(
  (ref, orderId) async {
    final res = await apiCallBack(
      path: "/shopping/order-details",
      body: {"orderedItemId": orderId},
    );

    if (!res.error) {
      return res.data;
    }
    return null;
  },
);
