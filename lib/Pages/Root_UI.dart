import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KNavigationBar.dart';
import 'package:flutter_bamboo/Pages/Home/Home_UI.dart';
import 'package:flutter_bamboo/Pages/Profile/Profile_UI.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:animations/animations.dart';

class Root_UI extends StatefulWidget {
  const Root_UI({super.key});

  @override
  State<Root_UI> createState() => _Root_UIState();
}

class _Root_UIState extends State<Root_UI> {
  final List<Widget> _screens = [
    const Home_UI(),
    const Home_UI(),
    const Home_UI(),
    const Profile_UI(),
  ];
  @override
  Widget build(BuildContext context) {
    systemColors();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: activePageNotifier,
        builder: (context, activePage, _) {
          return PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: LColor.scaffold,
                child: child,
              );
            },
            child: _screens[activePage],
          );
        },
      ),
      bottomNavigationBar: const KNavigationBar(),
    );
  }
}
