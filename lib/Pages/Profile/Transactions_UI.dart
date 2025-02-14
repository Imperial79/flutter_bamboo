// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/constants.dart';
import '../../Components/KScaffold.dart';
import '../../Components/kWidgets.dart';
import '../../Repository/transactions_repo.dart';
import '../../Resources/commons.dart';

class Transactions_UI extends ConsumerStatefulWidget {
  const Transactions_UI({super.key});

  @override
  ConsumerState<Transactions_UI> createState() => _TransactionsUIState();
}

class _TransactionsUIState extends ConsumerState<Transactions_UI> {
  String selectedType = "All";
  int pageNo = 0;
  String filter = "All";
  final List<String> _statusList = [
    "All",
    "Success",
    "Failed",
    "Pending",
  ];

  _refresh() async {
    pageNo = 0;
    await ref.refresh(transactionsFuture(jsonEncode({
      "type": selectedType == "All" ? "Transactions" : selectedType,
      "pageNo": 0,
    })).future);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final transactionsList = ref.watch(transactionsFuture(jsonEncode({
      "type": selectedType == "All" ? "Transactions" : selectedType,
      "pageNo": pageNo,
    })));
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: KScaffold(
        appBar: KAppBar(context, title: "Your Transactions"),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(kPadding).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statusList
                        .map((filter) => _buildFilterChip(filter))
                        .toList(),
                  ),
                ),
                height10,
                transactionsList.when(
                  data: (data) => data.isNotEmpty
                      ? ListView.builder(
                          itemCount: data.length,
                          padding: EdgeInsets.only(bottom: 100),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(
                                text:
                                    "#${data[index][selectedType == "Refunds" ? "refundId" : "orderId"]}",
                              ));
                            },
                            child: Card(
                              color: Kolor.scaffold,
                              margin: EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: kRadius(15),
                                side: BorderSide(
                                  color: Kolor.border,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            TextSpan(
                                              children: [
                                                TextSpan(text: "Transaction "),
                                                TextSpan(
                                                  text: data[index]["status"],
                                                  style: TextStyle(
                                                    color: statusColorMap[
                                                        data[index]["status"]],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "${DateFormat("dd-MM-yyyy").format(DateTime.parse(data[index]["date"]))} • ${DateFormat("hh:mm a").format(DateTime.parse(data[index]["date"]))}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          height5,
                                          Text(
                                            "#${data[index][selectedType == "Refunds" ? "refundId" : "orderId"]}",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width10,
                                    Text(
                                      kCurrencyFormat(data[index]["amount"]),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          shrinkWrap: true,
                        )
                      : kNoData(
                          context,
                          title: "No Transactions!",
                        ),
                  error: (error, stackTrace) => kNoData(
                    context,
                    title: "Oops!",
                    subtitle: "Something Went Wrong.",
                  ),
                  loading: () => kSmallLoading,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SafeArea(
          child: kPagination(
            padding: EdgeInsets.only(left: 25),
            pageNo: pageNo,
            onIncrement: () {
              setState(() {
                pageNo += 1;
              });
            },
            onDecrement: () {
              if (pageNo > 0) {
                setState(() {
                  pageNo -= 1;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget kPagination({
    EdgeInsetsGeometry? padding,
    required int pageNo,
    required Function() onIncrement,
    required Function() onDecrement,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: KCard(
        radius: 6,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        borderWidth: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrement,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.arrow_back,
                size: 18,
              ),
            ),
            width10,
            Label("${pageNo + 1}", fontSize: 17).regular,
            width10,
            IconButton(
              onPressed: onIncrement,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.arrow_forward,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = label == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: kRadius(100),
          side: BorderSide(color: Kolor.border),
        ),
        selected: isActive,
        onSelected: (isSelected) {
          setState(() {
            pageNo = 0;
            filter = label;
          });
        },
        checkmarkColor: Colors.white,
        selectedColor: statusColorMap[label] ?? Kolor.secondary,
        backgroundColor: Kolor.scaffold,
      ),
    );
  }

  // Widget _filterBtns() {
  //   return Row(
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             selectedType = "All";
  //             pageNo = 0;
  //           });
  //         },
  //         child: Chip(
  //           label: Text(
  //             "All",
  //             style: TextStyle(
  //               color: selectedType == "All" ? Colors.white : Colors.black,
  //             ),
  //           ),
  //           backgroundColor:
  //               selectedType == "All" ? Kolor.secondary : Kolor.scaffold,
  //         ),
  //       ),
  //       width10,
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             selectedType = "Refunds";
  //             pageNo = 0;
  //           });
  //         },
  //         child: Chip(
  //           label: Text(
  //             "Refunds",
  //             style: TextStyle(
  //               color: selectedType == "Refunds" ? Colors.white : Colors.black,
  //             ),
  //           ),
  //           backgroundColor:
  //               selectedType == "Refunds" ? Kolor.secondary : Kolor.scaffold,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
