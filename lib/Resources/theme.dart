import 'package:flutter/material.dart';
import 'package:ngf_organic/Resources/colors.dart';

const String kFont = "Montserrat";

ThemeData kTheme(context) => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: KColor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: KColor.primary,
        dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
        brightness: Brightness.light,
      ),
      fontFamily: kFont,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kColor(context).primary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: KColor.fadeText,
        ),
        surfaceTintColor: KColor.primary,
        backgroundColor: KColor.scaffold,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        selectedColor: kColor(context).secondary,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: kColor(context).primary,
        largeSize: 20,
        textStyle: TextStyle(
          fontSize: 15,
          fontVariations: [FontVariation.weight(600)],
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: KColor.primary,
        cursorColor: kColor(context).primary,
        selectionColor: kColor(context).secondaryContainer,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: KColor.secondary,
        linearTrackColor: KColor.card,
        circularTrackColor: KColor.card,
        refreshBackgroundColor: KColor.card,
      ),
    );
