import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:go_router/go_router.dart';

import '../../Resources/theme.dart';

class OTP_UI extends StatefulWidget {
  final String phone;
  const OTP_UI({super.key, required this.phone});

  @override
  State<OTP_UI> createState() => _OTP_UIState();
}

class _OTP_UIState extends State<OTP_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("Verification", weight: 600, fontSize: 40).title,
              height10,
              Label(
                "Please enter the OTP received on +91 ${widget.phone}.",
                weight: 600,
                fontSize: 18,
              ).subtitle,
              height20,
              buildOtpField(),
              height10,
              KButton(
                onPressed: () => context.push("/"),
                label: "Continue",
                fontSize: 20,
                backgroundColor: kScheme.primaryContainer,
                foregroundColor: kScheme.primary,
                padding: EdgeInsets.all(20),
                style: KButtonStyle.expanded,
              ),
              height10,
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 17,
                    color: LColor.fadeText,
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
                        fontVariations: [FontVariation.weight(700)],
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
                        fontVariations: [FontVariation.weight(700)],
                        color: kScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpField() {
    return KCard(
      radius: 15,
      borderColor: LColor.border,
      color: LColor.scaffold,
      borderWidth: 1,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          Flexible(
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.phone,
              autofillHints: [AutofillHints.telephoneNumber],
              style: TextStyle(
                fontSize: 25,
                fontVariations: [
                  FontVariation.weight(800),
                ],
              ),
              maxLength: 6,
              maxLines: 1,
              minLines: 1,
              decoration: InputDecoration(
                counter: SizedBox(),
                contentPadding: EdgeInsets.all(0),
                floatingLabelStyle: TextStyle(
                  fontVariations: [FontVariation.weight(900)],
                  fontSize: 20,
                  letterSpacing: 1,
                ),
                label: Label("One Time Password (OTP)").regular,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sync_sharp,
              size: 30,
            ),
            visualDensity: VisualDensity.compact,
          ),
          Label("25s", fontSize: 20, weight: 700).subtitle,
        ],
      ),
    );
  }
}
