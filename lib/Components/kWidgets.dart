import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KNavigationBar.dart';
import 'package:ngf_organic/Repository/cart_repo.dart';
import 'package:ngf_organic/Resources/app_config.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Resources/colors.dart';
import '../Resources/commons.dart';
import 'Label.dart';
import 'kButton.dart';

Widget kNoData(
  BuildContext context, {
  String? title,
  Widget? action,
  String? subtitle,
  bool? showHome = false,
}) =>
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
          Label(
            subtitle ?? "No data found.",
            fontSize: 17,
            weight: 500,
            textAlign: TextAlign.center,
          ).regular,
          height20,
          if (action == null && showHome!)
            KButton(
              onPressed: () {
                context.go("/");
              },
              label: "Go Home",
              style: KButtonStyle.regular,
              radius: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              backgroundColor: kColor(context).tertiaryContainer,
              foregroundColor: kColor(context).tertiary,
            ),
          if (action != null) action
        ],
      ),
    );

Widget kLoginRequired(BuildContext context, {String redirectPath = ""}) {
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
              context.push("/login", extra: {"redirectPath": redirectPath});
            },
            label: "Login",
            radius: 7,
            backgroundColor: kColor(context).tertiary,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
        ],
      ),
    ),
  );
}

Widget kAmount(
  dynamic amount, {
  double fontSize = 25,
  double? symbolSize,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Label("₹", fontSize: symbolSize ?? (fontSize - 5), height: 1.1).regular,
      Expanded(
        child: Label(
          kCurrencyFormat(
            parseToDouble(amount),
            symbol: "",
          ),
          fontSize: fontSize,
          height: 1,
          weight: 600,
        ).title,
      ),
    ],
  );
}

Widget KCartIcon() {
  return Consumer(
    builder: (context, ref, child) {
      final cartData = ref.watch(cartFuture);
      return cartData.when(
        data: (data) => IconButton(
          onPressed: () => context.push("/cart"),
          icon: Badge(
            offset: Offset(10, 10),
            isLabelVisible: data.isNotEmpty,
            label: Label("${data.length}", fontSize: 10).regular,
            child: SvgPicture.asset(
              data.isNotEmpty
                  ? "$kIconPath/shopping-bag-filled.svg"
                  : "$kIconPath/shopping-bag.svg",
              height: 20,
              colorFilter: kSvgColor(
                data.isNotEmpty ? Kolor.primary : Colors.black,
              ),
            ),
          ),
        ),
        error: (error, stackTrace) => IconButton(
          onPressed: () => context.push("/cart"),
          icon: SvgPicture.asset(
            "$kIconPath/shopping-bag.svg",
            height: 20,
          ),
        ),
        loading: () => IconButton(
          onPressed: () => context.push("/cart"),
          icon: SvgPicture.asset(
            "$kIconPath/shopping-bag.svg",
            height: 20,
          ),
        ),
      );
    },
  );
}

Widget kTermsAndPrivacy() {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Colors.grey.shade700,
        fontVariations: [FontVariation.weight(500)],
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
            fontVariations: [FontVariation.weight(700)],
            color: StatusText.info,
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
            fontVariations: [FontVariation.weight(700)],
            color: StatusText.info,
          ),
        ),
      ],
    ),
  );
}
