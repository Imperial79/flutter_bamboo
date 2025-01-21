import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
import 'package:flutter_bamboo/Resources/app_config.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Profile_UI extends ConsumerStatefulWidget {
  const Profile_UI({super.key});

  @override
  ConsumerState<Profile_UI> createState() => _Profile_UIState();
}

class _Profile_UIState extends ConsumerState<Profile_UI> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return KScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Label("Profile").regular,
        centerTitle: true,
      ),
      body: SafeArea(
        child: user != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        child: Label(user.name[0].toUpperCase(), fontSize: 22)
                            .regular,
                      ),
                    ),
                    height10,
                    Center(
                      child: Label(user.name).title,
                    ),
                    if (user.phone!.isNotEmpty)
                      Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Label(
                            user.phone!,
                            fontSize: 17,
                            weight: 700,
                          ).subtitle,
                          InkWell(
                            onTap: () => context.push("/edit-profile"),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 15,
                                ),
                                Label("Edit").regular
                              ],
                            ),
                          )
                        ],
                      )
                    else
                      Center(
                        child: InkWell(
                          onTap: () => context.push("/edit-profile"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: LColor.fadeText,
                                size: 20,
                              ),
                              Label("Add phone", fontSize: 17, weight: 700)
                                  .subtitle,
                            ],
                          ),
                        ),
                      ),
                    height20,
                    KCard(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      color: LColor.scaffold,
                      borderWidth: 1,
                      width: double.infinity,
                      child: Column(
                        spacing: 15,
                        children: [
                          _profileBtn(
                            icon: Icons.location_on_outlined,
                            label: "Saved Address",
                            path: "/profile/saved-address",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.inventory_2_outlined,
                            label: "Orders",
                            path: "/profile/orders",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.receipt_long,
                            label: "Transactions",
                            path: "/profile/transactions",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.help,
                            label: "Help",
                            path: "/profile/help",
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
                        child: Label("NGF Organic © ${DateTime.now().year}")
                            .regular),
                    Center(child: Label("Nightbirdes Hub OPC Pvt.").regular),
                  ],
                ),
              )
            : kLoginRequired(context),
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
