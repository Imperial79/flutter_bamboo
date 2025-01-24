// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

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
  KScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.isLoading,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.bottomNavigationBar,
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
          }),
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
              color: KColor.scaffold.withAlpha((.8 * 255).round()),
              child: Center(
                child: KCard(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    spacing: 30,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: KColor.primary,
                        ),
                      ),
                      Label("Please Wait", fontSize: 17, weight: 400).title,
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
  context, {
  IconData? icon,
  String? title = "title",
  Widget? child,
  bool showBack = true,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: KColor.scaffold,
    automaticallyImplyLeading: false,
    titleSpacing: showBack ? 0 : kPadding,
    leadingWidth: 70,
    leading: showBack
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_back))
        : null,
    title: child ??
        Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(icon),
              ),
            Label(
              title!,
              fontStyle: FontStyle.italic,
              fontSize: 27,
              weight: 600,
              color: Colors.white,
            ).title,
          ],
        ),
    actions: actions,
  );
}
