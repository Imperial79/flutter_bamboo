import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KNavigationBar.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../Resources/commons.dart';
import 'Label.dart';
import 'kButton.dart';

Widget kNoData(BuildContext context, {String? title, String? subtitle}) =>
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "$kIconPath/panda.svg",
            height: 200,
          ),
          height10,
          Label(title ?? "Sorry!", fontSize: 20).title,
          Label(subtitle ?? "No data found.", fontSize: 17, weight: 500)
              .regular,
          height20,
          KButton(
            onPressed: () {
              context.go("/");
            },
            label: "Go Home",
            style: KButtonStyle.regular,
            radius: 100,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            backgroundColor: kScheme.tertiaryContainer,
            foregroundColor: kScheme.tertiary,
          )
        ],
      ),
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
            fontSize: 22,
            textAlign: TextAlign.center,
          ).title,
          height5,
          Label(
            "Please login or create an account to access all the features our app offers.",
            textAlign: TextAlign.center,
            fontSize: 15,
            weight: 500,
          ).subtitle,
          height10,
          KButton(
            onPressed: () {
              activePageNotifier.value = 0;
              context.push("/login");
            },
            label: "Login",
            radius: 7,
            backgroundColor: kScheme.tertiary,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
        ],
      ),
    ),
  );
}
