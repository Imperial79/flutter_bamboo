import 'dart:convert';
import 'package:ngf_organic/Helper/api_config.dart';
import 'package:ngf_organic/Models/Product_Detail_Model.dart';
import 'package:ngf_organic/Models/Product_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final searchedProductsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final offersFuture = FutureProvider<Map?>(
  (ref) async {
    final res = await apiCallBack(path: "/app-config/fetch");
    if (!res.error) return res.data;
    return null;
  },
);

final productReviewsFuture = FutureProvider.autoDispose.family<List, int>(
  (ref, productId) async {
    final res = await apiCallBack(
        path: "/products/reviews", body: {"productId": productId});
    if (!res.error) return res.data as List;
    return [];
  },
);

final productListFuture = FutureProvider.family<void, String>(
  (ref, params) async {
    final body = jsonDecode(params);
    final pageNo = body["pageNo"];

    final res = await apiCallBack(path: "/products/fetch", body: body);

    if (!res.error) {
      final dataList = res.data as List;

      if (pageNo == 0) {
        ref.read(productsList.notifier).state = [];
      }

      ref.read(productsList.notifier).state.addAll(
            dataList.map((e) => ProductModel.fromMap(e)),
          );
    }
  },
);

final productDetailsFuture =
    FutureProvider.family.autoDispose<ProductDetailModel?, int>(
  (ref, productId) async {
    final res = await apiCallBack(
      path: "/products/details",
      body: {"productId": productId},
    );

    if (!res.error) {
      return ProductDetailModel.fromMap(res.data);
    }
    return null;
  },
);
