import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Components/Label.dart';
import 'colors.dart';
import 'theme.dart';

const SizedBox width5 = SizedBox(width: 5);
const SizedBox width10 = SizedBox(width: 10);
const SizedBox width15 = SizedBox(width: 15);
const SizedBox width20 = SizedBox(width: 20);
const SizedBox height5 = SizedBox(height: 5);
const SizedBox height10 = SizedBox(height: 10);
const SizedBox height15 = SizedBox(height: 15);
const SizedBox height20 = SizedBox(height: 20);
SizedBox kHeight(double height) => SizedBox(height: height);
SizedBox kWidth(double width) => SizedBox(width: width);

Widget get div => const Divider(
      color: LColor.border,
      thickness: .5,
    );

systemColors() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

BorderRadius kRadius(double radius) => BorderRadius.circular(radius);

Future<T?> navPush<T extends Object?>(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<T?> navPushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<T?> navPopUntilPush<T extends Object?>(
    BuildContext context, Widget screen) {
  Navigator.popUntil(context, (route) => false);
  return navPush(context, screen);
}

KSnackbar(context,
    {required dynamic message, bool error = false, SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:
          error ? kScheme.errorContainer : kScheme.primaryContainer,
      content: Label("$message",
              color:
                  error ? kScheme.onErrorContainer : kScheme.onPrimaryContainer)
          .regular,
      action: action,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

Widget googleLoginButton({required void Function()? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: LColor.scaffold,
      foregroundColor: Colors.black,
      elevation: 0,
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
          height: 25,
        ),
        Label("Continue with Google", fontSize: 17, weight: 600).regular,
      ],
    ),
  );
}
