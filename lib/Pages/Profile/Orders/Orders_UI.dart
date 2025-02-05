// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Repository/orderHistory_repo.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Orders_UI extends ConsumerStatefulWidget {
  const Orders_UI({super.key});

  @override
  ConsumerState<Orders_UI> createState() => _Orders_UIState();
}

class _Orders_UIState extends ConsumerState<Orders_UI> {
  final pageNo = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  _refresh() async {
    await ref.refresh(orderHistoryFuture(pageNo.value).future);
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderHistoryFuture(pageNo.value));

    final user = ref.watch(userProvider);
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
        appBar: KAppBar(
          context,
          title: "Orders",
        ),
        body: SafeArea(
          child: user != null
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: orderData.when(
                    data: (data) => data.isNotEmpty
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => div,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) =>
                                _orderItem(data[index]),
                            padding: EdgeInsets.all(kPadding),
                          )
                        : kNoData(context,
                            showHome: false, subtitle: "No Orders!"),
                    error: (error, stackTrace) =>
                        kNoData(context, showHome: false),
                    loading: () => LinearProgressIndicator(),
                  ),
                )
              : kLoginRequired(context),
        ),
      ),
    );
  }

  Widget _orderItem(Map<String, dynamic> data) {
    return InkWell(
      onTap: () => context.push("/profile/orders/details/${data["id"]}"),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          spacing: 15,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    data["images"].split("#_#")[0],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(data["name"]).regular,
                  Label("Ordered on - ${kDateFormat(data["orderDate"])}")
                      .subtitle,
                  height5,
                  KCard(
                    color: kOpacity(
                        statusColorMap[data["status"]] ?? KColor.secondary, .1),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    radius: 100,
                    child: Label(data["status"],
                            color: statusColorMap[data["status"]], fontSize: 12)
                        .regular,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: KColor.fadeText,
            )
          ],
        ),
      ),
    );
  }

  // Widget _choice(String label) {
  //   return ChoiceChip(
  //     label: Label(label).regular,
  //     selected: selectedFilter == label,
  //     selectedColor: label == "Cancelled"
  //         ? kScheme.errorContainer
  //         : kScheme.primaryContainer,
  //     onSelected: (value) {
  //       setState(() {
  //         selectedFilter = label;
  //       });
  //     },
  //   );
  // }
}
