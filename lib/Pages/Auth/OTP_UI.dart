import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Models/User_Model.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_auth/smart_auth.dart';

class OTP_UI extends ConsumerStatefulWidget {
  final String phone;
  final String? redirectPath;
  final String? referrerCode;
  const OTP_UI(
      {super.key, required this.phone, this.redirectPath, this.referrerCode});

  @override
  ConsumerState<OTP_UI> createState() => _OTP_UIState();
}

class _OTP_UIState extends ConsumerState<OTP_UI> {
  final isLoading = ValueNotifier(false);
  final otp = TextEditingController();
  final smartAuth = SmartAuth.instance;
  String appSignature = "";
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => onSendOtp(),
    );
  }

  onSendOtp() async {
    final res = await smartAuth.getAppSignature();
    setState(() => appSignature = res.data ?? "");
    smsRetriever();
    await _sendOtp();
  }

  Future<void> smsRetriever() async {
    final res = await smartAuth.getSmsWithRetrieverApi();
    log("$res");
    if (res.hasData) {
      final code = res.requireData.code;

      if (code == null) return;

      setState(() {
        otp.text = code;
        otp.selection = TextSelection.fromPosition(
          TextPosition(offset: otp.text.length),
        );
      });
    }
  }

  void _startCountdown() {
    _counter = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_counter > 0) {
        if (mounted) {
          setState(() {
            _counter--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _counter = 0;
          });
        }
      }
    });
  }

  _sendOtp() async {
    try {
      isLoading.value = true;
      log(appSignature);
      final res = await ref
          .read(authRepository)
          .sendOtp(phone: widget.phone, appSignature: appSignature);

      _startCountdown();
      KSnackbar(context, res: res);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  _loginWithPhone() async {
    try {
      isLoading.value = true;
      final res = await ref.read(authRepository).loginWithPhone(
            phone: widget.phone,
            otp: otp.text,
            referrerCode: widget.referrerCode,
          );

      KSnackbar(context, res: res);
      ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
      context.go("/");
    } catch (e) {
      KSnackbar(context, message: '$e', error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    smartAuth.removeSmsRetrieverApiListener();
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      isLoading: isLoading,
      appBar: KAppBar(context, title: "One Time Passcode"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("Verification", weight: 700, fontSize: 27).title,
              height10,
              Label(
                "Please enter the OTP received via SMS on",
                weight: 550,
                fontSize: 15,
              ).subtitle,
              Label(
                "+91 ${widget.phone}",
                weight: 600,
                fontSize: 15,
                color: kColor(context).primary,
              ).subtitle,
              height20,
              buildOtpField(),
              height10,
              KButton(
                onPressed: otp.text.isNotEmpty ? _loginWithPhone : null,
                label: "Continue",
                fontSize: 17,
                backgroundColor: kColor(context).primaryContainer,
                foregroundColor: kColor(context).primary,
                padding: EdgeInsets.all(17),
                style: KButtonStyle.expanded,
              ),
              height15,
              kTermsAndPrivacy(),
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
              controller: otp,
              autofocus: true,
              keyboardType: TextInputType.phone,
              autofillHints: [AutofillHints.telephoneNumber],
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 6,
                fontVariations: [
                  FontVariation.weight(700),
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
              onChanged: (value) => {
                if (value.length == 6) {setState(() {})}
              },
            ),
          ),
          _counter == 0
              ? IconButton(
                  onPressed: onSendOtp,
                  icon: Icon(
                    Icons.sync_sharp,
                    size: 25,
                    color: StatusText.info,
                  ),
                  visualDensity: VisualDensity.compact,
                )
              : Label(
                  "${_counter}s",
                  fontSize: 17,
                  weight: 600,
                ).subtitle,
        ],
      ),
    );
  }
}
