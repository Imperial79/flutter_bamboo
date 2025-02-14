import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kTextfield.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_auth/smart_auth.dart';
import '../../Models/User_Model.dart';
import '../../Repository/auth_repo.dart';

class Login_UI extends ConsumerStatefulWidget {
  final String? redirectPath;
  final String? referCode;
  const Login_UI({
    super.key,
    this.redirectPath,
    this.referCode,
  });

  @override
  ConsumerState<Login_UI> createState() => _Login_UIState();
}

class _Login_UIState extends ConsumerState<Login_UI> {
  final phone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = ValueNotifier(false);

  selectPhone() async {
    final res = await SmartAuth.instance.requestPhoneNumberHint();
    if (res.hasData) {
      setState(() {
        phone.text = res.requireData.substring(res.requireData.length - 10);
        _signInWithPhone();
      });
    }
  }

  _signInWithGoogle() async {
    try {
      isLoading.value = true;
      log("Refercode (Login) - ${widget.referCode} | Redirect - ${widget.redirectPath}");
      final res = await ref.read(authRepository).signInWithGoogle(
            ref,
            referrerCode: widget.referCode,
          );

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
        context.go(widget.redirectPath ?? "/");
      } else {
        KSnackbar(context, message: res.message, error: res.error);
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  _signInWithPhone() async {
    try {
      final error = KValidation.phone(phone.text);
      if (error == null) {
        context.push("/login/otp", extra: {
          "phone": phone.text,
          "redirectPath": widget.redirectPath,
          "referrerCode": widget.referCode,
        });
      } else {
        KSnackbar(context, message: error, error: true);
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
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
          child: Form(
            key: formKey,
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
                          weight: 700,
                          fontSize: 27,
                        ).title,
                        height10,
                        Label(
                          "Choose Organic and Natural products and ditch plastic for a better tomorrow!",
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
                          child: TextFormField(
                            controller: phone,
                            onTap: phone.text.isEmpty ? selectPhone : null,
                            keyboardType: TextInputType.phone,
                            autofillHints: [AutofillHints.telephoneNumber],
                            style: TextStyle(
                              fontSize: 17,
                              fontVariations: [
                                FontVariation.weight(650),
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
                          onPressed: _signInWithPhone,
                          label: "Continue",
                          fontSize: 17,
                          backgroundColor: kColor(context).primaryContainer,
                          foregroundColor: kColor(context).primary,
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
                          children: [
                            Label("or continue with", weight: 550).subtitle,
                            height10,
                            googleLoginButton(onPressed: _signInWithGoogle),
                            height15,
                            kTermsAndPrivacy(),
                          ],
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
