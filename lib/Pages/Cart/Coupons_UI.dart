// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Models/Cart/coupon_model.dart';
import 'package:ngf_organic/Repository/coupon_repo.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Coupons_UI extends ConsumerStatefulWidget {
  const Coupons_UI({super.key});

  @override
  ConsumerState<Coupons_UI> createState() => _Coupons_UIState();
}

class _Coupons_UIState extends ConsumerState<Coupons_UI> {
  _refresh() async {
    await ref.refresh(couponFuture.future);
  }

  @override
  Widget build(BuildContext context) {
    final offerData = ref.watch(couponFuture);

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
        appBar: KAppBar(
          context,
          title: "Coupons & Offers",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                offerData.when(
                  data: (data) => data.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              couponTile(data[index]),
                          separatorBuilder: (context, index) => height10,
                          itemCount: data.length,
                        )
                      : kNoData(
                          context,
                          title: "No Offers!",
                          showHome: false,
                        ),
                  error: (error, stackTrace) => kNoData(
                    context,
                    subtitle: "$error",
                    showHome: false,
                  ),
                  loading: () => Skeletonizer(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          couponTile(CouponModel.fromMap({})),
                      separatorBuilder: (context, index) => height10,
                      itemCount: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget couponTile(CouponModel data) {
    return KCard(
      onTap: () {
        context.pop(data.toMap());
      },
      child: Row(
        spacing: 20,
        children: [
          KCard(
            color: Kolor.scaffold,
            padding: EdgeInsets.all(15),
            width: 70,
            height: 70,
            child: FittedBox(
              child: Label("${(data.offPercent).round()}%", fontSize: 25).title,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(data.coupon, weight: 700).regular,
                Label(data.description).subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
