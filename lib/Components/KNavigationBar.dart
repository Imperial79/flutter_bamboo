import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/constants.dart';

ValueNotifier activePageNotifier = ValueNotifier(0);

class KNavigationBar extends StatelessWidget {
  String get navIconPath => "$kIconPath/navigation";
  const KNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return KCard(
      color: LColor.scaffold,
      radius: 0,
      child: SafeArea(
        child: Row(
          children: [
            btn(
              iconPath: "home",
              index: 0,
              label: "Home",
            ),
            btn(
              iconPath: "profile",
              index: 1,
              label: "Home",
            ),
            btn(
              iconPath: "profile",
              index: 2,
              label: "Home",
            ),
            btn(
              iconPath: "profile",
              index: 3,
              label: "Home",
            ),
          ],
        ),
      ),
    );
  }

  Widget btn({
    required String iconPath,
    required int index,
    required String label,
  }) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: activePageNotifier,
        builder: (context, activePage, _) {
          final selected = activePage == index;
          return IconButton(
            onPressed: () {
              activePageNotifier.value = index;
            },
            icon: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  selected
                      ? "$navIconPath/$iconPath-filled.svg"
                      : "$navIconPath/$iconPath.svg",
                  colorFilter: ColorFilter.mode(
                    selected ? LColor.primary : LColor.fadeText,
                    BlendMode.srcIn,
                  ),
                ),
                Label(
                  label,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? null : LColor.fadeText,
                ).regular,
              ],
            ),
          );
        },
      ),
    );
  }
}
