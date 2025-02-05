import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Path_Error_UI extends StatelessWidget {
  const Path_Error_UI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "$kIconPath/error-404.svg",
                  height: 200,
                ),
                height20,
                Label("Page Not Found!", fontSize: 30, weight: 700).title,
                Label(
                  "Sorry we cannot find the requested page!",
                  fontSize: 17,
                  weight: 500,
                  textAlign: TextAlign.center,
                ).subtitle,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: KButton(
            onPressed: () => context.go("/"),
            label: "Go Home",
          ),
        ),
      ),
    );
  }
}
