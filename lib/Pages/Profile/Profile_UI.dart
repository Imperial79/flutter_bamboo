import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/app_config.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:go_router/go_router.dart';

import '../../Components/kWidgets.dart';

class Profile_UI extends StatefulWidget {
  const Profile_UI({super.key});

  @override
  State<Profile_UI> createState() => _Profile_UIState();
}

class _Profile_UIState extends State<Profile_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Label("Profile").regular,
        centerTitle: true,
      ),
      // body: SafeArea(
      //   child: kLoginRequired(context),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 30,
                  child: Label("A").regular,
                ),
              ),
              height10,
              Center(
                child: Label("Avishek Verma").title,
              ),
              Center(
                child: Label(
                  "+91 9093086276",
                  fontSize: 17,
                  weight: 700,
                ).subtitle,
              ),
              height20,
              Label("Settings").title,
              height10,
              KCard(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                color: LColor.scaffold,
                borderWidth: 1,
                width: double.infinity,
                child: Column(
                  spacing: 15,
                  children: [
                    _profileBtn(
                      icon: Icons.location_on_outlined,
                      label: "Saved Address",
                      path: "/saved-address",
                    ),
                    div,
                    _profileBtn(
                      icon: Icons.inventory_2_outlined,
                      label: "Orders",
                      path: "/orders",
                    ),
                    div,
                    _profileBtn(
                      icon: Icons.help,
                      label: "Help",
                      path: "/help",
                    ),
                  ],
                ),
              ),
              height10,
              Label("Version $kAppVersion").regular,
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "$kImagePath/logo.png",
                    ),
                  ),
                ),
              ),
              Center(
                  child: Label("NGF Organic © ${DateTime.now().year}").regular),
              Center(child: Label("Nightbirdes Hub OPC Pvt.").regular),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileBtn({
    required IconData icon,
    required String label,
    required String path,
  }) {
    return InkWell(
      onTap: () => context.push(path),
      child: Ink(
        child: Row(
          spacing: 20,
          children: [
            Icon(
              icon,
              size: 25,
            ),
            Expanded(
              child: Label(label).regular,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
