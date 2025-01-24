import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

const String kFont = "Montserrat";

ColorScheme get kScheme => ColorScheme.fromSeed(
      seedColor: KColor.primary,
      brightness: Brightness.light,
    );

ThemeData kTheme(context) => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: KColor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: KColor.primary,
        brightness: Brightness.light,
      ),
      fontFamily: kFont,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kScheme.tertiary)),
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: KColor.fadeText,
        ),
        surfaceTintColor: KColor.primary,
        backgroundColor: KColor.scaffold,
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
        selectionHandleColor: KColor.primary,
        cursorColor: kScheme.primary,
        selectionColor: kScheme.secondaryContainer,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: KColor.secondary,
        linearTrackColor: KColor.card,
        circularTrackColor: KColor.card,
        refreshBackgroundColor: KColor.card,
      ),
    );
