import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

const String kFont = "Urbanist";

ColorScheme get kScheme => ColorScheme.fromSeed(
      seedColor: LColor.primary,
      brightness: Brightness.light,
      surface: LColor.scaffold,
      onSurface: Colors.white,
    );

ThemeData kTheme(context) => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: LColor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LColor.primary,
        brightness: Brightness.light,
      ),
      fontFamily: kFont,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: LColor.primary)),
      appBarTheme: const AppBarTheme(
        backgroundColor: LColor.scaffold,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        selectedColor: kColor(context).secondary,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: LColor.primary,
        cursorColor: LColor.primary,
        selectionColor: kColor(context).tertiary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LColor.secondary,
        linearTrackColor: LColor.card,
        circularTrackColor: LColor.card,
        refreshBackgroundColor: LColor.card,
      ),
    );
