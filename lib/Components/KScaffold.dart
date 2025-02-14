// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Resources/colors.dart';
import '../Resources/commons.dart';
import '../Resources/constants.dart';
import 'Label.dart';

// ignore: must_be_immutable
class KScaffold extends StatelessWidget {
  PreferredSizeWidget? appBar;
  final Widget body;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;
  Widget? floatingActionButton;
  Widget? bottomNavigationBar;
  ValueListenable<dynamic>? isLoading;
  List<Widget>? persistentFooterButtons;
  KScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.isLoading,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.persistentFooterButtons,
  });

  @override
  Widget build(BuildContext context) {
    systemColors();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isLoading ?? ValueNotifier(false),
        builder: (context, loading, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                persistentFooterButtons: persistentFooterButtons,
                appBar: appBar,
                body: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: body,
                ),
                floatingActionButtonAnimator: floatingActionButtonAnimator,
                floatingActionButtonLocation: floatingActionButtonLocation,
                floatingActionButton: floatingActionButton,
                bottomNavigationBar: bottomNavigationBar,
              ),
              _fullLoading(isLoading: loading),
            ],
          );
        },
      ),
    );
  }

  AnimatedSwitcher _fullLoading({required bool isLoading}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      child: isLoading
          ? Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: kOpacity(KColor.scaffold, .8),
              child: Center(
                child: KCard(
                  width: 300,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    spacing: 30,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(
                      //   height: 25,
                      //   width: 25,
                      //   child: CircularProgressIndicator(
                      //     strokeWidth: 3,
                      //     backgroundColor: kOpacity(KColor.scaffold, .1),
                      //     color: Colors.black,
                      //   ),
                      // ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(),
                          ),
                          SvgPicture.asset(
                            "$kIconPath/loading-panda.svg",
                            height: 50,
                          ),
                        ],
                      ),
                      // Label(
                      //   "Please Wait",
                      //   fontSize: 17,
                      //   weight: 550,
                      //   color: Colors.black,
                      // ).title,
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}

AppBar KAppBar(
  BuildContext context, {
  IconData? icon,
  String title = "",
  Widget? child,
  bool showBack = true,
  List<Widget>? actions,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: showBack ? 0 : kPadding,
    leadingWidth: 50,
    leading: showBack
        ? Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              ),
            ),
          )
        : null,
    title: child ??
        Label(
          title,
          fontSize: 18,
          weight: 600,
        ).title,
    actions: actions,
  );
}
