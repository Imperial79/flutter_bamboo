import 'package:flutter/material.dart';
import 'package:ngf_organic/Resources/colors.dart';

const String kFont = "Montserrat";

ThemeData kTheme(context) => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Kolor.scaffold,
      splashFactory: InkSplash.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Kolor.primary,
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
          color: Kolor.fadeText,
        ),
        surfaceTintColor: Kolor.primary,
        backgroundColor: Kolor.scaffold,
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
        selectionHandleColor: Kolor.primary,
        cursorColor: kColor(context).primary,
        selectionColor: kColor(context).secondaryContainer,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Kolor.secondary,
        linearTrackColor: Kolor.card,
        circularTrackColor: Kolor.card,
        refreshBackgroundColor: Kolor.card,
      ),
    );
