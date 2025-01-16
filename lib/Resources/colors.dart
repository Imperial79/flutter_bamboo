import 'package:flutter/material.dart';

class DColor {
  static const Color scaffold = Colors.white;
  static const Color primary = Color(0xff4bb298);
  static const Color secondary = Color(0xff2b2c43);
  static const Color card = Color(0XFFf6f6f6);
  static const Color border = Color(0xFFd6d8d7);
  static const Color fadeText = Color(0xFFd7d7d7);
}

class StatusText {
  static const Color danger = Color(0xFFFF0000);
  static const Color success = Color.fromARGB(255, 101, 255, 137);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17a2b8);
  static const Color light = Color(0xFFf8f9fa);
  static const Color dark = Color(0xFF343a40);
}

Color kOpacity(Color color, double opacity) =>
    color.withAlpha((opacity * 255).round());

ColorScheme kColor(BuildContext context) => Theme.of(context).colorScheme;

ColorFilter kSvgColor(Color color) => ColorFilter.mode(color, BlendMode.srcIn);
