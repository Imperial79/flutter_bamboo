import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/KSearchbar.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/Pill.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Resources/theme.dart';

class Saved_Address_UI extends StatefulWidget {
  const Saved_Address_UI({super.key});

  @override
  State<Saved_Address_UI> createState() => _Saved_Address_UIState();
}

class _Saved_Address_UIState extends State<Saved_Address_UI> {
  final searchKey = TextEditingController();

  @override
  void dispose() {
    searchKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        title: Label("Saved Address").regular,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Flexible(
                    child: KSearchbar(
                      controller: searchKey,
                      hintText: "Search the address here",
                    ),
                  ),
                  KButton(
                    onPressed: () {},
                    label: "Add",
                    radius: 10,
                  )
                ],
              ),
              height10,
              Label("Address list", fontSize: 17).regular,
              ListView.separated(
                separatorBuilder: (context, index) => height10,
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) => KCard(
                  color: KColor.scaffold,
                  borderWidth: 1,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      SvgPicture.asset(
                        "$kIconPath/location.svg",
                        height: 60,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Pill(
                                  label: "main",
                                  backgroundColor: kScheme.tertiaryContainer,
                                  textColor: kScheme.tertiary,
                                ).text,
                                Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: KColor.primary,
                                ),
                              ],
                            ),
                            height10,
                            Label("Avishek Verma").title,
                            Label("+91 9093086276").regular,
                            Label(
                              "Near Hanuman Mandir, Behind Dreamland Hospital Station Bazaar - 713201",
                              weight: 700,
                            ).subtitle,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
