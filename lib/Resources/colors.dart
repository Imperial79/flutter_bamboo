import 'package:flutter/material.dart';

class Kolor {
  static const Color scaffold = Colors.white;
  static const Color primary = Colors.lightGreen;
  static const Color secondary = Color(0xff2b2c43);
  static const Color tertiary = Color(0xFFE91E63);
  static const Color card = Color(0XFFf6f6f6);
  static const Color border = Color(0xFFBDBDBD);
  static const Color fadeText = Color(0xFF757575);
}

class StatusText {
  static const Color danger = Color(0xFFFF0000);
  static const Color success = Color.fromARGB(255, 0, 112, 26);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF1976D2);
  static const Color light = Color(0xFFf8f9fa);
  static const Color dark = Color(0xFF343a40);
}

Color kOpacity(Color color, double opacity) =>
    color.withAlpha((opacity * 255).round());

ColorScheme kColor(BuildContext context) => Theme.of(context).colorScheme;

ColorFilter kSvgColor(Color color) => ColorFilter.mode(color, BlendMode.srcIn);

final Map<String, Color> statusColorMap = {
  "Ordered": StatusText.success,
  "Shipped": StatusText.success,
  "Delivered": StatusText.success,
  "Return Pending": StatusText.warning,
  "Refunded": StatusText.info,
  "Cancelled": StatusText.danger,
};
