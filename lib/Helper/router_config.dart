import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Pages/Affiliate/Affiliate_UI.dart';
import 'package:flutter_bamboo/Pages/Auth/OTP_UI.dart';
import 'package:flutter_bamboo/Pages/Cart/Cart_UI.dart';
import 'package:flutter_bamboo/Pages/Cart/Checkout_UI.dart';
import 'package:flutter_bamboo/Pages/Cart/Coupons_UI.dart';
import 'package:flutter_bamboo/Pages/Error/Error_UI.dart';
import 'package:flutter_bamboo/Pages/Auth/Login_UI.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Detail_UI.dart';
import 'package:flutter_bamboo/Pages/Product/Search_Products_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Edit_Profile_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Orders_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Profile_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Saved_Address_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Transactions_UI.dart';
import 'package:flutter_bamboo/Pages/Root_UI.dart';
import 'package:flutter_bamboo/Pages/Splash_UI.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
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
        if (authState.isLoading) return "/splash";
        return null;
      },
      redirectLimit: 1,
      initialLocation: '/',
      errorBuilder: (context, state) => Error_UI(),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const Splash_UI(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return Login_UI();
          },
          routes: [
            GoRoute(
              path: 'otp',
              builder: (context, state) {
                final extra = state.extra;
                final phone =
                    (extra is Map<String, dynamic>) ? extra["phone"] : null;
                return OTP_UI(phone: phone);
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
                return Checkout_UI();
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
            ),
            GoRoute(
              path: 'transactions',
              builder: (context, state) {
                return const Transactions_UI();
              },
            ),
          ],
        ),
      ],
    );
  },
);
