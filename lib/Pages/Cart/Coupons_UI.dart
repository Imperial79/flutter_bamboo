// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Repository/coupon_repo.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        appBar: AppBar(
          title: Label("Offers").regular,
          centerTitle: true,
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
                          itemBuilder: (context, index) => KCard(
                            onTap: () {
                              context.pop(data[index].toMap());
                            },
                            child: Row(
                              spacing: 20,
                              children: [
                                Label("${(data[index].offPercent * 100).round()}%",
                                        fontSize: 25)
                                    .title,
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Label(data[index].coupon, weight: 700)
                                        .regular,
                                    Label(data[index].description).subtitle,
                                  ],
                                )),
                              ],
                            ),
                          ),
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
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
