import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Resources/app_config.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
              Label("Verification", weight: 800, fontSize: 27).title,
              height10,
              Label(
                "Please enter the OTP received on +91 ${widget.phone}.",
                weight: 600,
                fontSize: 15,
              ).subtitle,
              height20,
              buildOtpField(),
              height10,
              KButton(
                onPressed: () => context.push("/"),
                label: "Continue",
                fontSize: 17,
                backgroundColor: kScheme.primaryContainer,
                foregroundColor: kScheme.primary,
                padding: EdgeInsets.all(17),
                style: KButtonStyle.expanded,
              ),
              height10,
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
                          await launchUrlString(termsConditionLink);
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
                          await launchUrlString(privacyPolicyLink);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpField() {
    return KCard(
      radius: 15,
      borderColor: KColor.border,
      color: KColor.scaffold,
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
                label: Label(
                  "One Time Password (OTP)",
                  color: KColor.fadeText,
                  weight: 600,
                ).regular,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sync_sharp,
              size: 25,
              color: KColor.fadeText,
            ),
            visualDensity: VisualDensity.compact,
          ),
          Label("25s", fontSize: 17, weight: 600).subtitle,
        ],
      ),
    );
  }
}
