import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Login_UI extends StatefulWidget {
  const Login_UI({super.key});

  @override
  State<Login_UI> createState() => _Login_UIState();
}

class _Login_UIState extends State<Login_UI> {
  @override
  Widget build(BuildContext context) {
    return KScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Label("Welcome", fontSize: 20).regular),
                      height20,
                      Label("Sign in or Create\nan account",
                              weight: 600, fontSize: 40)
                          .title,
                      height10,
                      Label(
                        "Choose bamboo and ditch plastic for a better tomorrow!",
                        weight: 600,
                        fontSize: 18,
                      ).subtitle,
                      Label(
                        "Please enter your phone number to start.",
                        weight: 600,
                        fontSize: 18,
                      ).subtitle,
                      height20,
                      KCard(
                        radius: 15,
                        borderColor: LColor.border,
                        color: LColor.scaffold,
                        borderWidth: 1,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          autofillHints: [AutofillHints.telephoneNumber],
                          style: TextStyle(
                            fontSize: 20,
                            fontVariations: [
                              FontVariation.weight(800),
                            ],
                          ),
                          maxLength: 10,
                          maxLines: 1,
                          minLines: 1,
                          decoration: InputDecoration(
                            counter: SizedBox(),
                            label: Label("Phone Number").regular,
                            border: InputBorder.none,
                            prefixText: "+91 ",
                          ),
                        ),
                      ),
                      height10,
                      KButton(
                        onPressed: () => context.push("/"),
                        label: "Continue",
                        fontSize: 20,
                        backgroundColor: kColor(context).primaryContainer,
                        foregroundColor: kColor(context).primary,
                        padding: EdgeInsets.all(20),
                        style: KButtonStyle.expanded,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Label("or continue with", fontSize: 17, weight: 700)
                    .subtitle,
              ),
              height10,
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColor.scaffold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: kRadius(15),
                    side: BorderSide(
                      color: LColor.border,
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    SvgPicture.asset(
                      "$kIconPath/glogo.svg",
                      height: 30,
                    ),
                    Label("Continue with Google", fontSize: 18, weight: 600)
                        .regular,
                  ],
                ),
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
                        color: kColor(context).primary,
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
                        color: kColor(context).primary,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
