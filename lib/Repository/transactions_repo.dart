import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Helper/api_config.dart';

final transactionsFuture = FutureProvider.family.autoDispose<List, String>(
  (ref, data) async {
    try {
      final body = jsonDecode(data);
      final res = await apiCallBack(
        path: "/passbook/fetch",
        body: {
          "type": body["type"],
          "pageNo": body["pageNo"],
        },
      );

      if (!res.error) {
        return res.data;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  },
);
