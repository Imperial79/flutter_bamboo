import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KNavigationBar.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../Resources/commons.dart';
import 'Label.dart';
import 'kButton.dart';

Widget kNoData(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "$kIconPath/panda.svg",
          height: 200,
        ),
        height10,
        Label("Sorry!", fontSize: 30).title,
        Label("No data found.", fontSize: 22, weight: 500).regular,
        height20,
        KButton(
          onPressed: () {
            context.go("/");
          },
          label: "Go Home",
          style: KButtonStyle.regular,
          radius: 100,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          backgroundColor: kScheme.secondaryContainer,
          foregroundColor: kScheme.secondary,
        )
      ],
    );

Widget kLoginRequired(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Label(
            "Login Required",
            fontSize: 25,
            textAlign: TextAlign.center,
          ).title,
          Label(
            "Please login or create an account to access all the features our app offers.",
            textAlign: TextAlign.center,
            fontSize: 17,
            weight: 600,
          ).subtitle,
          height10,
          KButton(
            onPressed: () {
              activePageNotifier.value = 0;
              context.push("/login");
            },
            label: "Login",
            radius: 10,
            backgroundColor: kScheme.tertiary,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
        ],
      ),
    ),
  );
}
