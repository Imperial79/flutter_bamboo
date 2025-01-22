import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

const String kFont = "Urbanist";

ColorScheme get kScheme => ColorScheme.fromSeed(
      seedColor: LColor.primary,
      brightness: Brightness.light,
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
          style: TextButton.styleFrom(foregroundColor: kScheme.tertiary)),
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: LColor.fadeText,
        ),
        surfaceTintColor: LColor.primary,
        backgroundColor: LColor.scaffold,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        selectedColor: kScheme.secondary,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: kScheme.primary,
        largeSize: 20,
        textStyle: TextStyle(
          fontSize: 15,
          fontVariations: [FontVariation.weight(600)],
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: LColor.primary,
        cursorColor: kScheme.primary,
        selectionColor: kScheme.secondaryContainer,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LColor.secondary,
        linearTrackColor: LColor.card,
        circularTrackColor: LColor.card,
        refreshBackgroundColor: LColor.card,
      ),
    );
