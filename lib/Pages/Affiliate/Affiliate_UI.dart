import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';

import '../../Resources/colors.dart';

class Affiliate_UI extends StatefulWidget {
  const Affiliate_UI({super.key});

  @override
  State<Affiliate_UI> createState() => _Affiliate_UIState();
}

class _Affiliate_UIState extends State<Affiliate_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Label("Wallet", weight: 500).regular,
              ),
              Center(
                child: Label("INR 0.00", fontSize: 22).title,
              ),
              height20,
              KCard(
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.info),
                    Expanded(
                      child: Label(
                        "You're not an affiliator. Apply to become an affiliator.",
                        weight: 500,
                      ).regular,
                    )
                  ],
                ),
              ),
              height20,
              KCard(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label("Benefits").title,
                    height10,
                    Label("1. Earn a percent of every product bought by the user you've referred to.",
                            weight: 500)
                        .regular,
                  ],
                ),
              ),
              height20,
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: KColor.fadeText,
                    fontVariations: [FontVariation.weight(600)],
                  ),
                  children: [
                    const TextSpan(text: "By proceeding you agree to our "),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // await launchUrlString(
                          //     "https://mypostmates.in/terms-conditions");
                        },
                      text: "Terms & Conditions",
                      style: TextStyle(
                        fontVariations: [FontVariation.weight(800)],
                        color: kScheme.primary,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          // await launchUrlString(
                          //     "https://mypostmates.in/terms-conditions");
                        },
                      text: "Privacy Policy",
                      style: TextStyle(
                        fontVariations: [FontVariation.weight(800)],
                        color: kScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              height20,
              Center(
                child: KButton(
                  onPressed: () {},
                  label: "Apply Now",
                  radius: 10,
                  fontSize: 12,
                  backgroundColor: kScheme.tertiary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
