import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Cart/coupon_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCouponProvider = StateProvider<CouponModel?>(
  (ref) => null,
);

final couponFuture = FutureProvider.autoDispose<List<CouponModel>>(
  (ref) async {
    final res = await apiCallBack(path: "/offers/fetch");

    if (!res.error) {
      return (res.data as List)
          .map(
            (e) => CouponModel.fromMap(e),
          )
          .toList();
    }
    return [];
  },
);
