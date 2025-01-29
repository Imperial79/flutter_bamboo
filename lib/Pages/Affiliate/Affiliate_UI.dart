// ignore_for_file: unused_result

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kTextfield.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Models/affiliate_model.dart';
import 'package:flutter_bamboo/Repository/affiliate_repo.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
import 'package:flutter_bamboo/Resources/app_config.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Resources/colors.dart';

class Affiliate_UI extends ConsumerStatefulWidget {
  const Affiliate_UI({super.key});

  @override
  ConsumerState<Affiliate_UI> createState() => _Affiliate_UIState();
}

class _Affiliate_UIState extends ConsumerState<Affiliate_UI> {
  final formKey = GlobalKey<FormState>();
  final accNumber = TextEditingController();
  final ifscCode = TextEditingController();
  final accHolderName = TextEditingController();
  final upiId = TextEditingController();
  final panNumber = TextEditingController();
  final isLoading = ValueNotifier(false);
  final pageNo = ValueNotifier(0);
  final status = ValueNotifier("All");

  apply() async {
    try {
      isLoading.value = true;
      final res = await ref.read(affiliateRepo).applyForAffiliate({
        "holderName": accHolderName.text,
        "accNo": accNumber.text,
        "ifsc": ifscCode.text,
        "upi": upiId.text,
        "pan": panNumber.text,
      });

      if (!res.error) {
        ref.refresh(authFuture.future);
      }

      KSnackbar(context, res: res);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    accNumber.dispose();
    ifscCode.dispose();
    accHolderName.dispose();
    upiId.dispose();
    panNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final asyncData = ref.watch(affiliateFuture(
      jsonEncode({
        "pageNo": pageNo.value,
        "status": status.value,
      }),
    ));

    final affiliateList = ref.watch(affiliateListProvider);
    return KScaffold(
      appBar: AppBar(
        title: Label("Affiliate Zone").regular,
        centerTitle: true,
      ),
      isLoading: isLoading,
      body: SafeArea(
        child: user != null
            ? SingleChildScrollView(
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
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 10),
                          Expanded(
                            child: Label(
                              user.affiliateStatus == "Inactive"
                                  ? "You're not an affiliator. Apply to become an affiliator."
                                  : user.affiliateStatus == "Active"
                                      ? "You are an active affiliator. Track your earnings below."
                                      : "Your affiliate status is blocked. Contact customer support for assistance.",
                              weight: 500,
                            ).regular,
                          )
                        ],
                      ),
                    ),
                    if (user.affiliateStatus == "Inactive") ...[
                      height20,
                      affiliateForm()
                    ],
                    height20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label("Product Details", fontSize: 12).regular,
                        Label("Earning", fontSize: 12).regular,
                      ],
                    ),
                    height15,
                    if (asyncData.isLoading && affiliateList.isEmpty)
                      kSmallLoading
                    else if (affiliateList.isNotEmpty)
                      ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 30,
                        ),
                        itemCount: affiliateList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            affiliateRow(affiliateList[index]),
                      )
                    else
                      kNoData(context)
                  ],
                ),
              )
            : kLoginRequired(context),
      ),
    );
  }

  Widget affiliateRow(AffiliateModel data) {
    return Row(
      spacing: 15,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: KColor.card,
            image: DecorationImage(
              image: NetworkImage(
                data.images[0],
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(data.name).regular,
              Label("Qty: ${data.qty} | ${kCurrencyFormat(data.subTotal)}",
                      fontSize: 12, weight: 500)
                  .regular,
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Label(
              kCurrencyFormat(data.commissionAmount, decimalDigits: 2),
            ).regular,
            Label(
              data.commissionStatus,
              color: statusColorMap[data.commissionStatus],
              fontSize: 12,
            ).regular,
          ],
        )
      ],
    );
  }

  Widget affiliateForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          div,
          height20,
          Label("Bank Details").title,
          height20,
          KTextfield(
            controller: accNumber,
            label: "A/C Number",
            hintText: "Enter Account Number",
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (val) => KValidation.required(val),
          ).regular,
          height10,
          KTextfield(
            controller: ifscCode,
            label: "IFSC Code",
            hintText: "Eg. SBIN1992",
            textCapitalization: TextCapitalization.characters,
            validator: (val) => KValidation.required(val),
          ).regular,
          height10,
          KTextfield(
            controller: accHolderName,
            label: "Account Holder Name",
            hintText: "Eg. John Doe",
            autofillHints: [AutofillHints.name],
            validator: (val) => KValidation.required(val),
          ).regular,
          height10,
          KTextfield(
            controller: upiId,
            label: "UPI ID",
            hintText: "Eg. johndoe@axl",
            validator: (val) => KValidation.required(val),
          ).regular,
          height10,
          KTextfield(
            controller: panNumber,
            label: "PAN Number",
            hintText: "Eg. CADPV1116R",
            textCapitalization: TextCapitalization.characters,
            validator: (val) => KValidation.pan(val),
          ).regular,
          height20,
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: KColor.fadeText,
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
                    fontVariations: [FontVariation.weight(700)],
                    color: kScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          height20,
          Center(
            child: KButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  apply();
                }
              },
              label: "Apply Now",
              radius: 5,
              backgroundColor: kScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
