import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KNavigationBar.dart';
import 'package:ngf_organic/Pages/Affiliate/Affiliate_UI.dart';
import 'package:ngf_organic/Pages/Home/Home_UI.dart';
import 'package:ngf_organic/Pages/Profile/Orders/Orders_UI.dart';
import 'package:ngf_organic/Pages/Profile/Profile_UI.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:animations/animations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Root_UI extends StatefulWidget {
  const Root_UI({super.key});

  @override
  State<Root_UI> createState() => _Root_UIState();
}

class _Root_UIState extends State<Root_UI> {
  final List<Widget> _screens = [
    const Home_UI(),
    const Affiliate_UI(),
    const Orders_UI(),
    const Profile_UI(),
  ];

  final List _navs = [
    {"label": "Home", "iconPath": "home", "index": 0},
    {"label": "Affiliate", "iconPath": "refer", "index": 1},
    {"label": "Orders", "iconPath": "box", "index": 2},
    {"label": "Profile", "iconPath": "profile", "index": 3},
  ];

  bool canPop = false;

  Future<void> onWillPop(didPop, result) async {
    setState(() {
      canPop = true;
    });
    KSnackbar(context, message: "Press back again to exit");

    await Future.delayed(
      Duration(seconds: 3),
      () {
        setState(() {
          canPop = false;
        });
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemColors();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onWillPop,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: activePageNotifier,
          builder: (context, activePage, _) {
            return PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Kolor.scaffold,
                  child: child,
                );
              },
              child: _screens[activePage],
            );
          },
        ),
        bottomNavigationBar: KNavigationBar(
          navList: _navs,
        ),
      ),
    );
  }
}
