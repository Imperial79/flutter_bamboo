import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/constants.dart';

ValueNotifier activePageNotifier = ValueNotifier(0);

class KNavigationBar extends StatelessWidget {
  final List navList;
  String get navIconPath => "$kIconPath/navigation";
  const KNavigationBar({super.key, required this.navList});

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: EdgeInsets.all(10),
      borderWidth: 1,
      color: KColor.scaffold,
      radius: 0,
      child: SafeArea(
        child: Row(
          children: navList
              .map(
                (e) => btn(
                    iconPath: e['iconPath'],
                    index: e['index'],
                    label: e['label']),
              )
              .toList(),
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
              spacing: 7,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  selected
                      ? "$navIconPath/$iconPath-filled.svg"
                      : "$navIconPath/$iconPath.svg",
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    selected ? KColor.primary : KColor.fadeText,
                    BlendMode.srcIn,
                  ),
                ),
                Label(
                  label,
                  weight: selected ? 700 : 600,
                  color: selected ? null : KColor.fadeText,
                  fontSize: 13,
                ).regular,
              ],
            ),
          );
        },
      ),
    );
  }
}
