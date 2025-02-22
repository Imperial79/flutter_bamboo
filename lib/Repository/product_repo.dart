import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ngf_organic/Helper/api_config.dart';
import 'package:ngf_organic/Models/Product_Detail_Model.dart';
import 'package:ngf_organic/Models/Product_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngf_organic/Models/Response_Model.dart';

final productsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final searchedProductsList = StateProvider<List<ProductModel>>(
  (ref) => [],
);

final offersFuture = FutureProvider.autoDispose<Map?>(
  (ref) async {
    ResponseModel res = ResponseModel(error: false, message: "message");
    final hiveBox = Hive.box('hiveBox');
    final hiveBanner = hiveBox.get('banners') ?? {};

    // Extracting stored data and date
    final storedData = hiveBanner['data'];
    final storedDate = hiveBanner['date'];

    // Check if data is null or date is null or date is not today
    if (storedData == null ||
        storedDate == null ||
        (storedDate is! DateTime) ||
        storedDate.day != DateTime.now().day ||
        storedDate.month != DateTime.now().month ||
        storedDate.year != DateTime.now().year) {
      // Fetch from API since data is missing or outdated
      res = await apiCallBack(path: "/app-config/fetch");
      if (!res.error) {
        await hiveBox
            .put('banners', {'data': res.data, 'date': DateTime.now()});
        return res.data;
      }
    } else {
      // Use the stored data
      res.data = storedData;
    }

    return res.data;
  },
);

final productReviewsFuture = FutureProvider.autoDispose.family<List, int>(
  (ref, productId) async {
    final res = await apiCallBack(
        path: "/products/reviews", body: {"productId": productId});
    if (!res.error) {
      // res.data["banners"]

      return res.data as List;
    }

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
