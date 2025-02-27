import 'package:ngf_organic/Helper/api_config.dart';
import 'package:ngf_organic/Models/Cart/Cart_Model.dart';
import 'package:ngf_organic/Models/Response_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartFuture = FutureProvider.autoDispose<List<CartModel>>((ref) async {
  final res = await apiCallBack(path: "/cart/fetch-details");
  if (!res.error) {
    return (res.data as List)
        .map(
          (e) => CartModel.fromMap(e),
        )
        .toList();
  }
  return [];
});

final cartRepo = Provider(
  (ref) => CartRepo(),
);

class CartRepo {
  Future<ResponseModel> updateCart(Map<String, dynamic> body) async {
    try {
      final res = await apiCallBack(path: "/cart/update", body: body);
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> deleteCartItem(int productVariantId) async {
    try {
      final res = await apiCallBack(path: "/cart/delete", body: {
        "productVariantId": productVariantId,
      });
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> checkout(
    String shippingState,
    String? discountCoupon,
  ) async {
    try {
      final res = await apiCallBack(path: "/shopping/checkout", body: {
        "shippingState": shippingState,
        "discountCoupon": discountCoupon,
      });
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> generatePayment(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await apiCallBack(
        path: "/shopping/generate-payment-order",
        body: body,
      );
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> verifyPayment({
    required String paymentId,
  }) async {
    try {
      final res = await apiCallBack(
        path: "/shopping/verify-payment",
        body: {
          "paymentId": paymentId,
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
