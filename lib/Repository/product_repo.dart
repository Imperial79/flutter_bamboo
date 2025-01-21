import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bamboo/Helper/api_config.dart';
import 'package:flutter_bamboo/Models/Product_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final searchedProductsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final productListFuture = FutureProvider.family<void, String>(
  (ref, params) async {
    try {
      final body = jsonDecode(params);
      final pageNo = body["pageNo"];
      final searchKey = body["searchKey"];
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
    } catch (e) {
      log("$e");
    }
  },
);
