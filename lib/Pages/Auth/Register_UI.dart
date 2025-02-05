import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kTextfield.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Resources/theme.dart';

class Register_UI extends ConsumerStatefulWidget {
  final String? redirectPath;
  final String? referCode;
  const Register_UI({
    super.key,
    this.redirectPath,
    this.referCode,
  });

  @override
  ConsumerState<Register_UI> createState() => _Login_UIState();
}

class _Login_UIState extends ConsumerState<Register_UI> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = ValueNotifier(false);

  _register() async {
    try {
      isLoading.value = true;
      if (formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      appBar: KAppBar(context, title: "Register"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          "Create your account",
                          weight: 700,
                          fontSize: 25,
                        ).title,
                        height10,
                        Label(
                          "Choose Organic and Natural products and ditch plastic for a better tomorrow!",
                          weight: 600,
                          fontSize: 15,
                        ).subtitle,
                        height20,
                        KTextfield(
                          label: "Name",
                          hintText: "Eg. John Doe",
                          fontSize: 17,
                          prefix: Icon(
                            Icons.person_rounded,
                            size: 25,
                          ),
                          showRequired: false,
                          autofillHints: [AutofillHints.name],
                          validator: (val) => KValidation.required(val),
                        ).regular,
                        height15,
                        KTextfield(
                          label: "Phone (+91)",
                          prefixText: "+91",
                          hintText: "909XXXXXX7",
                          showRequired: false,
                          keyboardType: TextInputType.phone,
                          autofillHints: [AutofillHints.telephoneNumber],
                          maxLength: 10,
                          fontSize: 17,
                          validator: (val) => KValidation.phone(val),
                        ).regular,
                        height15,
                        KTextfield(
                          label: "Email (Optional)",
                          hintText: "Eg. example@example.com",
                          prefix: Icon(
                            Icons.alternate_email_rounded,
                            size: 25,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          fontSize: 17,
                        ).regular,
                        height15,
                        KButton(
                          onPressed: _register,
                          label: "Register",
                          fontSize: 17,
                          backgroundColor: kScheme.primaryContainer,
                          foregroundColor: kScheme.primary,
                          padding: EdgeInsets.all(17),
                          style: KButtonStyle.expanded,
                        ),
                        height15,
                        kTermsAndPrivacy(),
                      ],
                    ),
                  ),
                ),
              ),
              // AnimatedSwitcher(
              //   duration: Duration(milliseconds: 250),
              //   child: MediaQuery.of(context).viewInsets.bottom == 0
              //       ? Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Center(
              //               child:
              //                   Label("or continue with", weight: 700).subtitle,
              //             ),
              //             height10,
              //             ElevatedButton(
              //               onPressed: _signInWithGoogle,
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: KColor.scaffold,
              //                 foregroundColor: Colors.black,
              //                 elevation: 0,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: kRadius(15),
              //                   side: BorderSide(
              //                     color: KColor.border,
              //                   ),
              //                 ),
              //                 padding: EdgeInsets.all(15),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 spacing: 10,
              //                 children: [
              //                   SvgPicture.asset(
              //                     "$kIconPath/glogo.svg",
              //                     height: 25,
              //                   ),
              //                   Label("Continue with Google",
              //                           fontSize: 17, weight: 600)
              //                       .regular,
              //                 ],
              //               ),
              //             ),
              //             height20,
              //             Center(
              //               child: Text.rich(
              //                 TextSpan(
              //                   style: TextStyle(
              //                     fontSize: 15,
              //                     color: KColor.fadeText,
              //                     fontVariations: [FontVariation.weight(600)],
              //                   ),
              //                   children: [
              //                     const TextSpan(
              //                         text: "Don't have an account? "),
              //                     TextSpan(
              //                       recognizer: TapGestureRecognizer()
              //                         ..onTap = () => context.push("/register"),
              //                       text: "Create Account",
              //                       style: TextStyle(
              //                         fontVariations: [
              //                           FontVariation.weight(700)
              //                         ],
              //                         color: KColor.primary,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             // height10,
              //             // Text.rich(
              //             //   TextSpan(
              //             //     style: TextStyle(
              //             //       fontSize: 15,
              //             //       color: KColor.fadeText,
              //             //       fontVariations: [FontVariation.weight(600)],
              //             //     ),
              //             //     children: [
              //             //       const TextSpan(
              //             //           text: "By proceeding you agree to our "),
              //             //       TextSpan(
              //             //         recognizer: TapGestureRecognizer()
              //             //           ..onTap = () async {
              //             //             await launchUrlString(termsConditionLink);
              //             //           },
              //             //         text: "Terms & Conditions",
              //             //         style: TextStyle(
              //             //           fontVariations: [FontVariation.weight(800)],
              //             //           color: kScheme.primary,
              //             //         ),
              //             //       ),
              //             //       const TextSpan(text: " and "),
              //             //       TextSpan(
              //             //         recognizer: TapGestureRecognizer()
              //             //           ..onTap = () async {
              //             //             await launchUrlString(privacyPolicyLink);
              //             //           },
              //             //         text: "Privacy Policy",
              //             //         style: TextStyle(
              //             //           fontVariations: [FontVariation.weight(800)],
              //             //           color: kScheme.primary,
              //             //         ),
              //             //       ),
              //             //     ],
              //             //   ),
              //             // ),
              //           ],
              //         )
              //       : SizedBox(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
