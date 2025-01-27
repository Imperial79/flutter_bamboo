import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/app_config.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Models/User_Model.dart';
import '../../Repository/auth_repo.dart';
import '../../Resources/theme.dart';

class Login_UI extends ConsumerStatefulWidget {
  const Login_UI({
    super.key,
  });

  @override
  ConsumerState<Login_UI> createState() => _Login_UIState();
}

class _Login_UIState extends ConsumerState<Login_UI> {
  final phone = TextEditingController();
  final isLoading = ValueNotifier(false);

  _signInWithGoogle() async {
    try {
      isLoading.value = true;
      final res = await ref.read(authRepository).signInWithGoogle(ref);

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
        context.go("/");
      } else {
        KSnackbar(context, message: res.message, error: res.error);
      }
    } catch (e) {
      log("$e");
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Label("Welcome", fontSize: 20).regular,
        actions: [
          TextButton(
            onPressed: () {
              context.go("/");
            },
            child: Label(
              "Skip",
              weight: 600,
              color: KColor.primary,
            ).regular,
          ),
        ],
      ),
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
                      Label(
                        "Sign in or Create an account",
                        weight: 800,
                        fontSize: 27,
                      ).title,
                      height10,
                      Label(
                        "Choose Organic and Natural ptoducts and ditch plastic for a better tomorrow!",
                        weight: 600,
                        fontSize: 15,
                      ).subtitle,
                      height20,
                      Label(
                        "Please enter your phone number to start.",
                        weight: 600,
                        fontSize: 15,
                      ).subtitle,
                      height5,
                      KCard(
                        radius: 15,
                        borderColor: KColor.border,
                        color: KColor.scaffold,
                        borderWidth: 1,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: TextField(
                          controller: phone,
                          // autofocus: true,
                          keyboardType: TextInputType.phone,
                          autofillHints: [AutofillHints.telephoneNumber],
                          style: TextStyle(
                            fontSize: 17,
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
                        onPressed: () => context.push(
                          "/login/otp",
                          extra: {
                            "phone": phone.text,
                          },
                        ),
                        label: "Continue",
                        fontSize: 17,
                        backgroundColor: kScheme.primaryContainer,
                        foregroundColor: kScheme.primary,
                        padding: EdgeInsets.all(17),
                        style: KButtonStyle.expanded,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: MediaQuery.of(context).viewInsets.bottom == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child:
                                Label("or continue with", weight: 700).subtitle,
                          ),
                          height10,
                          ElevatedButton(
                            onPressed: _signInWithGoogle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KColor.scaffold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: kRadius(15),
                                side: BorderSide(
                                  color: KColor.border,
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
                                Label("Continue with Google",
                                        fontSize: 17, weight: 600)
                                    .regular,
                              ],
                            ),
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
                                const TextSpan(
                                    text: "By proceeding you agree to our "),
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
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
