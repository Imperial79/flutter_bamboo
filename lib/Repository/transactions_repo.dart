import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Helper/api_config.dart';

final transactionsFuture = FutureProvider.family.autoDispose<List, String>(
  (ref, data) async {
    try {
      log(data);
      final body = jsonDecode(data);
      final res = await apiCallBack(
        path: "/passbook/fetch",
        body: body,
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
