import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

const String kFont = "Kumbh";

ColorScheme get kScheme => ColorScheme.fromSeed(
      seedColor: DColor.primary,
      brightness: Brightness.dark,
      surface: DColor.scaffold,
      onSurface: Colors.white,
    );

ThemeData kTheme(context) => ThemeData(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: DColor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DColor.primary,
      ).copyWith(
        brightness: Brightness.dark,
        onSurface: Colors.white,
        surface: DColor.card,
      ),
      textTheme: Typography().white.apply(fontFamily: kFont),
      iconTheme: const IconThemeData(color: Colors.white),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: DColor.primary)),
      appBarTheme: const AppBarTheme(
        backgroundColor: DColor.scaffold,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      chipTheme: ChipThemeData(
        selectedColor: kColor(context).secondary,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: DColor.primary,
        cursorColor: DColor.primary,
        selectionColor: kColor(context).tertiary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: DColor.primary,
        linearTrackColor: DColor.card,
        circularTrackColor: DColor.card,
        refreshBackgroundColor: DColor.card,
      ),
    );
