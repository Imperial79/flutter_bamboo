import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class Kolor {
  static const Color scaffold = Colors.white;
  static const Color primary = Color(0xFFE91E63); // pink
  // static const Color primary = Color(0xFF8BC34A); // light green
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

// final Map<String, Color> statusColorMap = {
//   "Ordered": StatusText.success,
//   "Success": StatusText.success,
//   "Shipped": StatusText.success,
//   "Delivered": StatusText.success,
//   "Return Pending": StatusText.warning,
//   "Refunded": StatusText.info,
//   "Cancelled": StatusText.danger,
// };

final Map<String, Color> statusColors = {
  "Success": Color(0xFF28A745), // Green
  "Delivered": Color(0xFF218838), // Dark Green
  "Completed": Color(0xFF20C997), // Teal Green
  "Ordered": Color(0xFF2CA02C), // Bright Green

  "Failed": Color(0xFFDC3545), // Red
  "Rejected": Color(0xFFC82333), // Dark Red
  "Cancelled": Color(0xFFFF0000), // Bright Red
  "Declined": Color(0xFFD9534F), // Soft Red

  "Pending": Color(0xFFFFC107), // Amber
  "Shipped": Color(0xFFF57C00), // Orange
  "Return Pending": Color(0xFFE67E22), // Pumpkin
  "Partially Completed": Color(0xFFFF9800), // Bright Orange

  "In Progress": Color(0xFF007BFF), // Blue
  "On Hold": Color(0xFF6C757D), // Grey
  "Under Review": Color(0xFF17A2B8), // Cyan
  "Waiting for Approval": Color(0xFF5A6268), // Dark Grey

  "Refunded": Color(0xFF6610F2), // Purple
  "Reversed": Color(0xFF8E44AD), // Dark Purple
  "Chargeback": Color(0xFF6F42C1), // Soft Purple
};
