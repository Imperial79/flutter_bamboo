import 'package:flutter/material.dart';

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
    this.backgroundColor = LColor.primary,
    this.textColor = Colors.white,
  });

  Widget get regular => KCard(
        child: child,
      );

  Widget get text => KCard(
        radius: 100,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: backgroundColor,
        child: Text(
          label,
          style: TextStyle(
              color: textColor,
              fontVariations: const [FontVariation.weight(500)]),
        ),
      );
}
