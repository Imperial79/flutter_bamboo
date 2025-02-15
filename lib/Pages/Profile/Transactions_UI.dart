// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final List<String> _statusList = [
    "All",
    "Refunds",
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
            physics: AlwaysScrollableScrollPhysics(),
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
                      ? ListView.separated(
                          separatorBuilder: (context, index) => height10,
                          itemCount: data.length,
                          padding: EdgeInsets.only(bottom: 100),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildTransactionTile(data[index]),
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

  Widget buildTransactionTile(Map<String, dynamic> data) {
    return KCard(
      onTap: () async {
        await Clipboard.setData(ClipboardData(
          text: "#${data[selectedType == "Refunds" ? "refundId" : "orderId"]}",
        ));

        KSnackbar(context, message: "Order Id copied to clipboard!");
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  style: TextStyle(fontVariations: [FontVariation.weight(600)]),
                  TextSpan(
                    children: [
                      TextSpan(
                          text: selectedType == "Refunds"
                              ? "Refund "
                              : "Transaction "),
                      TextSpan(
                        text: data["status"],
                        style: TextStyle(
                          color: statusColors[data["status"]],
                        ),
                      ),
                    ],
                  ),
                ),
                Label(
                  kDateFormat(data["date"], showTime: true),
                  weight: 600,
                  fontSize: 12,
                ).subtitle,
                height5,
                Label(
                  "#${data[selectedType == "Refunds" ? "refundId" : "orderId"]}",
                  fontSize: 12,
                  weight: 600,
                ).subtitle,
              ],
            ),
          ),
          width10,
          Label(
            kCurrencyFormat(data["amount"]),
          ).regular,
        ],
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
    final isActive = label == selectedType;

    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: ChoiceChip(
        label: Label(
          label,
          color: isActive ? Colors.white : Colors.black,
        ).regular,
        shape: RoundedRectangleBorder(
          borderRadius: kRadius(100),
          side: BorderSide(color: Kolor.border),
        ),
        selected: isActive,
        onSelected: (isSelected) {
          setState(() {
            pageNo = 0;
            selectedType = label;
          });
        },
        checkmarkColor: Colors.white,
        selectedColor: statusColors[label] ?? Kolor.secondary,
        backgroundColor: Kolor.scaffold,
      ),
    );
  }
}
