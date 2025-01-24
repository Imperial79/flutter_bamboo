import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/Label.dart';

import 'package:flutter_bamboo/Components/kCard.dart';

import '../Resources/colors.dart';

class Pill {
  Widget? child;
  String label;
  Color backgroundColor;
  Color textColor;

  Pill({
    this.child,
    this.label = "text",
    this.backgroundColor = KColor.primary,
    this.textColor = Colors.white,
  });

  Widget get regular => KCard(
        child: child,
      );

  Widget get text => KCard(
        radius: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        color: backgroundColor,
        child: Label(label, weight: 800, color: textColor).regular,
      );
}
