import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:go_router/go_router.dart';

import '../Resources/colors.dart';
import '../Resources/commons.dart';
import 'Label.dart';
import 'kButton.dart';

Widget KHeading({required String title, required String subtitle}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 70),
    child: Center(
      child: Column(
        children: [
          Label(title, fontSize: 25, weight: 800).title,
          Label(
            subtitle,
            fontSize: 20,
            weight: 200,
            textAlign: TextAlign.center,
          ).title,
        ],
      ),
    ),
  );
}

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
            onPressed: () => context.push("/login"),
            label: "Login",
            radius: 10,
            backgroundColor: kColor(context).tertiary,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
        ],
      ),
    ),
  );
}
