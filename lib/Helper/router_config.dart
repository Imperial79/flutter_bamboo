import 'dart:developer';

import 'package:ngf_organic/Models/Response_Model.dart';
import 'package:ngf_organic/Pages/Affiliate/Affiliate_UI.dart';
import 'package:ngf_organic/Pages/Auth/OTP_UI.dart';
import 'package:ngf_organic/Pages/Auth/Register_UI.dart';
import 'package:ngf_organic/Pages/Cart/Cart_UI.dart';
import 'package:ngf_organic/Pages/Cart/Checkout_UI.dart';
import 'package:ngf_organic/Pages/Cart/Confirmation_UI.dart';
import 'package:ngf_organic/Pages/Cart/Coupons_UI.dart';
import 'package:ngf_organic/Pages/Error/Error_UI.dart';
import 'package:ngf_organic/Pages/Error/Path_Error_UI.dart';
import 'package:ngf_organic/Pages/Auth/Login_UI.dart';
import 'package:ngf_organic/Pages/Product/Product_Detail_UI.dart';
import 'package:ngf_organic/Pages/Product/Search_Products_UI.dart';
import 'package:ngf_organic/Pages/Profile/Edit_Profile_UI.dart';
import 'package:ngf_organic/Pages/Profile/Orders/Order_Detail_UI.dart';
import 'package:ngf_organic/Pages/Profile/Orders/Orders_UI.dart';
import 'package:ngf_organic/Pages/Profile/Profile_UI.dart';
import 'package:ngf_organic/Pages/Profile/Saved_Address_UI.dart';
import 'package:ngf_organic/Pages/Profile/Transactions_UI.dart';
import 'package:ngf_organic/Pages/Root_UI.dart';
import 'package:ngf_organic/Pages/Splash_UI.dart';
import 'package:ngf_organic/Pages/TawkTo%20Screens/ContactUs_UI.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final List<String> authRoutes = [
  "/login",
  "/login/otp",
];

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authFuture);

    return GoRouter(
      redirect: (context, state) {
        log("${state.fullPath}");
        if (authState.isLoading) return "/splash";
        if (authState.hasError) return "/error";
        return null;
      },
      redirectLimit: 1,
      initialLocation: '/',
      errorBuilder: (context, state) => Path_Error_UI(),
      routes: [
        GoRoute(
          path: '/error',
          builder: (context, state) => const Error_UI(),
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const Splash_UI(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const Register_UI(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            final data = (state.extra as Map<String, dynamic>);
            final redirectPath = data["redirectPath"];
            final referCode = data["referCode"];

            return Login_UI(
              redirectPath: redirectPath,
              referCode: referCode,
            );
          },
          routes: [
            GoRoute(
              path: 'otp',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                final phone = extra["phone"];
                final redirectPath = extra["redirectPath"];
                final referrerCode = extra["referrerCode"];
                return OTP_UI(
                  phone: phone,
                  redirectPath: redirectPath,
                  referrerCode: referrerCode,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Root_UI(),
        ),
        GoRoute(
          path: '/product/:name/:id',
          builder: (context, state) {
            final id = state.pathParameters["id"];
            final referCode = state.uri.queryParameters["referCode"];
            final sku = state.uri.queryParameters["sku"];
            return Product_Detail_UI(
              id: int.parse("$id"),
              sku: sku,
              referCode: referCode,
            );
          },
        ),
        GoRoute(
          path: '/search-products',
          builder: (context, state) {
            final catgeory = state.uri.queryParameters["category"];
            return Search_Products_UI(
              category: catgeory ?? "All",
            );
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) {
            return const Cart_UI();
          },
          routes: [
            GoRoute(
              path: 'coupons',
              builder: (context, state) {
                return Coupons_UI();
              },
            ),
            GoRoute(
              path: 'checkout',
              builder: (context, state) {
                final data = state.extra as Map;
                return Checkout_UI(
                  checkoutData: data["checkoutData"] as ResponseModel,
                  discountCoupon: data["discountCoupon"],
                );
              },
            ),
            GoRoute(
              path: 'confirmation',
              builder: (context, state) {
                final data = state.extra as Map;
                return Confirmation_UI(
                  deliveryDays: int.parse("${data["deliveryDays"]}"),
                  orderId: data["orderId"],
                  totalItems: int.parse("${data["totalItems"]}"),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: "/affiliate",
          builder: (context, state) => Affiliate_UI(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return const Profile_UI();
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                return const Edit_Profile_UI();
              },
            ),
            GoRoute(
              path: 'saved-address',
              builder: (context, state) {
                return const Saved_Address_UI();
              },
            ),
            GoRoute(
              path: 'orders',
              builder: (context, state) {
                return const Orders_UI();
              },
              routes: [
                GoRoute(
                  path: 'details/:orderedItemId',
                  builder: (context, state) {
                    String orderedItemId =
                        state.pathParameters["orderedItemId"]!;
                    return Order_Detail_UI(
                      orderedItemId: orderedItemId,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'transactions',
              builder: (context, state) {
                return const Transactions_UI();
              },
            ),
          ],
        ),
        GoRoute(
          path: "/chat",
          builder: (context, state) => ContactUsUI(),
        ),
      ],
    );
  },
);
