import 'dart:developer';
import 'package:flutter_bamboo/Pages/Error/Error_UI.dart';
import 'package:flutter_bamboo/Pages/Login_UI.dart';
import 'package:flutter_bamboo/Pages/Product/Product_Detail_UI.dart';
import 'package:flutter_bamboo/Pages/Root_UI.dart';
import 'package:flutter_bamboo/Pages/Splash_UI.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final List<String> authRoutes = [
  "/login",
  "/register",
];

final List<String> unProtectedRoutes = [
  ...authRoutes,
  "/splash",
  "/",
  "/product/:id",
  "/cart"
];

final List<String> protectedRoutes = [
  "/splash",
  "/",
  "/product/:id",
  "/cart",
  "/checkout",
  "/confirmation",
  "/offers",
  "/affiliate",
  "/membership",
];

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    // final authState = ref.watch(authFuture);
    // final user = ref.watch(userProvider);
    // bool isLoading = false;
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        log(state.fullPath ?? "");

        return null;
      },
      // redirect: (context, state) {
      //   if (isLoading) return '/splash';
      //   // if (user == null && protectedRoutes.contains(state.fullPath)) return '/login';
      //   // if (user != null && authRoutes.contains(state.fullPath)) return '/';
      //   return null;
      // },

      errorBuilder: (context, state) => Error_UI(),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const Splash_UI(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Login_UI(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Root_UI(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = state.pathParameters["id"];
            return Product_Detail_UI(id: id ?? "");
          },
        ),

        // GoRoute(
        //   path: '/courier',
        //   builder: (context, state) => const Courier_UI(),
        //   routes: [
        //     GoRoute(
        //       path: 'package',
        //       builder: (context, state) {
        //         final extra = state.extra;
        //         final masterdata = (extra is Map<String, dynamic>)
        //             ? extra["masterdata"]
        //             : null;

        //         return Package_UI(
        //           masterdata: masterdata,
        //         );
        //       },
        //     ),
        //     GoRoute(
        //       path: 'schedule',
        //       builder: (context, state) {
        //         final extra = state.extra;
        //         final masterdata = (extra is Map<String, dynamic>)
        //             ? extra["masterdata"]
        //             : null;

        //         return Schedule_UI(
        //           masterdata: masterdata,
        //         );
        //       },
        //     ),
        //     GoRoute(
        //       path: 'checkout',
        //       builder: (context, state) {
        //         final extra = state.extra;
        //         final masterdata = (extra is Map<String, dynamic>)
        //             ? extra["masterdata"]
        //             : null;

        //         return Checkout_UI(
        //           masterdata: masterdata,
        //         );
        //       },
        //     ),
        //     GoRoute(
        //       path: 'confirmation',
        //       builder: (context, state) {
        //         final extra = state.extra;
        //         final awbNumber =
        //             (extra is Map<String, dynamic>) ? extra["awbNumber"] : null;

        //         return Confirmation_UI(
        //           awbNumber: awbNumber,
        //         );
        //       },
        //     ),
        //   ],
        // ),
        // GoRoute(
        //   path: '/addresses',
        //   builder: (context, state) => const Addresses_UI(),
        // ),
        // GoRoute(
        //   path: '/calculate',
        //   builder: (context, state) => const CalculateUI(),
        //   routes: [
        //     GoRoute(
        //       path: 'calculated-result',
        //       builder: (context, state) {
        //         final extra = state.extra;
        //         final amount =
        //             (extra is Map<String, dynamic>) ? extra["amount"] : null;
        //         return CalculatedResultUI(
        //           amount: amount,
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  },
);
