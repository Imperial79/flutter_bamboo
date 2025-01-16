import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

const String kFont = "Kumbh";

ColorScheme get kScheme => ColorScheme.fromSeed(
      seedColor: DColor.primary,
      brightness: Brightness.light,
      surface: DColor.scaffold,
      onSurface: Colors.white,
    );

ThemeData kTheme(context) => ThemeData(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: DColor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DColor.primary,
      ).copyWith(
        brightness: Brightness.light,
        onSurface: Colors.white,
        surface: DColor.card,
      ),
      textTheme: Typography().white.apply(fontFamily: kFont),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: DColor.primary)),
      appBarTheme: const AppBarTheme(
        backgroundColor: DColor.scaffold,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        selectedColor: kColor(context).secondary,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: DColor.primary,
        cursorColor: DColor.primary,
        selectionColor: kColor(context).tertiary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: DColor.secondary,
        linearTrackColor: DColor.card,
        circularTrackColor: DColor.card,
        refreshBackgroundColor: DColor.card,
      ),
    );
